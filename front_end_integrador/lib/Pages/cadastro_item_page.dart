import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Importar o flutter_typeahead
import 'perfil.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../Components/bottomNavBar.dart';
import 'home.dart';

class CadastroItemPage extends StatefulWidget {
  @override
  _CadastroItemPageState createState() => _CadastroItemPageState();
}

class _CadastroItemPageState extends State<CadastroItemPage> {
  final _formKey = GlobalKey<FormState>();

  // Criando controladores para cada campo
  TextEditingController nameItemController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();

  DateTime entryDate = DateTime.now();
  DateTime nextCalibration = DateTime.now().add(Duration(days: 365));

  List<String> brands = [];
  List<String> models = [];

  // Função para pegar marcas e modelos
  Future<void> fetchBrandsAndModels() async {
    final url =
        'http://localhost:8080/api/item/brands-and-models'; // URL da sua API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        brands = List<String>.from(data['brands']);
        models = List<String>.from(data['models']);
      });
    } else {
      throw Exception('Erro ao carregar marcas e modelos');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBrandsAndModels();
  }

  // Função para cadastrar o item
  Future<void> cadastrarItem() async {
    final url = 'http://localhost:8080/api/item'; // URL da sua API

    final Map<String, dynamic> itemData = {
      'nameItem': nameItemController.text,
      'brand': brandController.text,
      'model': modelController.text,
      'serialNumber': serialNumberController.text,
      'invoiceNumber': invoiceNumberController.text,
      'entryDate': entryDate.toIso8601String(),
      'nextCalibration': nextCalibration.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(itemData),
      );

      if (response.statusCode == 201 && mounted) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Item cadastrado com sucesso!",
            text: "O Item foi cadastrado com sucesso.",
            type: ArtSweetAlertType.success,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Substitua "HomePage" pela sua página de destino.
        );
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao cadastrar o Item.",
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
            'Cadastro de Item',
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
          ),
        ],
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600), // Limitar a largura
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do item
                    TextFormField(
                      controller: nameItemController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Item',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do item';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    // Marca e Modelo em linha
                    Row(
                      children: [
                        Expanded(
                          child: TypeAheadFormField<String>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: brandController,
                              decoration: InputDecoration(
                                labelText: 'Marca',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
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
                              decoration: InputDecoration(
                                labelText: 'Modelo',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                              ),
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

                    // Número de Série
                    TextFormField(
                      controller: serialNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número de Série',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Número da Nota Fiscal
                    TextFormField(
                      controller: invoiceNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número da Nota Fiscal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    SizedBox(height: 30), // Espaço maior antes do botão

                    // Botão de cadastro
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cadastrarItem();
                          }
                        },
                        child: Text('Cadastrar'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2, // Índice da página de empréstimo
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
