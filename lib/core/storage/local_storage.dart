import 'package:chat_flow/core/constants/hive_const.dart';
import 'package:chat_flow/core/theme/app_theme.dart';
import 'package:hive/hive.dart';

abstract class LocalStorage {
  Future<bool> saveTheme(String theme);

  String getTheme();

  Future<bool> saveLanguage(String? locale);

  String? getLang();
}

class HiveStorage extends LocalStorage {
  final Box box;
  final Box languageBox;

  HiveStorage(this.box, this.languageBox);

  static Future<LocalStorage> init() async => HiveStorage(
      await Hive.openBox(HiveConst.generalBox),
      await Hive.openBox(HiveConst.languageBox));

  @override
  Future<bool> saveTheme(String theme) async {
    await box.put(HiveConst.themeKey, theme);
    return true;
  }

  @override
  String getTheme() {
    return box.get(HiveConst.themeKey) ?? AppTheme.lightTheme.toString();
  }

  @override
  Future<bool> saveLanguage(String? locale) async {
    await languageBox.put(HiveConst.languageKey, locale);
    return true;
  }

  @override
  String? getLang() {
    return languageBox.get(HiveConst.languageKey) ?? 'en';
  }
}
