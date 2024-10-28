import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF273C4E),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/images/logo_bpk.png',
              height: 100,
            ),
            SizedBox(height: 90),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                // Lógica de login
                // entrada temporaria
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                );



                //////////
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE1004E),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 45),
            TextButton(
              onPressed: () {},
              child: Text(
                'Esqueceu a senha?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
