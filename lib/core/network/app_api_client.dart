import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_flow/auth_events.dart';
import 'package:chat_flow/core/constants/app_constants.dart';
import 'package:chat_flow/core/services/app_log_service.dart';
import 'package:chat_flow/core/services/shared_prefrences_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_result.dart';

class AppApiClient {
  final Dio _dio;

  AppApiClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: 40),
      receiveTimeout: Duration(seconds: 50),
    ),
  ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader:true,
        requestBody: true,
        responseBody: true,
      ),
    );
    _dio.interceptors.add(AuthInterceptor());
  }

  AppApiResult<dynamic> _handleError(DioException error) {
    String message;

    if (error.response != null) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        // Check for backend error format with 'shstatus' and 'message'
        if (data.containsKey('shstatus') && data['shstatus'] == 'failure') {
          message = data['message'] ?? "An error occurred";
        } else if (data.containsKey('message')) {
          message = data['message'];
        } else {
          message = "An unknown server error occurred.";
        }
      } else if (data is String) {
        message = data;
      } else {
        message = "An unknown server error occurred.";
      }
    }
    // Handle network/timeout errors
    else if (error.type == DioExceptionType.connectionTimeout) {
      message = "Connection Timeout. Please try again.";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = "Receive Timeout. Please try again.";
    } else if (error.type == DioExceptionType.badResponse) {
      message = "Bad Response. Something went wrong.";
    } else if (error.type == DioExceptionType.cancel) {
      message = "Request was cancelled.";
    } else if (error.type == DioExceptionType.unknown) {
      message = "No internet connection. Please check your network.";
    } else {
      message = "Unexpected error. Please try again.";
    }

    return Failure(message);
  }

  Future<AppApiResult<dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
         print('response${response.data}');
      // Check if response contains failure status
      if (response.data is Map<String, dynamic> &&
          response.data['shstatus'] == 'failure') {
        return Failure(response.data['message'] ?? "Request failed");
      }

      return Success(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<AppApiResult<dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? data,
        bool isFormData = false,
        String contentType=Headers.jsonContentType
      })
  async {
    try {
      dynamic body = data;

      if (isFormData && data != null) {
        body = FormData.fromMap({
          for (final entry in data.entries)
            entry.key: await _mapToFormField(entry.value),
        });
      }

      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          contentType: isFormData
              ? null
              :contentType,
        ),
      );
        print('response ${response.data}');
      if (response.data is Map<String, dynamic> &&
          response.data['shstatus'] == 'failure') {
        return Failure(response.data['message'] ?? "Request failed");
      }

      return Success(response.data);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }
  Future<AppApiResult<dynamic>> postWithMultipleImages(String endpoint, dynamic data,
      {Map<String, dynamic>? files})
  async {
    try {
      dynamic requestData;
      Options options = Options();

      if (files != null && files.isNotEmpty) {
        Map<String, dynamic> fileMap = {};

        for (var entry in files.entries) {
          final key = entry.key;
          final value = entry.value;

          // 🔄 Handle list of images
          if (value is List) {
            List<MultipartFile> multipartList = [];

            for (int i = 0; i < value.length; i++) {
              final item = value[i];
              if (kIsWeb && item is Uint8List) {
                multipartList.add(MultipartFile.fromBytes(
                  item,
                  filename: "$key-$i.jpg",
                ));
              } else if (item is File) {
                final fileName = item.path.split('/').last;
                multipartList.add(await MultipartFile.fromFile(
                  item.path,
                  filename: fileName,
                ));
              }
            }

            fileMap[key] = multipartList;
          }

          // 🔄 Handle single image
          else {
            if (kIsWeb && value is Uint8List) {
              fileMap[key] = MultipartFile.fromBytes(
                value,
                filename: "$key.jpg",
              );
            } else if (value is File) {
              String fileName = value.path.split('/').last;
              fileMap[key] = await MultipartFile.fromFile(
                value.path,
                filename: fileName,
              );
            }
          }
        }

        requestData = FormData.fromMap({...data, ...fileMap});
        options.contentType = Headers.multipartFormDataContentType;
      } else {
        // Send raw JSON data
        requestData = jsonEncode(data);
        options.contentType = Headers.jsonContentType;
      }

      log('request data: $requestData');

      Response response = await _dio.post(endpoint, data: requestData, options: options);
      LogService.info("✅ Response: \n $endpoint ${response.data}");

      return Success(response.data);
    } on DioException catch (e) {
      LogService.error("❌ API Error: $endpoint", e, e.stackTrace);
      return _handleError(e);
    }
  }

  Future<dynamic> _mapToFormField(dynamic value) async {
    print("🧪 _mapToFormField called with: $value (${value.runtimeType})");

    if (value == null) {
      print("⚠️ Value is NULL");
      return null;
    }

    // If value is File
    if (value is File) {
      final fileName = value.path.split('/').last;
      print("📂 File detected → path: ${value.path} | name: $fileName");

      final file = await MultipartFile.fromFile(
        value.path,
        filename: fileName,
      );

      print("✅ Returning MultipartFile for: $fileName");
      return file;
    }

    // If value is file path string
    if (value is String && value.startsWith('/')) {
      print("📌 String path detected: $value");

      final file = File(value);

      if (await file.exists()) {
        final fileName = file.path.split('/').last;
        print("📂 File exists → path: ${file.path} | name: $fileName");

        final mpFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );

        print("✅ Returning MultipartFile for: $fileName");
        return mpFile;
      } else {
        print("❌ File does NOT exist at: $value");
      }
    }

    print("➡️ Normal value detected: $value");
    return value;
  }
}

