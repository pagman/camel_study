import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF424242);
  static const Color backgroundColor = Color(0xFF303030);

  // Pink accent colors
  static Color get accentLight => Colors.pink.shade100;
  static Color get accentMedium => Colors.pink.shade200;
  static Color get accent => Colors.pink.shade300;
  static Color get accentDark => Colors.pink.shade400;

  // Gray colors
  static Color get grayLight => Colors.grey.shade400;
  static Color get grayMedium => Colors.grey.shade600;
  static Color get grayDark => Colors.grey.shade800;

  // Text styles
  static TextStyle get timerStyle => TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
    color: accent,
  );

  static TextStyle get statusStyle => TextStyle(
    fontSize: 20,
    color: accentMedium,
  );

  static TextStyle get subtitleStyle => TextStyle(
    color: grayLight,
  );

  // Button styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentDark,
    foregroundColor: Colors.white,
    fixedSize: const Size(150, 40),
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: grayMedium,
    foregroundColor: Colors.white,
    fixedSize: const Size(150, 40),
  );

  static ButtonStyle get tertiaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accent,
    foregroundColor: Colors.white,
    fixedSize: const Size(150, 40),
  );

  // Time picker theme
  static ThemeData timePickerTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: ColorScheme.dark(
        primary: accent,
        onPrimary: Colors.white,
        surface: grayDark,
        onSurface: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
        ),
      ),
    );
  }
}
