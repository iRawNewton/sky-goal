abstract class ThemeRepository {
  Future<bool> getTheme();
  Future<void> toggleTheme(bool isDarkMode);
}
