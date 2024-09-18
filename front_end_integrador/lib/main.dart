import 'package:flutter/material.dart';
import 'login.dart';  // Importa a tela de login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),  // Define a LoginScreen como a tela inicial
    );
  }
}
