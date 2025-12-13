import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Color baseColor = const Color.fromARGB(255, 0, 27, 177);
Color secoundary = const Color.fromARGB(255, 182, 0, 167);

class ThemeController {
  static FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundBuilder: (context, states, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: states.contains(WidgetState.disabled) ? Colors.grey : null,
          gradient: states.contains(WidgetState.disabled)
              ? null
              : LinearGradient(
                  colors: [baseColor, secoundary],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight),
        ),
        child: child,
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonThemeData =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), side: BorderSide())),
  );

  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: baseColor,
    foregroundColor: Colors.white,
  );

  static FloatingActionButtonThemeData floatingActionButtonThemeData =
      FloatingActionButtonThemeData(
          foregroundColor: Colors.white, backgroundColor: baseColor);
  static IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
    style: IconButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static InputDecorationTheme decorate(bool isDark) {
    final Color borderColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    final Color focusedColor = isDark ? Colors.blue.shade300 : Colors.blue;
    final Color fillColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          fontSize: 14),
      labelStyle: TextStyle(
          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          fontSize: 14),
      errorStyle: const TextStyle(fontSize: 12, height: 1.2),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: baseColor, brightness: Brightness.light),
    brightness: Brightness.light,
    fontFamily: GoogleFonts.poppins().fontFamily,
    useMaterial3: true,
    filledButtonTheme: filledButtonThemeData,
    appBarTheme: appBarTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    inputDecorationTheme: decorate(false),
    iconButtonTheme: iconButtonThemeData,
    floatingActionButtonTheme: floatingActionButtonThemeData,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: baseColor, brightness: Brightness.dark),
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    useMaterial3: true,
    filledButtonTheme: filledButtonThemeData,
    appBarTheme: appBarTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    inputDecorationTheme: decorate(true),
    iconButtonTheme: iconButtonThemeData,
    floatingActionButtonTheme: floatingActionButtonThemeData,
  );

  static final themeMode = StateProvider<ThemeMode>((ref) => ThemeMode.light);
}
