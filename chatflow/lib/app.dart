import 'package:chat_flow/core/bloc/app_bloc_provider.dart';
import 'package:chat_flow/core/bloc/language_bloc/language_bloc.dart';
import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_flow/core/localization/app_localization_setup.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:chat_flow/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            buildWhen: (previousState, currentState) =>
                previousState != currentState,
            builder: (_, localeState) {
              return MaterialApp(
                title: 'ChatFlow',
                debugShowCheckedModeBanner: false,
                theme: themeState.themeData,
                supportedLocales: AppLocalizationSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationSetup.localizationDelegates,
                localeResolutionCallback:
                    AppLocalizationSetup.localeResolutionCallback,
                locale: localeState.locale,
                builder: (context, child) {

                  final isDarkMode = isDarkTheme(context);

                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
                    systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
                    systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
                  ));

                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
