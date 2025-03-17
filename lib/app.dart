import 'package:flutter/material.dart';
import 'package:luckywheel/main.dart';

void main() {
  runApp(BossinfoLuckyWheel());
}

class BossinfoLuckyWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF004B87), // Bossinfo-Blau
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LuckyWheel(),
    );
  }
}