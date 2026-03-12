import 'package:chat_flow/core/network/api_result.dart';
import 'package:chat_flow/core/repository/auth_repository.dart';
import 'package:chat_flow/core/services/shared_prefrences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config_event.dart';
import 'config_state.dart';

import 'package:chat_flow/core/network/api_result.dart';
import 'package:chat_flow/core/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config_event.dart';
import 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final AuthRepository repository;

  ConfigBloc(this.repository) : super(ConfigInitial()) {
    // Load app config
    on<LoadConfigEvent>((event, emit) async {
      emit(ConfigLoading());
      try {
        final result = await repository.getConfig();
        emit(ConfigLoaded(result));
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });

    // Request pairing code
    on<RequestPairingEvent>((event, emit) async {
      emit(ConfigLoading());
      try {
        final result = await repository.requestPairing();
        if (result is Success) {
          final code = result.data['code'];
          emit(PairingCodeLoaded(code));

          // Start polling for approval
          add(CheckPairingEvent(code));
        }
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });

    // Poll for admin approval
    on<CheckPairingEvent>((event, emit) async {
      try {
        bool approved = false;
        int retries = 0;
        const maxRetries = 40; // ~2 minutes max polling

        while (!approved && retries < maxRetries) {
          await Future.delayed(const Duration(seconds: 3));
          retries++;

          final result = await repository.checkPairing(code: event.code);
          if (result is Success) {
            if (result.data['status'] == 'approved') {
              final userId = result.data['user_id'];

              // Emit approved state without system public key
              emit(PairingApproved(userId: userId.toString()));

              approved = true;
            }
          }
        }

        if (!approved) {
          emit(ConfigError("Pairing not approved within timeout"));
        }
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });

    // Upload keys
    on<UploadKeysEvent>((event, emit) async {
      emit(ConfigLoading());
      try {
        print(
          'Uploading keys -> userId: ${event.userId}, publicKey: ${event.publicKey}, deviceSyncToken: ${event.deviceSyncToken}',
        );

        final result = await repository.uploadKeys(
          userId: event.userId,
          publicKey: event.publicKey,
          deviceSyncToken: event.deviceSyncToken,
        );
        if (result is Success) {
          emit(KeysUploaded(success: result.data['success']));
        }
        // Successfully uploaded keys, you can emit a state or navigate in UI
        // optional, just to signal success
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });

    /// request otp
    on<RequestOtpEvent>((event, emit) async {
      emit(ConfigLoading());
      try {
        print('mobile number -> ${event.mobileNumber}');

        final result = await repository.requestOtp(mobile: event.mobileNumber);
        if (result is Success) {
          emit(OtpRequested(success: true));
        }
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });

    /// public registration
    on<RequestPublicRegistrationEvent>((event, emit) async {
      emit(ConfigLoading());
      try {
        print('mobile number -> ${event.mobile}');
        final result = await repository.requestPublicRegistration(
          mobile:event.mobile,
          otp:event.otp,
          name:event.name,
          publicKey:event.publicKey,
          deviceSyncToken:event.deviceSyncToken,
        );
        if (result is Success) {
          await SharedPrefsService.saveTokens(accessToken:result.data['token'],);
          emit(PublicRegistrationSuccess(success: true));
        }
        else if(result is Failure){
          emit(ConfigError(result.error));
        }
      } catch (e) {
        emit(ConfigError(e.toString()));
      }
    });
  }
}
