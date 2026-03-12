import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_flow/core/storage/local_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageState get initialState => LanguageState.initial();

  final storage = GetIt.I.get<LocalStorage>();

  LanguageBloc(super.initialState) {
    on<ChangeLanguage>(_changeLang);
    on<CheckCurrentLocale>(_checkLocale);
  }

  Future<FutureOr<void>> _changeLang(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    await storage.saveLanguage(event.locale.languageCode);

    emit(LanguageState(locale: event.locale));
  }

  FutureOr<void> _checkLocale(
      CheckCurrentLocale event, Emitter<LanguageState> emit) {
    String? languageCode = storage.getLang();

    emit(LanguageState(locale: Locale(languageCode ?? 'en')));
  }
}
