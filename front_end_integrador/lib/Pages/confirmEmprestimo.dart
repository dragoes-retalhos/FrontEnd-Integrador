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
            "id": 2,
            "name": "Alice Johnson",
            "email": "alice.johnson@example.com",
            "password": "password456"
          },
          "userLoan": {
            "id": 3,
            "name": selectedUser['name'],
            "email": selectedUser['email'],
            "rna": "123456789",
            "enterprise": "Empresa C",
            "identification": selectedUser['identification'],
            "phone": selectedUser['phone'],
            "statusUserEnum": "ATIVO",
            "typeUserLoanEnum": "EMPRESA"
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
              selectedItems
                  .map((item) => fetchItemDetails(item['serialNumber'])),
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 600), // Define a largura máxima
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
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 600),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
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
                          // Card dos itens
                          // Card dos itens
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 600), // Define a largura máxima
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...itemDetailsList
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          if (index !=
                                              itemDetailsList.length - 1)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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

                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => confirmarEmprestimo(context),
                child: Text('Confirmar Empréstimo'),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/import');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/beneficiados');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/itens');
          }
        },
      ),
    );
  }
}
