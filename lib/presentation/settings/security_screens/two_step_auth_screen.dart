import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class TwoStepAuthScreen extends StatefulWidget {
  const TwoStepAuthScreen({super.key});

  @override
  State<TwoStepAuthScreen> createState() => _TwoStepAuthScreenState();
}

class _TwoStepAuthScreenState extends State<TwoStepAuthScreen> {
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
      appBar: AppBar(
        title: Text(trans(context, key: trans(context, key: 'two_step_authentication'))),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 15, vertical: 20),
        children: [
          spacing(height: 30),
          const ImageWidget(
              image: AssetsConst.secureShield,
              height: 150,
              type: ImageType.asset),
          spacing(height: 15),
          Text(
            trans(context, key: 'secure_your_account'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleLarge(context),
          ),
          spacing(height: 10),
          Text(
            trans(context, key: 'add_an_extra_layer_of_security_by_setting'),
            textAlign: TextAlign.center,
            style: StyleHelper.titleSmall(context),
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
              child: CustomButton(title: trans(context, key: 'set_pin'), width: 140, onTap: () {})),
          spacing(height: 30),
        ],
      ),
    );
  }
}
