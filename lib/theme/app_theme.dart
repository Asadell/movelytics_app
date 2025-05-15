import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Light Mode
  static const Color primaryColor = Color(0xFF1E3A8A); // Deeper blue
  static const Color accentColor = Color(0xFFFF6B00); // More vibrant orange
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1E293B);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // Colors - Dark Mode
  static const Color primaryColorDark = Color(0xFF3B82F6);
  static const Color accentColorDark = Color(0xFFFF9500);
  static const Color backgroundColorDark = Color(0xFF0F172A);
  static const Color cardColorDark = Color(0xFF1E293B);
  static const Color textColorDark = Color(0xFFF1F5F9);
  static const Color secondaryTextColorDark = Color(0xFFCBD5E1);
  static const Color dividerColorDark = Color(0xFF334155);

  // Status colors with more vibrant tones
  static const Color lowDensityColor = Color(0xFF10B981); // Emerald green
  static const Color mediumDensityColor = Color(0xFFF59E0B); // Amber
  static const Color highDensityColor = Color(0xFFEF4444); // Red

  // Add gradient colors - Light Mode
  static const List<Color> primaryGradient = [
    Color(0xFF1E3A8A),
    Color(0xFF2563EB),
  ];

  static const List<Color> accentGradient = [
    Color(0xFFFF6B00),
    Color(0xFFFF9500),
  ];

  // Add gradient colors - Dark Mode
  static const List<Color> primaryGradientDark = [
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  static const List<Color> accentGradientDark = [
    Color(0xFFFF9500),
    Color(0xFFFF6B00),
  ];

  // Update the theme with more modern styling
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 3,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textColor,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: secondaryTextColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: secondaryTextColor,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: secondaryTextColor.withOpacity(0.7),
      ),
      prefixIconColor: secondaryTextColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      elevation: 12,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColorDark,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: accentColorDark,
      background: backgroundColorDark,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    cardTheme: const CardTheme(
      color: cardColorDark,
      elevation: 3,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: cardColorDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColorDark,
      ),
      iconTheme: IconThemeData(color: textColorDark),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColorDark,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColorDark,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColorDark,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textColorDark,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textColorDark,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        color: secondaryTextColorDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorDark,
        foregroundColor: textColorDark,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColorDark,
        side: const BorderSide(color: primaryColorDark, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColorDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColorDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: secondaryTextColorDark,
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: secondaryTextColorDark.withOpacity(0.7),
      ),
      prefixIconColor: secondaryTextColorDark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardColorDark,
      selectedItemColor: primaryColorDark,
      unselectedItemColor: secondaryTextColorDark,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      elevation: 12,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentColorDark,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColorDark;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColorDark.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );

  // Helper method to get current gradient based on theme mode
  static List<Color> getPrimaryGradient(bool isDarkMode) {
    return isDarkMode ? primaryGradientDark : primaryGradient;
  }

  static List<Color> getAccentGradient(bool isDarkMode) {
    return isDarkMode ? accentGradientDark : accentGradient;
  }
}
