import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class ConfirmacaoPage extends StatelessWidget {
  final Map<String, dynamic> selectedUser;
  final List<Map<String, dynamic>> selectedItems;

  ConfirmacaoPage({required this.selectedUser, required this.selectedItems});

  // Função para buscar as informações do item pelo número de série
  Future<Map<String, dynamic>> fetchItemDetails(String serialNumber) async {
    final String url =
        'http://localhost:8080/api/item/by-serial-number/$serialNumber';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar item: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar o item: $e');
      throw e;
    }
  }

  // Função para atualizar o status do item para "indisponível"
  Future<void> atualizarStatusItem(int itemId) async {
    final String url = 'http://localhost:8080/api/item/$itemId/status';
    final Map<String, dynamic> statusData = {
      'status': 'INDISPONIVEL',
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(statusData),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar status do item: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao atualizar status do item: $e');
    }
  }

  // Função para confirmar o empréstimo
  Future<void> confirmarEmprestimo(BuildContext context) async {
    const String url = 'http://localhost:8080/api/loan';

    try {
      // Buscar os IDs dos itens
      List<Map<String, dynamic>> itemDetailsList = [];
      for (var item in selectedItems) {
        var itemDetails = await fetchItemDetails(item['serialNumber']);
        itemDetailsList.add(itemDetails);
      }

      if (itemDetailsList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhum item válido encontrado!')),
        );
        return;
      }

      // Construir o corpo da requisição
      Map<String, dynamic> requestBody = {
        "loan": {
          "loanDate": [2024, 12, 5, 10, 30],
          "expectedReturnDate": [2024, 12, 20],
          "status": "ATIVO",
          "user": {
            "id": 1,
            "name": "Alice Johnson",
            "email": "alice.johnson@example.com",
            "password": "password456"
          },
          "userLoan": {
            "id": selectedUser['id'],
            "name": selectedUser['name'],
            "email": selectedUser['email'],
            "rna": selectedUser['rna'],
            "enterprise": selectedUser['enterprise'],
            "identification": selectedUser['identification'],
            "phone": selectedUser['phone'],
            "statusUserEnum": selectedUser['statusUserEnum'],
            "typeUserLoanEnum": selectedUser['typeUserLoanEnum']
          }
        },
        "laboratoryItemIds": itemDetailsList.map((item) => item['id']).toList(),
      };

      print("JSON Enviado: ${json.encode(requestBody)}");

      // Enviar a requisição POST
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      // Tratando a resposta
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Atualizar o status dos itens para "indisponível"
        for (var item in itemDetailsList) {
          await atualizarStatusItem(item['id']);
        }

        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Empréstimo cadastrado com sucesso!",
            text: "O empréstimo foi cadastrado com sucesso.",
            type: ArtSweetAlertType.success,
          ),
        );
        Navigator.pushReplacementNamed(context, '/beneficiados');
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao cadastrar o empréstimo.",
            type: ArtSweetAlertType.danger,
          ),
        );
      }
    } catch (e) {
      await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          title: "Erro",
          text: "Ocorreu um erro inesperado.",
          type: ArtSweetAlertType.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            'Empréstimo',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            child: Icon(Icons.notifications, color: Colors.white, size: 28),
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
          )
        ],
        toolbarHeight: 80,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(
              selectedItems.map((item) => fetchItemDetails(item['serialNumber'])),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar os itens'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Nenhum item encontrado'));
              }

              final itemDetailsList = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONFIRME AS INFORMAÇÕES DO EMPRÉSTIMO!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Card do responsável
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.9, // Define a largura como 90% da tela
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Responsável',
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Nome: ${selectedUser['name']}'),
                                    Text(
                                        'Nº de identificação: ${selectedUser['identification']}'),
                                    Text('Email: ${selectedUser['email']}'),
                                    Text('Telefone: ${selectedUser['phone']}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Card dos itens
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.9, // Define a largura como 90% da tela
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...itemDetailsList.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item['nameItem']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'Número de série: ${item['serialNumber']}'),
                                          Text('Marca: ${item['brand']}'),
                                          Text('Modelo: ${item['model']}'),
                                          Text(
                                              'N° Nota fiscal: ${item['invoiceNumber']}'),
                                          if (index != itemDetailsList.length - 1)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: Divider(
                                                color: Colors.grey[400],
                                                thickness: 1,
                                              ),
                                            ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 80), // Espaço para o botão fixo
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => confirmarEmprestimo(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Concluir Empréstimo'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/beneficiados');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/itens');
          }
        },
      ),
    );
  }
}