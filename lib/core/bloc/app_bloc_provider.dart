import 'package:chat_flow/core/bloc/language_bloc/language_bloc.dart';
import 'package:chat_flow/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:chat_flow/core/network/app_api_client.dart';
import 'package:chat_flow/core/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config_bloc/config_bloc.dart';
import 'otp_bloc/otp_timer_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  const AppBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ThemeBloc()),
      BlocProvider(create: (context) => LanguageBloc(LanguageState.initial())),
      BlocProvider(
        create: (context) => ConfigBloc(AuthRepository(AppApiClient()),),
      ),
      BlocProvider(
        create: (context) => OtpTimerBloc(),
      )
    ], child: child);
  }
}
