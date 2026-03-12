import 'package:chat_flow/core/network/app_api_client.dart';
import 'package:chat_flow/core/network/api_result.dart';
import 'package:chat_flow/core/utils/device_utils.dart' as DeviceUtils;
import 'package:dio/dio.dart';

class AuthRepository {
  final AppApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<bool> getConfig() async {

    final result = await apiClient.post(
      "/api/v1/auth/index.php",
      contentType: Headers.formUrlEncodedContentType,
      data: {
        "action": "config"
      },
    );

    if (result is Success) {
      final data = result.data;

      return data["public_registration_enabled"] ?? false;
    }

    if (result is Failure) {
      throw Exception(result.error);
    }

    throw Exception("Unknown error");
  }

  Future<AppApiResult> requestPairing() async {
    String deviceUUID = await DeviceUtils.getDeviceUUID();

   final result= await apiClient.post(
      '/api/v1/auth/index.php',
      data: {
        "action": "request_pairing",
        "device_uuid": deviceUUID,
      },
      contentType: Headers.formUrlEncodedContentType,
    );
   return result;
  }
  Future<AppApiResult> requestOtp({required String mobile}) async {

    final result= await apiClient.post(
      '/api/v1/auth/index.php',
      data: {
        "action": "request_otp",
        "mobile":mobile,
      },
      contentType: Headers.formUrlEncodedContentType,
    );
    return result;
  }

  Future<AppApiResult> requestPublicRegistration({required String mobile,required String otp,required String name,required String publicKey,required String deviceSyncToken}) async {
    String deviceUUID = await DeviceUtils.getDeviceUUID();

    final result= await apiClient.post(
      '/api/v1/auth/index.php',
      data: {
        "action": "register_public",
        'mobile':mobile,
        'otp':otp,
        'name':name,
        "device_uuid": deviceUUID,
        "public_key":publicKey,
        'device_sync_token':deviceSyncToken
      },
      contentType: Headers.formUrlEncodedContentType,
    );
    return result;
  }

  Future<AppApiResult> uploadKeys({
    required int userId,
    required String publicKey,
    required String deviceSyncToken,
  }) async {
    final deviceUuid = await DeviceUtils.getDeviceUUID();

    final result = await apiClient.post(
      '/api/v1/auth/index.php',
      data: {
        'action': 'upload_keys',
        'user_id': userId.toString(),
        'device_uuid': deviceUuid,
        'public_key': publicKey,
        'device_sync_token': deviceSyncToken,
      },
      contentType: Headers.formUrlEncodedContentType,
    );

    if (result is Success) {
      // uploaded successfully, nothing to return
      return Success(result.data);
    } else if (result is Failure) {
      return Failure(result.error) ;


    }
    else{
      throw Exception('some thing went wrong');
    }
  }
  Future<AppApiResult> checkPairing({
    required String code,
  }) async {
    final deviceUUID = await DeviceUtils.getDeviceUUID();

    final result = await apiClient.post(
      '/api/v1/auth/index.php',
      data: {
        "action": "check_pairing",
        "code": code,
        "device_uuid": deviceUUID,
      },
      contentType: Headers.formUrlEncodedContentType,
    );

    return result;
  }

}