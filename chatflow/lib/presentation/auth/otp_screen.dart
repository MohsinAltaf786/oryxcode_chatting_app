import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/dashboard.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

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
      textStyle: StyleHelper.titleLarge(context)
          ?.copyWith(fontWeight: FontWeight.w500),
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
            style: StyleHelper.titleLarge(context)
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          spacing(height: 10),
          Text(
            '${trans(context, key: 'code_has_been_send_to')} +91 9876543210',
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
          Center(
              child: CustomButton(
                  title: trans(context, key: 'verify'),
                  width: 250,
                  fontSize: 16,
                  yPadding: 12,
                  onTap: () {
                    navigateToScreen(context, const Dashboard(),
                        clearPreviousRoutes: true);
                  })),
          spacing(height: 30),
          Text(
            trans(context, key: 'didn_t_get_otp_code'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleSmall(context),
          ),
          Center(
              child: CustomButton(
                  title: trans(context, key: 'resend_code'),
                  color: Colors.transparent,
                  textColor: AppColors.primary,
                  onTap: () {}))
        ],
      ),
    );
  }
}
