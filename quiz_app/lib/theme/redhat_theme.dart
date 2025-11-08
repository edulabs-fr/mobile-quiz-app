import 'package:flutter/material.dart';

/// Thème personnalisé Red Hat pour l'application
class RedHatTheme {
  // Couleurs Red Hat
  static const Color redHatRed = Color(0xFFEE0000);
  static const Color redHatBlack = Color(0xFF231F20);
  static const Color redHatWhite = Color(0xFFFFFFFF);
  static const Color redHatLightGray = Color(0xFFF5F5F5);
  static const Color redHatDarkGray = Color(0xFF707070);

  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: redHatRed,
        primary: redHatRed,
        secondary: redHatBlack,
        tertiary: redHatDarkGray,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: redHatRed,
        foregroundColor: redHatWhite,
        elevation: 2,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: redHatRed,
          foregroundColor: redHatWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: redHatRed,
          side: const BorderSide(color: redHatRed),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: redHatRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: redHatWhite,
        indicatorColor: redHatRed,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: redHatRed,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: redHatDarkGray,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: redHatWhite); // White icon on red background
          }
          return const IconThemeData(color: redHatDarkGray);
        }),
      ),
      cardTheme: CardTheme(
        color: redHatWhite,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: redHatLightGray,
        selectedColor: redHatRed,
        labelStyle: const TextStyle(color: redHatBlack),
        secondaryLabelStyle: const TextStyle(color: redHatWhite),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      scaffoldBackgroundColor: redHatLightGray,
      dialogBackgroundColor: redHatWhite,
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }
}
