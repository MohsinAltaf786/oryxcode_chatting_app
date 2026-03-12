import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:flutter/material.dart';

/// A helper class for working with colors.
abstract class ColorHelper {
  static Color titleMediumColor(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.color ?? AppColors.grey100;
  }

  static Color titleSmallColor(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.color ?? AppColors.grey70;
  }

  static Color primaryToWhite(BuildContext context) {
    return isDarkTheme(context) ? Colors.white : Theme.of(context).primaryColor;
  }

  static Color grey20Lite(BuildContext context) {
    return isDarkTheme(context)
        ? Theme.of(context).cardTheme.color ?? Colors.transparent
        : AppColors.grey20;
  }

  static Color grey40Lite(BuildContext context) {
    return isDarkTheme(context)
        ? Colors.white.withValues(alpha: 0.3)
        : AppColors.grey40;
  }
}

/// A helper class for creating custom text styles.
abstract class StyleHelper {
  // Headlines
  static TextStyle? headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge;
  }

  static TextStyle? headlineMedium(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headlineSmall(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  // Display
  static TextStyle? displayLarge(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? displayMedium(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? displaySmall(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  // Body
  static TextStyle? bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  // Title
  static TextStyle? titleLarge(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle? titleMedium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? titleSmall(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  // Label
  static TextStyle? labelLarge(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge;
  }

  static TextStyle? labelMedium(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium;
  }

  static TextStyle? labelSmall(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}

OutlineInputBorder focusedLineBorder(
    {required bool isFilled, BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      borderRadius: borderRadius ?? .circular(30));
}

OutlineInputBorder fieldEnableBorder(
    {required bool isFilled, BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.5), width: 1),
      borderRadius: borderRadius ?? .circular(30));
}

OutlineInputBorder fieldDisabledBorder(
    {required bool isFilled, BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      borderRadius: borderRadius ?? .circular(30));
}

OutlineInputBorder fieldErrorBorder(
    {required bool isFilled, BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      borderRadius: borderRadius ?? .circular(30));
}

OutlineInputBorder focusedErrorBorder(
    {required bool isFilled, BorderRadius? borderRadius}) {
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      borderRadius: borderRadius ?? .circular(30));
}

var fieldLabel = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
