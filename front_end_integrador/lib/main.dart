import 'package:flutter/material.dart';
import 'Pages/splashScreen.dart';
import 'Pages/login.dart';
import 'Pages/home_page.dart';
import 'Pages/emprestimo.dart';
import 'Pages/user_loan_card.dart';
import 'itens.dart';
import 'inventario.dart';
import 'Components/viewPage.dart';
import 'Pages/importPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/itens': (context) => ItensPage(),
        '/inventario': (context) => InventarioPage(),
        '/main': (context) => MainPage(),
        '/import': (context) => ImportPage(),

      },
    );
  }
}
