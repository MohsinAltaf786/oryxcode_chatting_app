import 'package:chat_flow/core/bloc/language_bloc/language_bloc.dart';
import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  const AppBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ThemeBloc()),
      BlocProvider(create: (context) => LanguageBloc(LanguageState.initial())),
    ], child: child);
  }
}
