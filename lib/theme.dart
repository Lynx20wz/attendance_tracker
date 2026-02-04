import 'package:flutter/material.dart';

class AppColors {
  static const darkGray = Color(0xFF242424);
  static const darkerGray = Color(0xFF1F1F1F);
  static const gray1 = Color(0xFF2E2E2E);
  static const present = Color(0xFF1D641B);
  static const sick = Color(0xFF1B2464);
  static const absent = Color(0xFF641B1B);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    // Основные цвета
    primaryColor: AppColors.darkGray,
    scaffoldBackgroundColor: AppColors.darkGray,
    canvasColor: AppColors.darkerGray,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkerGray,
      elevation: 0,
    ),

    // ListTile
    listTileTheme: ListTileThemeData(tileColor: AppColors.gray1),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.gray1),
    ),

    // TextButtons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkerGray,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),

    // Другие настройки
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkGray,
      secondary: AppColors.gray1,
      surface: AppColors.darkerGray,
    ),
  );
}
