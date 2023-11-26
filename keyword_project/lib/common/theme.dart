import 'package:flutter/material.dart';

Color primary = const Color.fromARGB(255, 3, 3, 3);
Color secondaryBackground = const Color.fromARGB(255, 30, 30, 30);
Color primaryContainer = const Color.fromARGB(255, 40, 40, 40);
Color secondaryContainer = const Color.fromARGB(255, 50, 50, 50);
Color primaryText = const Color.fromARGB(255, 255, 255, 255);
Color secondaryText = const Color.fromARGB(255, 168, 168, 168);
Color logoBackground = const Color.fromARGB(255, 0, 117, 171);
Color logoPrimaryText = const Color.fromARGB(255, 191, 151, 113);
Color logoSecondaryText = const Color.fromARGB(255, 164, 123, 87);

BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));

double borderWidth = 2;

ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: logoBackground,
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 39, 39, 39),
  ),

  navigationRailTheme: const NavigationRailThemeData(
    labelType: NavigationRailLabelType.all,
    useIndicator: true
  ),

  dividerTheme: const DividerThemeData(
    thickness: 2,
    space: 16,
  ),

  toggleButtonsTheme: ToggleButtonsThemeData(
    borderRadius: borderRadius,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: borderRadius,
    ),
  ),
);