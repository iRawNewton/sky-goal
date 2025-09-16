import '../repositories/theme_repository.dart';

class ToggleTheme {
  final ThemeRepository repository;

  ToggleTheme(this.repository);

  Future<void> call(bool isDarkMode) {
    return repository.toggleTheme(isDarkMode);
  }
}
