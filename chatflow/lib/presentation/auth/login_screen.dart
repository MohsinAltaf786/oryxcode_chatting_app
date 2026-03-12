import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/auth/forgot_password.dart';
import 'package:chat_flow/presentation/auth/otp_screen.dart';
import 'package:chat_flow/presentation/auth/sign_up_screen.dart';
import 'package:chat_flow/presentation/dashboard.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../core/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  int _loginWith = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ImageWidget(
            image: getLogoPath(context), type: ImageType.asset, height: 35),
      ),
      body: SafeArea(
        child: ListView(
          padding: const .symmetric(horizontal: 20),
          children: [
            spacing(height: 30),
            _buildBanner(),
            spacing(height: 30),
            _buildTitle(),
            spacing(height: 20),
            _buildForm(),
            spacing(height: 5),
            _buildButtons(),
            spacing(height: 20),
            _buildSignUp(),
            spacing(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return const ImageWidget(
            image: AssetsConst.login, height: 180, type: ImageType.asset)
        .animate(
          delay: const Duration(milliseconds: 200),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildTitle() {
    return Text(
      trans(context, key: 'welcome_back'),
      textAlign: TextAlign.center,
      style: StyleHelper.headlineSmall(context)
          ?.copyWith(fontWeight: FontWeight.w600),
    )
        .animate(
          delay: const Duration(milliseconds: 400),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        segmentedControl(),
        spacing(height: 20),
        if (_loginWith == 0) emailPassForm() else phoneForm(),
      ],
    )
        .animate(
          delay: const Duration(milliseconds: 500),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget emailPassForm() {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDeco(
            label: trans(context, key: 'email'),
            hintText: trans(context, key: 'enter_your_email'),
            prefixIcon: TablerIcons.mail,
            prefixIconColor: AppColors.grey60,
          ),
        ),
        spacing(height: 20),
        TextFormField(
          obscureText: !showPassword,
          keyboardType: TextInputType.text,
          decoration: fieldDeco(
              label: trans(context, key: 'password'),
              hintText: trans(context, key: 'enter_password'),
              prefixIcon: TablerIcons.lock,
              prefixIconColor: AppColors.grey60,
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                      showPassword ? TablerIcons.eye : TablerIcons.eye_off))),
        ),
        Row(
          mainAxisAlignment: .end,
          children: [
            CustomButton(
                title: trans(context, key: 'forgot_password'),
                color: Colors.transparent,
                textColor: ColorHelper.titleSmallColor(context),
                onTap: () {
                  navigateToScreen(context, const ForgotPassword());
                }),
          ],
        )
      ],
    );
  }

  Widget phoneForm() {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: fieldDeco(
            label: trans(context, key: 'phone_number'),
            hintText: trans(context, key: 'enter_your_phone'),
            prefixWidget: CountryCodePicker(
              onChanged: print,
              showOnlyCountryWhenClosed: false,
              dialogBackgroundColor:
                  isDarkTheme(context) ? AppColors.darkBg : AppColors.white,
              alignLeft: false,
            ),
          ),
        ),
        spacing(height: 20)
      ],
    );
  }

  Widget _buildButtons() {
    return Center(
      child: CustomButton(
          title: trans(context, key: 'continue'),
          rightIcon: TablerIcons.arrow_right,
          fontSize: 16,
          yPadding: 12,
          width: double.infinity,
          onTap: () {
            if (_loginWith == 0) {
              navigateToScreen(context, const Dashboard(),
                  clearPreviousRoutes: true);
            } else {
              navigateToScreen(context, const OtpScreen());
            }
          }),
    )
        .animate(
          delay: const Duration(milliseconds: 700),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildSignUp() {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text(
          trans(context, key: 'dont_have_an_account'),
          style: StyleHelper.titleSmall(context),
        ),
        spacing(width: 8),
        GestureDetector(
          onTap: () {
            navigateToScreen(context, const SignUpScreen());
          },
          behavior: HitTestBehavior.opaque,
          child: Text(trans(context, key: 'sign_up'),
              style: StyleHelper.titleSmall(context)
                  ?.copyWith(color: AppColors.primary)),
        ),
      ],
    )
        .animate(
          delay: const Duration(milliseconds: 800),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget segmentedControl() {
    return Center(
      child: CupertinoSlidingSegmentedControl<int>(
        children: {
          0: Text(trans(context, key: 'email')),
          1: Text(trans(context, key: 'phone')),
        },
        groupValue: _loginWith,
        onValueChanged: (int? newValue) {
          setState(() {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            _loginWith = newValue!;
          });
        },
      ),
    );
  }
}
