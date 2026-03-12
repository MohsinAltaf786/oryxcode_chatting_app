part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent extends Equatable {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  ChangeLanguage({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class CheckCurrentLocale extends LanguageEvent {
  @override
  List<Object?> get props => [];
}
