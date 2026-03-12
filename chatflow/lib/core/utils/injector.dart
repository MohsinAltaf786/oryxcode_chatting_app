import 'dart:async';
import 'dart:io';

import 'package:chat_flow/core/storage/local_storage.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

typedef AppRunner = FutureOr<void> Function();

class Injector {
  static Future<void> init({required AppRunner appRunner}) async {
    await _initDependencies();
    appRunner();
  }

  static Future<void> _initDependencies() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Save hive data to app support path
    Directory directory = await getApplicationSupportDirectory();
    Hive.init(directory.path);

    // Local Storage
    final storage = await HiveStorage.init();
    GetIt.I.registerLazySingleton<LocalStorage>(() => storage);

    await GetIt.I.allReady();
  }
}
