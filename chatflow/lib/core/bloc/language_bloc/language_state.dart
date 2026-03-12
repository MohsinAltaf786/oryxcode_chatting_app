part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final Locale? locale;

  const LanguageState({this.locale});

  factory LanguageState.initial() => const LanguageState(locale: Locale('en'));

  LanguageState copyWith({Locale? locale}) {
    return LanguageState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
