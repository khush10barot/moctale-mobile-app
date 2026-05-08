import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MocTale',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF3D8B7A),
          surface: const Color(0xFF4CAF9A),
        ),
        scaffoldBackgroundColor: const Color(0xFF5BB8A0),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}