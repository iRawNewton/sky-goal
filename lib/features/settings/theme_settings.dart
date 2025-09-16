import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/themes/app_theme.dart';
import '../../core/themes/theme_cubit.dart';

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

enum ThemeModeOption { automatic, light, dark }

class _ThemeSettingsState extends State<ThemeSettings> {
  ThemeModeOption selectedTheme = ThemeModeOption.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('theme_mode') ?? 'light';
    setState(() {
      if (mode == 'dark') {
        selectedTheme = ThemeModeOption.dark;
      } else {
        selectedTheme = ThemeModeOption.light;
      }
    });
  }

  Future<void> _saveThemeMode(ThemeModeOption mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode == ThemeModeOption.dark ? 'dark' : 'light');
  }

  final List<Map<String, dynamic>> themeOptions = [
    {'name': 'Automatic', 'value': ThemeModeOption.automatic},
    {'name': 'Light Mode', 'value': ThemeModeOption.light},
    {'name': 'Dark Mode', 'value': ThemeModeOption.dark},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Theme',
            onTap: () {
              context.pop();
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.cardBackground(context).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: themeOptions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppTheme.onBackground(context).withValues(alpha: 0.1),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final option = themeOptions[index];
                  final isDark = option['value'] == ThemeModeOption.dark;
                  final isSelected = selectedTheme == option['value'];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    title: Text(
                      option['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onBackground(context),
                      ),
                    ),
                    trailing: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                          width: isSelected ? 6 : 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                    ),
                    onTap: () async {
                      if (option['value'] == ThemeModeOption.automatic) {
                        // For simplicity, treat automatic as light mode
                        // selectedTheme = ThemeModeOption.light;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Automatic theme option is coming soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                      else{

                      setState(() {
                        selectedTheme = isDark ? ThemeModeOption.dark : ThemeModeOption.light;
                      });
                      await _saveThemeMode(selectedTheme);
                      context.read<ThemeCubit>().toggle();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}