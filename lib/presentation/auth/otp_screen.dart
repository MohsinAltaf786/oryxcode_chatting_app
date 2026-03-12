import 'package:chat_flow/core/bloc/config_bloc/config_bloc.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_event.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_state.dart';
import 'package:chat_flow/core/bloc/models/public_registration_model.dart';
import 'package:chat_flow/core/bloc/otp_bloc/otp_event.dart';
import 'package:chat_flow/core/bloc/otp_bloc/otp_state.dart';
import 'package:chat_flow/core/bloc/otp_bloc/otp_timer_bloc.dart';
import 'package:chat_flow/core/services/app_snackbar_service.dart';
import 'package:chat_flow/core/services/device_key_service.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/dashboard.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key,this.publicRegistrationModel});
 final PublicRegistrationModel? publicRegistrationModel;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OtpTimerBloc>().add(StartOtpTimer(60));
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const length = 6;
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 60,
      textStyle: StyleHelper.titleLarge(
        context,
      )?.copyWith(fontWeight: FontWeight.w500),
      decoration: BoxDecoration(
        color: isDarkTheme(context) ? Colors.white10 : AppColors.grey20,
        borderRadius: .circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const .symmetric(horizontal: 20),
        children: [
          spacing(height: 20),
          Text(
            trans(context, key: 'verify_phone'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleLarge(
              context,
            )?.copyWith(fontWeight: FontWeight.w500),
          ),
          spacing(height: 10),
          if (widget.publicRegistrationModel!=null&& (widget.publicRegistrationModel!.mobile??'').isNotEmpty)
            Text(
              '${trans(context, key: 'code_has_been_send_to')} ${widget.publicRegistrationModel!.mobile??''}',
              textAlign: TextAlign.center,
              style: StyleHelper.titleMedium(context),
            ),
          spacing(height: 30),
          Pinput(
            length: length,
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              height: 68,
              width: 64,
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.primary),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: .circular(8),
              ),
            ),
          ),
          spacing(height: 30),
          BlocConsumer<ConfigBloc, ConfigState>(
            listener: (context, state) {
              if (state is PublicRegistrationSuccess) {
                navigateToScreen(
                  context,
                  const Dashboard(),
                  clearPreviousRoutes: true,
                );
              }

              if (state is ConfigError) {
                AppSnackBarService.showTopSnackbar(
                  message: state.message,
                  context: context,
                );
              }
            },
            builder: (context, state) {
              bool isLoading = state is ConfigLoading;

              return Center(
                child: CustomButton(
                  title: trans(context, key: 'verify'),
                  width: 250,
                  fontSize: 16,
                  yPadding: 12,
                  loading: isLoading,
                  onTap: () async {

                    if (controller.text.isEmpty) {
                      AppSnackBarService.showTopSnackbar(
                        message: 'Please enter six digit OTP!',
                        context: context,
                      );
                      return;
                    }

                    final keys = await DeviceKeyService.generateDeviceKeys();

                    context.read<ConfigBloc>().add(
                      RequestPublicRegistrationEvent(
                        mobile: widget.publicRegistrationModel?.mobile ?? '',
                        otp: controller.text,
                        name: widget.publicRegistrationModel?.name ?? '',
                        publicKey: keys['public_key'] ?? '',
                        deviceSyncToken: keys['device_sync_token'] ?? '',
                      ),
                    );
                  },
                ),
              );
            },
          ),
          spacing(height: 30),
          Text(
            trans(context, key: 'didn_t_get_otp_code'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleSmall(context),
          ),
          BlocBuilder<OtpTimerBloc, OtpTimerState>(
            builder: (context, state) {
              if (state is OtpTimerRunning) {
                return Text(
                  "Resend code in ${state.secondsRemaining}s",
                  textAlign: TextAlign.center,
                );
              }

              if (state is OtpTimerFinished) {
                return Center(
                  child: CustomButton(
                    title: trans(context, key: 'resend_code'),
                    color: Colors.transparent,
                    textColor: AppColors.primary,
                    onTap: () {
                      /// resend OTP
                      context.read<ConfigBloc>().add(
                        RequestOtpEvent(mobileNumber: widget.publicRegistrationModel!.mobile??''),
                      );

                      /// restart timer
                      context.read<OtpTimerBloc>().add(StartOtpTimer(60));
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
