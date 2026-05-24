import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Démineur XP',
      theme: ThemeData(
        fontFamily: null,
        scaffoldBackgroundColor: const Color(0xFF3A6EA5), // bleu XP
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF245D9C),
          foregroundColor: Colors.white,
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
