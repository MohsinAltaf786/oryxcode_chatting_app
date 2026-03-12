import 'package:chat_flow/core/utils/global_methods.dart';
import 'package:chat_flow/presentation/settings/widgets/language_widget.dart';
import 'package:chat_flow/presentation/settings/widgets/theme_widget.dart';
import 'package:chat_flow/presentation/widgets/spacing.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, key: 'general_settings')),
      ),
      body: ListView(
        padding: const .symmetric(horizontal: 20),
        children: [
          const ThemeWidget(),
          const LanguageWidget(),
          spacing(height: 20),
        ],
      ),
    );
  }
}
