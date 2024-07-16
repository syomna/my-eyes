import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color primaryColor = Colors.amber;

  static ThemeData themeData(context) => ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme.merge(textTheme)),
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black, elevation: 5),
        useMaterial3: true,
      );

  static TextTheme textTheme = const TextTheme(
    headlineMedium: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
  );

  static List<Color> rainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  static bool isLandscape(context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
}
