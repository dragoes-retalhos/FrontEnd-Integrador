import 'package:flutter/material.dart';
import 'login.dart';
import 'noti.dart';


class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu de Opções'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Primeira opção de menu
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Definindo o tamanho do botão
              ),
            ),
            SizedBox(height: 20), // Espaçamento entre os botões
            // Segunda opção de menu
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotifiScreen()),
                );
              },
              child: Text('Notificação'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Definindo o tamanho do botão
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opção 1'),
      ),
      body: Center(
        child: Text('Você escolheu a Opção 1'),
      ),
    );
  }
}

class OptionTwoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opção 2'),
      ),
      body: Center(
        child: Text('Você escolheu a Opção 2'),
      ),
    );
  }
}
