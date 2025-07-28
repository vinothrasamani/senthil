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

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: baseColor, brightness: Brightness.light),
    brightness: Brightness.light,
    fontFamily: GoogleFonts.poppins().fontFamily,
    useMaterial3: true,
    filledButtonTheme: filledButtonThemeData,
    appBarTheme: appBarTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
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
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    iconButtonTheme: iconButtonThemeData,
    floatingActionButtonTheme: floatingActionButtonThemeData,
  );

  static final themeMode = StateProvider<ThemeMode>((ref) => ThemeMode.light);
}
