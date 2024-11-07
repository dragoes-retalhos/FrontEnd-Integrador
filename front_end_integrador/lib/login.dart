import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/user.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loginFailed = false; // Variável para monitorar o erro de login

  Future<void> login() async {
    const String apiUrl = 'http://localhost:10.0.2.2/api/login/authentication';

    User user = User(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        //erro de login
        setState(() {
          loginFailed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha no login: ${response.body}')),
        );
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer a requisição: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273C4E),
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
            const SizedBox(height: 90),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: loginFailed ? 'Login inválido' : 'Email',
                hintStyle:
                    TextStyle(color: loginFailed ? Colors.red : Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: loginFailed
                        ? Colors.red
                        : Colors.transparent, //caso de erro
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: loginFailed ? 'Login inválido' : 'Senha',
                hintStyle:
                    TextStyle(color: loginFailed ? Colors.red : Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: loginFailed ? Colors.red : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  loginFailed =
                      false; // Resetar estado de erro antes do novo login
                });
                login(); // Chamar a função de login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE1004E),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 45),
            TextButton(
              onPressed: () {
                // Navegar para a tela de recuperação de senha
              },
              child: const Text(
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
