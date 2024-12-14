import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_integrador/service/auth_service.dart';
import 'notificacao_page.dart';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';

class ReturnLoanPage extends StatelessWidget {
  final String loanId;
  final String item;
  final String loanDate;
  final String expectedReturnDate;

  // Construtor para aceitar os parâmetros
  ReturnLoanPage({
    required this.loanId,
    required this.item,
    required this.loanDate,
    required this.expectedReturnDate,
  });

  // Função para formatar as datas
  String formatDate(String date) {
    if (date == "Data não informada") return "Data não disponível";
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return "Data inválida";
    }
  }

  // Função para atualizar o status do empréstimo e do item
  Future<void> _updateLoanStatus(BuildContext context) async {
    try {
      // Requisição GET para obter os dados do empréstimo
      final loanUrl = 'http://localhost:8080/api/loan/$loanId';
      final token = await AuthService.getToken();
      final loanResponse = await http.get(
        Uri.parse(loanUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Verifica se a requisição GET foi bem-sucedida
      if (loanResponse.statusCode == 200) {
        final loanData = json.decode(utf8.decode(loanResponse.bodyBytes));
        final laboratoryItemIds = loanData['laboratoryItemIds'];

        // Atualizando o status do empréstimo para "DESATIVADO"
        final loanStatusUrl = 'http://localhost:8080/api/loan/$loanId/status';
        final loanStatusResponse = await http.put(
          Uri.parse(loanStatusUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'status': 'DESATIVADO',
          }),
        );

        if (loanStatusResponse.statusCode == 200) {
          // Para cada item, atualizar seu status para "ATIVO"
          for (var itemId in laboratoryItemIds) {
            // Requisição GET para obter os dados do item
            final itemUrl = 'http://localhost:8080/api/item/$itemId';
            final itemResponse = await http.get(
              Uri.parse(itemUrl),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );

            if (itemResponse.statusCode == 200) {
              final itemData = json.decode(utf8.decode(itemResponse.bodyBytes));

              // Preparando os dados para a requisição PUT do item
              final itemStatusUrl = 'http://localhost:8080/api/item/$itemId';
              final itemPutBody = json.encode({
                'id': itemData['id'],
                'nameItem': itemData['nameItem'],
                'brand': itemData['brand'],
                'model': itemData['model'],
                'serialNumber': itemData['serialNumber'],
                'invoiceNumber': itemData['invoiceNumber'],
                'entryDate': itemData['entryDate'],
                'nextCalibration': itemData['nextCalibration'],
                'status': 0, // Atualizando o status para 'ATIVO'
                'category': itemData['category'],
              });

              // Requisição PUT para atualizar o status do item
              final itemStatusResponse = await http.put(
                Uri.parse(itemStatusUrl),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: itemPutBody,
              );

              if (itemStatusResponse.statusCode != 200) {
                throw Exception(
                    'Erro ao atualizar o status do item com ID $itemId');
              }
            } else {
              throw Exception('Erro ao obter os dados do item com ID $itemId');
            }
          }

          // Sucesso, mostra a mensagem e redireciona para a página inicial
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Retorno do empréstimo registrado com sucesso!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception('Erro ao atualizar o status do empréstimo');
        }
      } else {
        throw Exception('Erro ao obter dados do empréstimo');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar retorno: $e')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(100, 86, 100, 245)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(100, 86, 100, 245)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color.fromARGB(100, 86, 100, 245)),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Retornar Empréstimo',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 4),
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            icon: Icon(Icons.notifications, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage()),
              );
            },
          ),
        ],
        toolbarHeight: 80,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Empréstimo ID: $loanId',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Data de Empréstimo: ${formatDate(loanDate)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Data de Previsão de Retorno: ${formatDate(expectedReturnDate)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Itens Emprestados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 1, // Substitua pelo número real de itens emprestados
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Item: $item',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () => _updateLoanStatus(context), // Chama a função para atualizar os status
                child: Text('Registrar Retorno', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Color(0xFF0000FF), // Cor do botão
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1)
            Navigator.pushReplacementNamed(context, '/beneficiados');
          if (index == 2) Navigator.pushReplacementNamed(context, '/itens');
        },
      ),
    );
  }
}