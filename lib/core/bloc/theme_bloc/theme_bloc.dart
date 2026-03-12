import 'package:bloc/bloc.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: _getInitialTheme())) {
    on<ThemeEvent>((event, emit) async {
      emit(ThemeState(themeData: AppThemes.getThemeData(event.appTheme)));
    });
  }

  static ThemeData _getInitialTheme() {
    return AppThemes.getThemeData(AppTheme.lightTheme);
  }
}
