import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';
import 'home_page.dart';
import 'emprestimo.dart';
import 'beneficiados.dart';
import 'itens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/emprestimo': (context) => EmprestimoPage(),
        '/beneficiados': (context) => BeneficiadosPage(),
        '/itens': (context) => const ItensPage(),
      },
    );
  }
}
