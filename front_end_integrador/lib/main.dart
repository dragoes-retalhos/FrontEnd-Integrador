import 'package:flutter/material.dart';
import 'menuprov.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuPage(),
    );
  }
}

//class MyApp extends StatelessWidget {
//  @override
 // Widget build(BuildContext context) {
 //   return MaterialApp(
 //     home: LoginScreen(),  // Define a LoginScreen como a tela inicial
 //   );
 // }
//}
