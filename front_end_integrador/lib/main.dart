import 'package:flutter/material.dart';
import 'splashScreen.dart';
import 'login.dart';  

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
      },
    );
  }
}
