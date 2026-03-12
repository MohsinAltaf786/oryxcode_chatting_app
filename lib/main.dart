import 'package:chat_flow/app.dart';
import 'package:chat_flow/core/utils/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Ensures that the necessary bindings for the Flutter application are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Sets the preferred orientations for the application.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Injector.init(appRunner: () => runApp(const App()));
}
