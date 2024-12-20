import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Importar o flutter_typeahead
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../service/auth_service.dart';
import 'notificacao_page.dart';

class EditItemPage extends StatefulWidget {
  final int itemId;

  const EditItemPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController serialNumberController;
  late TextEditingController invoiceNumberController;
  late String status;
  late String category;

  bool isLoading = true;
  bool hasError = false;
  bool isEditable = true;

  List<String> brands = [];
  List<String> models = [];
  List<String> statusOptions = ['ATIVO', 'INATIVO'];
  List<String> categoryOptions = ['Utensílio', 'Equipamento'];

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
    fetchBrandsAndModels();
  }

  Future<void> fetchItemDetails() async {
    try {
      final url = Uri.parse('http://localhost:8080/api/item/${widget.itemId}');
      final token = await AuthService.getToken();
      if (token == null) {
        print("Token não encontrado. Faça login novamente.");
        return;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          nameController = TextEditingController(text: data['nameItem']);
          brandController = TextEditingController(text: data['brand']);
          modelController = TextEditingController(text: data['model']);
          serialNumberController = TextEditingController(text: data['serialNumber']);
          invoiceNumberController = TextEditingController(text: data['invoiceNumber']);
          status = data['status'];
          category = data['category'];
          isLoading = false;
          if (status == 'MANUTENCAO' || status == 'INDISPONIVEL') {
            isEditable = false;
          }
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> fetchBrandsAndModels() async {
    final url = 'http://localhost:8080/api/item/brand-models';
    final token = await AuthService.getToken();
    if (token == null) {
      print("Token não encontrado. Faça login novamente.");
      return;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        brands = List<String>.from(data['brands']);
        models = List<String>.from(data['models']);
      });
    } else {
      print('Erro ao carregar marcas e modelos: ${response.body}');
      throw Exception('Erro ao carregar marcas e modelos');
    }
  }

  Future<void> _saveItem() async {
    final int statusValue = status == 'ATIVO' ? 0 : 1;

    final requestBody = {
      'id': widget.itemId,
      'nameItem': nameController.text,
      'brand': brandController.text,
      'model': modelController.text,
      'serialNumber': serialNumberController.text,
      'invoiceNumber': invoiceNumberController.text,
      'status': statusValue,
      'category': category,
    };

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        print("Token não encontrado. Faça login novamente.");
        return;
      }

      final response = await http.put(
        Uri.parse('http://localhost:8080/api/item/${widget.itemId}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Item atualizado com sucesso!",
            text: "O item foi atualizado com sucesso.",
            type: ArtSweetAlertType.success,
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/inventario');
      } else {
        print('Erro ao atualizar o item: ${response.body}');
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao atualizar o item.",
            type: ArtSweetAlertType.danger,
          ),
        );
      }
    } catch (e) {
      print('Erro inesperado: $e');
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
              'Editar Item',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Erro ao carregar detalhes do item.'))
              : isEditable
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: _buildInputDecoration('Nome do Item'),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TypeAheadFormField<String>(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: brandController,
                                    decoration: _buildInputDecoration('Marca'),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return brands
                                        .where((brand) => brand
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                        .toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(title: Text(suggestion));
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira a marca';
                                    }
                                    return null;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    brandController.text = suggestion;
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return ListTile(
                                      title: Text('Nova Marca'),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: TypeAheadFormField<String>(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: modelController,
                                    decoration: _buildInputDecoration('Modelo'),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return models
                                        .where((model) => model
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                        .toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(title: Text(suggestion));
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o modelo';
                                    }
                                    return null;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    modelController.text = suggestion;
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return ListTile(
                                      title: Text('Novo Modelo'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: serialNumberController,
                            decoration: _buildInputDecoration('Número de Série'),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: invoiceNumberController,
                            decoration: _buildInputDecoration('Número da Nota Fiscal'),
                          ),
                          SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: status,
                            decoration: _buildInputDecoration('Status'),
                            items: statusOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                status = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: category,
                            decoration: _buildInputDecoration('Categoria'),
                            items: categoryOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                category = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _saveItem,
                            child: Text('Salvar'),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'Não é possível editar este item porque ele está em manutenção ou indisponível.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2, // Índice da página de itens
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