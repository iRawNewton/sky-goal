import 'package:skygoaltest/data/datasources/theme_local_datasource.dart';
import 'package:skygoaltest/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  @override
  Future<bool> getTheme() {
    return localDataSource.getThemePreference();
  }

  @override
  Future<void> toggleTheme(bool isDarkMode) {
    return localDataSource.saveThemePreference(isDarkMode);
  }
}
