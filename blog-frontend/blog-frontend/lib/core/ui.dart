import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppColors {
  static const whiteColor = Color(0xffFFFFFF);
  static const text = Color(0xff000000);
  static const primaryColor = Color(0xff0867FB);
  static const greyColor = Color(0xff808080);
  static const navBarColor = Color(0xffE7F0FE);
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.whiteColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      // iconTheme: IconThemeData(color: AppColors.text),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primaryColor, // Color for selected icon
      unselectedItemColor: AppColors.text, // Color for unselected icon
      backgroundColor: AppColors.navBarColor, // Background color of the bar
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600), // Optional
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400), // Optional
    ),
  );
}

class TextStyles {
  static TextStyle heading1 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 48,
  );

  static TextStyle heading2 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 32,
  );

  static TextStyle heading3 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 28,
  );
  static TextStyle heading4 = const TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    fontSize: 24,
  );

  static TextStyle body1 = const TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.text,
    fontSize: 20,
  );

  static TextStyle body2 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 18,
  );
  static TextStyle body3 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 16,
  );
  static TextStyle body4 = const TextStyle(
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    fontSize: 14,
  );
}

Future<void> toast({required String message}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.primaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

const String welcomeText =
    "Welcome to your daily dose of inspiration and ideas! Discover stories, tips, and insights crafted just for you. Stay curious, keep reading, and let your imagination thrive!";
