import 'package:chat_flow/core/bloc/config_bloc/config_bloc.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_event.dart';
import 'package:chat_flow/core/bloc/config_bloc/config_state.dart';
import 'package:chat_flow/core/constants/assets_const.dart';
import 'package:chat_flow/core/constants/image_type_const.dart';
import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/core/utils/navigator.dart';
import 'package:chat_flow/core/utils/styles.dart';
import 'package:chat_flow/presentation/auth/login_screen.dart';
import 'package:chat_flow/presentation/auth/pairing_screen.dart';
import 'package:chat_flow/presentation/auth/passcode_screen.dart';
import 'package:chat_flow/presentation/auth/sign_up_screen.dart';
import 'package:chat_flow/presentation/widgets/custom_button.dart';
import 'package:chat_flow/presentation/widgets/image_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc, ConfigState>(
      listener: (context, state) {

        if (state is ConfigLoading) {
          showDialog(
            context: context,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ConfigLoaded) {

          Navigator.pop(context); // close loader
           print('is public registration enabled ${state.publicRegistrationEnabled}');
          if (state.publicRegistrationEnabled) {
            navigateToScreen(context, const SignUpScreen(),
                clearPreviousRoutes: true);
            // navigateToScreen(context, const SignUpScreen());

          } else {
            navigateToScreen(context, const PairingScreen(),
                clearPreviousRoutes: true);
            //navigateToScreen(context, const PairingScreen());

          }
        }

        if (state is ConfigError) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

      },
      child:Scaffold(
    body: Padding(
    padding: const .symmetric(horizontal: 15),
    child: Column(
    mainAxisAlignment: .center,
    children: [
    spacing(height: 20),
    _buildBanner(),
    spacing(height: 15),
    _buildTitle(),
    spacing(height: 10),
    _buildDescription(),
    spacing(height: 40),
    _buildButtons(),
    spacing(height: 20),
    ],
    ),
    ),
    ),
    );
  }

  Widget _buildBanner() {
    return const Center(
            child: ImageWidget(
                image: AssetsConst.welcome,
                height: 250,
                width: 280,
                type: ImageType.asset))
        .animate(
          delay: const Duration(milliseconds: 200),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildTitle() {
    return Text(
      trans(context, key: 'welcome_to_chat_flow'),
      textAlign: TextAlign.start,
      style: StyleHelper.headlineSmall(context)
          ?.copyWith(fontWeight: FontWeight.w600),
    )
        .animate(
          delay: const Duration(milliseconds: 400),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildDescription() {
    return Text(
      trans(context, key: 'chat_easily_with_friends_using_chat_flow'),
      textAlign: TextAlign.center,
      style: StyleHelper.titleSmall(context)?.copyWith(),
    )
        .animate(
          delay: const Duration(milliseconds: 500),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }

  Widget _buildButtons() {
    return Column(
      mainAxisSize: .min,
      children: [
        CustomButton(
            title: trans(context, key: 'get_started'),
            fontSize: 16,
            yPadding: 12,
            width: 320,
            onTap: () {
              context.read<ConfigBloc>().add(LoadConfigEvent());

            }),
      ],
    )
        .animate(
          delay: const Duration(milliseconds: 700),
        )
        .fade(
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut)
        .slideY(
            begin: 0.3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
  }
}

