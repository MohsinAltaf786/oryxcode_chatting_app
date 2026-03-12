import 'package:chat_flow/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color color; // The color of the circular indicator.
  final double size; // The size of the circular indicator.
  final double stroke; // The width of the circular indicator's stroke.

  const CustomLoader(
      {super.key,
      this.color = AppColors.primary,
      this.size = 20,
      this.stroke = 2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: stroke,
      ),
    );
  }
}
