import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ActionIconButton extends StatelessWidget {
  const ActionIconButton(
      {super.key,
      required this.icon,
      this.size = 22,
      this.iconColor,
      this.backgroundColor,
      required this.onPressed,
      this.showBadge = false,
      this.badgeLabel,
      this.badgeOffset = const Offset(-5, 0.2)});

  final IconData icon;
  final Color? iconColor;
  final double size;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final bool showBadge;
  final String? badgeLabel;
  final Offset badgeOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent, shape: BoxShape.circle),
      child: Badge(
        label: Text(badgeLabel ?? ''),
        offset: badgeOffset,
        isLabelVisible: badgeLabel != null ? true : showBadge,
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon,
                color: iconColor ??
                    (isDarkTheme(context)
                        ? AppColors.white
                        : AppColors.darkText),
                size: size)),
      ),
    );
  }
}
