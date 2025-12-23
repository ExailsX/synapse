import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppTheme {
  static const Color discordBlue = Color(0xFF5865F2);
  static const Color telegramBlue = Color(0xFF0084FF);
  static const Color onlineGreen = Color(0xFF3BA55C);
  static const Color unreadOrange = Color(0xFFFAA81A);
  static const Color errorRed = Color(0xFFF38688);
  
  static const Color darkBg = Color(0xFF1E1F22);
  static const Color darkSidebar = Color(0xFF2B2D31);
  static const Color darkContent = Color(0xFF313338);
  static const Color darkMessageMine = discordBlue;
  static const Color darkMessageOther = Color(0xFF383A40);
  static const Color darkText = Color(0xFFDBDEE1);
  static const Color darkTextSecondary = Color(0xFF949BA4);
  static const Color darkBorder = Color(0xFF404249);
  
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSidebar = Color(0xFFF6F6F7);
  static const Color lightContent = Color(0xFFFFFFFF);
  static const Color lightMessageMine = telegramBlue;
  static const Color lightMessageOther = Color(0xFFF1F3F5);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF8A8A8A);
  static const Color lightBorder = Color(0xFFE0E0E0);

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBg,
    primaryColor: discordBlue,
    
    colorScheme: const ColorScheme.dark(
      primary: discordBlue,
      secondary: discordBlue,
      surface: darkBg,
      error: errorRed,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSidebar,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkText,
      ),
      iconTheme: IconThemeData(color: darkTextSecondary),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSidebar,
      selectedItemColor: discordBlue,
      unselectedItemColor: darkTextSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF383A40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: discordBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(
        color: darkTextSecondary,
        fontSize: 16,
      ),
      labelStyle: const TextStyle(
        color: darkText,
        fontSize: 16,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: discordBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: discordBlue,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: darkText),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: darkText),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: darkText),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkText),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkText),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkText),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: darkText),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: darkTextSecondary),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: darkTextSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkText),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: darkTextSecondary),
    ),
    

    
    dividerTheme: const DividerThemeData(
      color: darkBorder,
      thickness: 1,
      space: 0,
    ),
    
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(darkTextSecondary.withValues(alpha: (0.5 * 255).round().toDouble())),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(3),
    ),
  );

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    scaffoldBackgroundColor: lightBg,
    primaryColor: telegramBlue,
    
    colorScheme: const ColorScheme.light(
      primary: telegramBlue,
      secondary: telegramBlue,
      surface: lightSidebar,
      background: lightBg,
      error: errorRed,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: lightSidebar,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightText,
      ),
      iconTheme: IconThemeData(color: lightTextSecondary),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSidebar,
      selectedItemColor: telegramBlue,
      unselectedItemColor: lightTextSecondary,
      type: BottomNavigationBarType.fixed,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightMessageOther,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: const BorderSide(color: telegramBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(
        color: lightTextSecondary,
        fontSize: 16,
      ),
      labelStyle: const TextStyle(
        color: lightText,
        fontSize: 16,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: telegramBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: telegramBlue,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: lightText),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: lightText),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: lightText),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: lightText),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: lightText),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: lightText),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: lightText),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: lightTextSecondary),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: lightTextSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightText),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: lightTextSecondary),
    ),
    

    
    dividerTheme: const DividerThemeData(
      color: lightBorder,
      thickness: 1,
      space: 0,
    ),
    
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(lightTextSecondary.withValues(alpha: (0.5 * 255).round().toDouble())),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(3),
    ),
  );
}
