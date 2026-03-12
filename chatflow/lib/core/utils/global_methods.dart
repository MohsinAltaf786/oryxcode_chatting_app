import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/localization/app_localization.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Generates input decoration for text input fields.
InputDecoration fieldDeco({
  String? label,
  String? hintText,
  IconData? prefixIcon,
  Widget? prefixWidget,
  Color? prefixIconColor,
  Widget? suffix,
  bool isFilled = false,
  double? yPadding,
  double? xPadding,
  String? helperText,
  BorderRadius? borderRadius,
  Color? fillColor,
}) {
  return InputDecoration(
    filled: isFilled,
    fillColor: fillColor ?? Colors.transparent,
    border: isFilled ? InputBorder.none : null,
    contentPadding: .symmetric(
        vertical: yPadding ?? 10, horizontal: xPadding ?? 18),
    labelText: label,
    hintText: hintText,
    counterText: '',
    labelStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    helperText: helperText,
    helperMaxLines: 3,
    hintStyle: const TextStyle(
      fontSize: 14.0,
    ),
    prefixIcon: prefixWidget ??
        (prefixIcon != null
            ? Icon(
          prefixIcon,
          color: prefixIconColor ?? AppColors.darkText,
          size: 20,
        )
            : null),
    suffixIcon: suffix,
    enabledBorder:
    fieldEnableBorder(isFilled: isFilled, borderRadius: borderRadius),
    focusedBorder:
    focusedLineBorder(isFilled: isFilled, borderRadius: borderRadius),
    disabledBorder:
    fieldDisabledBorder(isFilled: isFilled, borderRadius: borderRadius),
    errorBorder:
    fieldErrorBorder(isFilled: isFilled, borderRadius: borderRadius),
    focusedErrorBorder:
    focusedErrorBorder(isFilled: isFilled, borderRadius: borderRadius),
    floatingLabelStyle:
    const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  );
}

ShapeBorder cardShape = RoundedRectangleBorder(
    borderRadius: .circular(15));

String getTimeFormat(String dateTime) {
  final timeFormat = DateFormat.jm();
  return timeFormat.format(DateTime.parse(dateTime));
}

/// Translates the provided key using the app's localization.
String trans(BuildContext context, {required String key}) {
  return AppLocalizations.of(context)?.translate(key) ?? key;
}

/// Get logo path by theme
String getLogoPath(BuildContext context) {
  return isDarkTheme(context) ? AssetsConst.logoDark : AssetsConst.logo;
}
