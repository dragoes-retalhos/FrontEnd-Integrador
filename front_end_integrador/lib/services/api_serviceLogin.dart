import 'dart:convert'; // Para trabalhar com JSON
import 'package:http/http.dart' as http; // Biblioteca HTTP

class ApiService {
  // Defina a URL base da API aqui
  final String baseUrl = 'http://localhost:8080'; // URL base da API

  // Método para autenticar o usuário
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(
          '$baseUrl/api/login/authentication'), // Aqui ele vai usar a URL base
      headers: {
        'Content-Type':
            'application/json', // Define o tipo de conteúdo como JSON
      },
      body: json.encode({
        'email': email, // Substitua por 'email' ou o que sua API espera
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Aqui você pode fazer algo com o token retornado, se houver
      return true; // Login bem-sucedido
    } else {
      return false; // Login falhou
    }
  }
}
