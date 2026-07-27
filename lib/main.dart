import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TeaRotinaApp());
}

class TeaRotinaApp extends StatelessWidget {
  const TeaRotinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotina TEA',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}