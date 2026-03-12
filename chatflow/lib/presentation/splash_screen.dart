import 'package:chat_flow/core/bloc/language_bloc/language_bloc.dart';
import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_flow/core/storage/local_storage.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/presentation/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _localStorage = GetIt.I.get<LocalStorage>();

  @override
  void initState() {
    super.initState();
    _initializeThemeAndNavigate();
  }

  Future<void> _initializeThemeAndNavigate() async {
    final savedTheme = _localStorage.getTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppTheme theme;
      if (savedTheme == AppTheme.darkTheme.toString()) {
        theme = AppTheme.darkTheme;
      } else if (savedTheme == AppTheme.lightTheme.toString()) {
        theme = AppTheme.lightTheme;
      } else {
        Brightness systemBrightness = MediaQuery.of(context).platformBrightness;

        theme = systemBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
      }

      BlocProvider.of<ThemeBloc>(context).add(ThemeEvent(appTheme: theme));

      checkCurrentLocale();

      navigateToScreen(context, const WelcomeScreen(),
          clearPreviousRoutes: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SizedBox(),
    );
  }

  void checkCurrentLocale() {
    context.read<LanguageBloc>().add(CheckCurrentLocale());
  }
}
