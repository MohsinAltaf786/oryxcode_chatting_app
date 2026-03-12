import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ImageWidget(
            image: getLogoPath(context), type: ImageType.asset, height: 35),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const .symmetric(horizontal: 20),
        children: [
          spacing(height: 80),
          _buildBanner(),
          spacing(height: 30),
          _buildTitle(),
          spacing(height: 40),
          _buildForm(),
          spacing(height: 30),
          _buildButtons(),
          spacing(height: 20),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return const ImageWidget(
            image: AssetsConst.forgotPass, height: 180, type: ImageType.asset)
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
      trans(context, key: 'forgot_password'),
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
        Text(trans(context, key: 'email_address'),
            style: StyleHelper.titleMedium(context)),
        spacing(height: 7),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: fieldDeco(
              hintText: trans(context, key: 'enter_email_id'),
              prefixIcon: TablerIcons.mail),
        ),
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

  Widget _buildButtons() {
    return Center(
      child: CustomButton(
          title: trans(context, key: 'submit'),
          rightIcon: TablerIcons.send,
          fontSize: 16,
          yPadding: 12,
          width: 320,
          onTap: () {}),
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
}
