import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF7F3DFF);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFF818CF8);

  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryDark = Color(0xFFEA580C);
  static const Color secondaryLight = Color(0xFFFF9D6C);

  static const Color accent = Color(0xFFEC4899);
  static const Color accentDark = Color(0xFFDB2777);
  static const Color accentLight = Color(0xFFF472B6);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF06B6D4);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCardBackground = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF475569);
  static const Color darkHover = Color(0xFF475569);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Colors.white;
  static const Color lightCardBackground = Color(0xFFF8FAFC);
  static const Color lightTextPrimary = Color(0xFF212325);
  static const Color lightTextSecondary = Color(0xFF91919F);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightHover = Color(0xFFF1F5F9);

  static Color background(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkBackground : lightBackground;

  static Color onBackground(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color cardBackground(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;

  static Color textColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color subtitleColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  static Color borderColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkBorder : lightBorder;

  static Color hoverColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? darkHover : lightHover;

  static Color violet100(BuildContext context) => primary;

  static Color secondaryColor(BuildContext context) => secondary;

  static Color accentColor(BuildContext context) => accent;

  static Color successColor(BuildContext context) => success;

  static Color warningColor(BuildContext context) => warning;

  static Color errorColor(BuildContext context) => error;

  static Color infoColor(BuildContext context) => info;

  static TextStyle titleLarge(BuildContext context) => TextStyle(color: textColor(context), fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle titleMedium(BuildContext context) => TextStyle(color: textColor(context), fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle titleSmall(BuildContext context) => TextStyle(color: textColor(context), fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle bodyLarge(BuildContext context) => TextStyle(color: textColor(context), fontSize: 16);

  static TextStyle bodyMedium(BuildContext context) => TextStyle(color: textColor(context), fontSize: 14);

  static TextStyle bodySmall(BuildContext context) => TextStyle(color: subtitleColor(context), fontSize: 12);

  static TextStyle caption(BuildContext context) => TextStyle(color: subtitleColor(context), fontSize: 11);

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Outfit',
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightSurface,
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryLight,
      secondary: secondary,
      secondaryContainer: secondaryLight,
      tertiary: accent,
      tertiaryContainer: accentLight,
      surface: lightSurface,
      surfaceContainerHighest: lightCardBackground,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: lightTextPrimary,
      onError: Colors.white,
      outline: lightBorder,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: lightTextPrimary, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: lightTextPrimary, fontSize: 28, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: lightTextPrimary, fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: lightTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: lightTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: lightTextPrimary, fontSize: 14),
      bodySmall: TextStyle(color: lightTextSecondary, fontSize: 12),
    ),
    cardTheme: const CardThemeData(color: lightSurface, elevation: 2, shadowColor: Color(0x1A000000)),
    appBarTheme: const AppBarTheme(backgroundColor: lightBackground, foregroundColor: lightTextPrimary, elevation: 0),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkSurface,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      primaryContainer: primaryDark,
      secondary: secondary,
      secondaryContainer: secondaryDark,
      tertiary: accent,
      tertiaryContainer: accentDark,
      surface: darkSurface,
      surfaceContainerHighest: darkCardBackground,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: darkTextPrimary,
      onError: Colors.white,
      outline: darkBorder,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: darkTextPrimary, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: darkTextPrimary, fontSize: 28, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: darkTextPrimary, fontSize: 24, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: darkTextPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: darkTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: darkTextPrimary, fontSize: 14),
      bodySmall: TextStyle(color: darkTextSecondary, fontSize: 12),
    ),
    cardTheme: const CardThemeData(color: darkSurface, elevation: 4, shadowColor: Color(0x33000000)),
    appBarTheme: const AppBarTheme(backgroundColor: darkBackground, foregroundColor: darkTextPrimary, elevation: 0),
  );
}

/*
Container(
  color: AppTheme.background(context),
  child: Text(
    'Hello World',
    style: TextStyle(color: AppTheme.textColor(context)),
  ),
)

Card(
  color: AppTheme.cardBackground(context),
  child: Text(
    'Subtitle text',
    style: TextStyle(color: AppTheme.subtitleColor(context)),
  ),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor(context),
    foregroundColor: Colors.white,
  ),
  onPressed: () {},
  child: Text('Button'),
)
*/
