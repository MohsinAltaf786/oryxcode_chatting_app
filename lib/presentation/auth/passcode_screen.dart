import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String enteredPin = '';
  final int pinLength = 4;

  void _onKeyPress(String value) {
    if (enteredPin.length < pinLength) {
      setState(() {
        enteredPin += value;
      });

      if (enteredPin.length == pinLength) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            enteredPin = '';
          });
        });
      }
    }
  }

  void _onBackspacePress() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ImageWidget(
            image: getLogoPath(context), type: ImageType.asset, height: 35),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Expanded(flex: 2, child: _buildTopSection()),
            Expanded(
              flex: 7,
              child: Center(
                child: Padding(
                  padding: const .symmetric(horizontal: 32),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      if (index < 9) {
                        return _buildNumberButton((index + 1).toString());
                      } else if (index == 9) {
                        return _buildFingerprintButton();
                      } else if (index == 10) {
                        return _buildNumberButton('0');
                      } else {
                        return _buildBackspaceButton();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onKeyPress(number),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkTheme(context)
              ? AppColors.white.withValues(alpha: 0.05)
              : AppColors.primaryLight.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Text(
            number,
            style: StyleHelper.headlineLarge(context)?.copyWith(
                color: isDarkTheme(context)
                    ? Colors.white
                    : AppColors.primaryDark),
          ),
        ),
      ),
    );
  }

  Widget _buildFingerprintButton() {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Icon(TablerIcons.fingerprint,
            size: 35,
            color: isDarkTheme(context)
                ? AppColors.primary
                : AppColors.primaryDark),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspacePress,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Icon(TablerIcons.backspace,
            size: 35,
            color: isDarkTheme(context)
                ? AppColors.primary
                : AppColors.primaryDark),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(
          '${trans(context, key: 'welcome_back_comma')} James!',
          style: StyleHelper.titleLarge(context),
        ),
        spacing(height: 25),
        Row(
          mainAxisAlignment: .center,
          children: List.generate(pinLength, (index) {
            bool isFilled = index < enteredPin.length;
            return AnimatedContainer(
              margin: const .symmetric(horizontal: 8),
              duration: const Duration(milliseconds: 100),
              width: isFilled ? 16 : 14,
              height: isFilled ? 16 : 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < enteredPin.length
                    ? AppColors.primary
                    : Colors.grey[300],
              ),
            );
          }),
        )
      ],
    );
  }
}
