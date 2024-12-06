import 'package:flutter/material.dart';
import 'package:will/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:will/controllers/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeController
    Get.put(ThemeController());

    return GetMaterialApp(
      title: 'Will',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F7E8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F7E8),
        brightness: Brightness.light,
        primaryColor: const Color(0xFF62BFAD),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF62BFAD),
          secondary: Color(0xFFF87C4C),
          error: Color(0xFFFF4552),
          background: Color(0xFFF9F7E8),
        ),
      ),
      darkTheme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF62BFAD),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF62BFAD),
          secondary: Color(0xFFF87C4C),
          error: Color(0xFFFF4552),
          background: Color(0xFF1E1E1E),
          surface: Color(0xFF2C2C2C),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
