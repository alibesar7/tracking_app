import 'package:flutter/material.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      primary: AppColors.pink,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.blueColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      titleTextStyle: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(color: AppColors.blackColor, fontSize: 20),
      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      filled: true,
      fillColor: Colors.white,
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12, height: 1.3),
      enabledBorder: _border(const Color(0xFF8C8C8C)),
      focusedBorder: _border(AppColors.pink),
      errorBorder: _border(Colors.red),
      focusedErrorBorder: _border(Colors.red),
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 18,
        color: AppColors.pink,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(fontSize: 12, color: AppColors.blackColor),
      labelMedium: TextStyle(fontSize: 18, color: AppColors.blackColor),
      labelSmall: TextStyle(fontSize: 14, color: AppColors.grey),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.grey,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.pink,
      surfaceTintColor: AppColors.white,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 0,
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: AppColors.white, size: 24);
        }
        return IconThemeData(color: AppColors.pink, size: 24);
      }),
    ),
  );

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }
}
