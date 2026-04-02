import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF282828);
  static const cardBackground = Color(0xFF1F1F1F);
  static const gray1 = Color(0xFF2E2E2E);
  static const present = Color(0xFF1D641B);
  static const sick = Color(0xFF1B2464);
  static const absent = Color(0xFF641B1B);
}

abstract final class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: AppColors.bg,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.cardBackground,

    appBarTheme: AppBarTheme(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.cardBackground,
      centerTitle: true,
      toolbarHeight: 50,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.white),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(disabledForegroundColor: Colors.white30),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardBackground,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
