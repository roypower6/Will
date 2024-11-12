import 'package:flutter/material.dart';
import 'package:will/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Will',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF9F7E8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F7E8),
      ),
      home: const SplashScreen(),
    );
  }
}
