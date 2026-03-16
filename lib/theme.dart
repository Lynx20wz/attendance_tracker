import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF242424);
  static const cardBackground = Color(0xFF1F1F1F);
  static const gray1 = Color(0xFF2E2E2E);
  static const present = Color(0xFF1D641B);
  static const sick = Color(0xFF1B2464);
  static const absent = Color(0xFF641B1B);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: AppColors.bg,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.cardBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cardBackground,
      elevation: 0,
    ),

    listTileTheme: ListTileThemeData(tileColor: AppColors.gray1),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.gray1),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardBackground,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.bg,
      secondary: AppColors.gray1,
      surface: AppColors.cardBackground,
    ),
  );
}
