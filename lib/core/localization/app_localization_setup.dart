import 'package:chat_flow/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizationSetup {
  static const Iterable<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('zh'),
    Locale('hi'),
    Locale('ar'),
    Locale('fr'),
    Locale('pt'),
    Locale('ja'),
    Locale('bn'),
    Locale('ru'),
  ];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationDelegates =
      [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale? localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}
