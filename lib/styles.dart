import 'package:flutter/material.dart';

class AppStyles {
  // Основен цвят на приложението
  static const Color primaryColor = Colors.blueAccent;
  static const Color backgroundColor = Colors.grey;
  static const Color buttonTextColor = Colors.white;

  // Стил за ElevatedButton
  static final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: buttonTextColor,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Стил за текста на бутоните
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Стил за текстовите полета (TextField)
  static final InputDecoration inputDecorationTheme = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  // Стил за AppBar
  static const AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColor,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    centerTitle: true,
  );

  // Стил за иконите
  static const IconThemeData iconTheme = IconThemeData(
    color: primaryColor,
    size: 40,
  );

  // Размер на бутоните
  static double buttonWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.7;
  }
}