class AuthInterceptor extends Interceptor {
  static bool _isRefreshing = false;
  static final List<Function> _pendingRequests = [];

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    String? token = await SharedPrefsService.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode == 401) {
      print('🔄 Token expired - attempting refresh');

      if (_isRefreshing) {
        print('⏳ Token refresh already in progress, rejecting request');
        return handler.next(err);
      }

      _isRefreshing = true;

      String? refreshToken = await SharedPrefsService.getRefreshToken();

      if (refreshToken == null) {
        print('❌ No refresh token available');
        _isRefreshing = false;
        await _handleLogout();
        return handler.next(err);
      }

      try {
        print('📤 Sending refresh token request');

        // Create a new Dio instance with proper base configuration
        final response = await Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: Duration(seconds: 40),
            receiveTimeout: Duration(seconds: 50),
          ),
        ).post(
          "/auth/refresh-token",
          data: {"refreshToken": refreshToken},
          options: Options(contentType: Headers.jsonContentType),
        );

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;

          if (data['shstatus'] == 'failure') {
            print('❌ Token refresh failed: ${data['message']}');
            _isRefreshing = false;
            await _handleLogout();
            return handler.next(err);
          }

          final newAccessToken = data["accessToken"];
          final newRefreshToken = data["refreshToken"];

          if (newAccessToken != null && newRefreshToken != null) {
            print('✅ Token refreshed successfully');

            await SharedPrefsService.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Update the failed request's authorization header
            err.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';

            _isRefreshing = false;

            print('🔁 Retrying original request');

            // Retry the original request with the SAME Dio instance from the error
            // This ensures we use the correct baseUrl and interceptors
            try {
              final retryResponse = await Dio(
                BaseOptions(
                  baseUrl: AppConstants.apiBaseUrl,
                  connectTimeout: Duration(seconds: 40),
                  receiveTimeout: Duration(seconds: 50),
                ),
              ).fetch(err.requestOptions);

              print('✅ Original request succeeded after token refresh');
              return handler.resolve(retryResponse);
            } catch (retryError) {
              print('⚠️ Retry failed but NOT a token issue: $retryError');
              // Don't logout on retry errors - just pass them through
              // This allows the app to handle 404s, validation errors, etc. normally
              if (retryError is DioException) {
                return handler.next(retryError);
              }
              return handler.next(err);
            }
          }
        }

        print('❌ Unexpected response format from refresh endpoint');
        _isRefreshing = false;
        await _handleLogout();
        return handler.next(err);
      } catch (e) {
        print("❌ Token refresh error: $e");
        _isRefreshing = false;

        // Only logout if the refresh request itself failed with 401
        // Don't logout for other errors like network issues
        if (e is DioException && e.response?.statusCode == 401) {
          await _handleLogout();
        }

        return handler.next(err);
      }
    }

    return handler.next(err);
  }






  Future<void> _handleLogout() async {
    print('🔴 Unable to refresh token - clearing tokens');

    await SharedPrefsService.clearTokens();

    print('✅ Tokens cleared');

    AuthEvents.fire(AuthEventType.unauthorized);

    print('✅ Unauthorized event fired');

    await Future.delayed(Duration(milliseconds: 100));
  }
}