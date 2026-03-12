import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_flow/core/constants/font_const.dart';
import 'package:chat_flow/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
  systemTheme,
}

abstract class AppThemes {
  static final themeData = {
    AppTheme.lightTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        brightness: Brightness.light,
        fontFamily: FontConstants.dmSans,
        cardTheme: const CardThemeData(
            color: AppColors.white, surfaceTintColor: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: AppColors.darkText),
          headlineMedium: TextStyle(color: AppColors.darkText),
          headlineSmall: TextStyle(color: AppColors.darkText),
          displayLarge: TextStyle(color: AppColors.darkText),
          displayMedium: TextStyle(color: AppColors.darkText),
          displaySmall: TextStyle(color: AppColors.darkText),
          titleLarge: TextStyle(color: AppColors.darkText),
          titleMedium: TextStyle(color: AppColors.darkText),
          titleSmall:
              TextStyle(color: AppColors.greyText, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(color: AppColors.darkText),
          labelMedium: TextStyle(color: AppColors.darkText),
          labelSmall: TextStyle(color: AppColors.darkText),
        ),
        dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
        bottomSheetTheme:
            const BottomSheetThemeData(surfaceTintColor: Colors.white)),
    AppTheme.darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.darkBg,
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        brightness: Brightness.dark,
        fontFamily: FontConstants.dmSans,
        cardTheme: const CardThemeData(
            color: AppColors.grey100, surfaceTintColor: Colors.white),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: AppColors.light80),
          headlineMedium: TextStyle(color: AppColors.light80),
          headlineSmall: TextStyle(color: AppColors.light80),
          displayLarge: TextStyle(color: AppColors.light80),
          displayMedium: TextStyle(color: AppColors.light80),
          displaySmall: TextStyle(color: AppColors.light80),
          titleLarge: TextStyle(color: AppColors.light80),
          titleMedium: TextStyle(color: AppColors.light80),
          titleSmall: TextStyle(color: AppColors.light60),
          labelLarge: TextStyle(color: AppColors.light80),
          labelMedium: TextStyle(color: AppColors.light80),
          labelSmall: TextStyle(color: AppColors.light60),
        ),
        dialogTheme: const DialogThemeData(
            surfaceTintColor: Colors.black, backgroundColor: Colors.black))
  };

  static ThemeData getThemeData(AppTheme appTheme) {
    return themeData[appTheme]!;
  }
}

/// Checks whether the provided theme state represents a dark theme.
bool isDarkTheme(BuildContext context) {
  final themeState = BlocProvider.of<ThemeBloc>(context).state;
  return themeState.themeData.brightness == Brightness.dark;
}
