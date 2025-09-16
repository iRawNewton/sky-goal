import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<bool> getThemePreference();
  Future<void> saveThemePreference(bool isDarkMode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'is_dark_mode';

  ThemeLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> getThemePreference() async {
    return sharedPreferences.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> saveThemePreference(bool isDarkMode) async {
    await sharedPreferences.setBool(_themeKey, isDarkMode);
  }
}
