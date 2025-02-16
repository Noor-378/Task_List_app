import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: false,
  colorScheme: ColorScheme.dark(
    secondary: const Color(0xFF303030),
    surface: Colors.grey.shade700,
    onPrimary: Colors.blue.withOpacity(.8),
    error: Colors.white.withOpacity(.3),
    onError: const Color(0xFF303030),
  ),
);

ThemeData lightMode = ThemeData(
  useMaterial3: false,
  colorScheme: ColorScheme.light(
    secondary: Colors.blue.shade400,
    surface: Colors.blue.shade400,
    onPrimary: Colors.blue.shade400,
    error: Colors.grey,
    onError: Colors.white,
  ),
);
