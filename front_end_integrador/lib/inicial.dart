import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFFF3F3FD),
      body: Padding(
    padding: const EdgeInsets.all(30.0),
    child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // espaça as caixas uniformemente
  children: [
    Container(
      width: 50,
      height: 50,
      color: Colors.red,
    ),
    Container(
      width: 50,
      height: 50,
      color: Colors.green,
    ),
    Container(
      width: 50,
      height: 50,
      color: Colors.blue,
    ),
  ],
),
),
);

  }
}