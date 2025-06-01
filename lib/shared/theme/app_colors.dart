import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFF16A21);
  static const primaryDark = Color(0xFFE64A19);
  static const secondary = Color(0xFFF48413);
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textSecondary),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.primary,
    textTheme: ButtonTextTheme.primary,
  ),
);
