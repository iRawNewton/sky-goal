import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_theme.dart';
import '../../domain/usecases/toggle_theme.dart';

class ThemeCubit extends Cubit<bool> {
  final GetTheme getTheme;
  final ToggleTheme toggleTheme;

  ThemeCubit(this.getTheme, this.toggleTheme) : super(false) {
    _loadTheme();
  }

  void _loadTheme() async {
    final isDarkMode = await getTheme();
    emit(isDarkMode);
  }

  void toggle() async {
    final newTheme = !state;
    await toggleTheme(newTheme);
    emit(newTheme);
  }
}
