import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF9163F2);
  static const Color backgroundColor = Color(0xFFE8EFF7);
  static const Color iconColor = Colors.grey;
  static const Color errorColor = Color(0xFFE96767);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ThemeData.light().colorScheme.copyWith(primary: primaryColor),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.robotoTextTheme(),
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: iconColor),
        prefixIconColor: iconColor,
        suffixIconColor: iconColor,
        focusColor: iconColor,
        contentPadding: const EdgeInsets.all(4.0),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: iconColor,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(20.0)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: errorColor),
            borderRadius: BorderRadius.circular(20.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: errorColor),
            borderRadius: BorderRadius.circular(20.0)),
        errorStyle: const TextStyle(color: errorColor)),
  );
}
