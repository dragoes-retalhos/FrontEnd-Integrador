import 'package:flutter/material.dart';
import 'Pages/splashScreen.dart';
import 'Pages/login.dart';
import 'Pages/home.dart';
import 'Pages/emprestimo.dart';
import 'Pages/user_loan_Page.dart';
import 'Pages/itens.dart';
import 'Pages/inventario.dart';
import 'Components/viewPage.dart';
import 'Pages/cadastro_item_page.dart';

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
        '/itens': (context) => CadastroItemPage(),
        '/inventario': (context) => InventarioPage(),
        '/main': (context) => MainPage(),
        

      },
    );
  }
}
