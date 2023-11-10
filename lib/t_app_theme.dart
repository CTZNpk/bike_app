import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TAppTheme {
  static var tColorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0xFF2E4053));

  static var tColorSchemeDark = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 14, 19, 24),
  );

  static final lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
  ).copyWith(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: tColorScheme,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: tColorScheme.onPrimaryContainer,
      foregroundColor: tColorScheme.onPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
      ),
    ),
    cardTheme: const CardTheme().copyWith(
      color: const Color.fromARGB(255, 248, 249, 251),
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
  ).copyWith(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: tColorSchemeDark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    cardTheme: const CardTheme().copyWith(color: tColorSchemeDark.onSecondary),
  );
}
