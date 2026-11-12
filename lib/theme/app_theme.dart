import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get tema {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.faixaAmarela,
      primary: AppColors.asfalto,
      onPrimary: Colors.white,
      secondary: AppColors.faixaAmarela,
      onSecondary: AppColors.tintaSobreAmarelo,
      surface: Colors.white,
      onSurface: AppColors.tinta,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    const textTheme = TextTheme(
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 17, height: 1.4),
      bodyMedium: TextStyle(fontSize: 15, height: 1.4),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.papel,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.papel,
        foregroundColor: AppColors.tinta,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: AppColors.tinta,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borda),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.faixaAmarela,
          foregroundColor: AppColors.tintaSobreAmarelo,
          minimumSize: const Size(64, 52),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.tinta,
          minimumSize: const Size(64, 52),
          side: const BorderSide(color: AppColors.asfalto, width: 1.5),
          textStyle: textTheme.labelLarge,
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tinta,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
