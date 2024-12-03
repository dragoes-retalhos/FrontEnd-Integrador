import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class ManutencaoPage extends StatefulWidget {
  final int itemId;

  const ManutencaoPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _ManutencaoPageState createState() => _ManutencaoPageState();
}

class _ManutencaoPageState extends State<ManutencaoPage> {
  late TextEditingController descriptionController;
  late TextEditingController maintenanceDateController;
  late TextEditingController nextMaintenanceDateController;

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/item/${widget.itemId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          descriptionController = TextEditingController(text: data['description']);
          maintenanceDateController = TextEditingController();
          nextMaintenanceDateController = TextEditingController();
          isLoading = false;
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

  Future<void> _sendToMaintenance() async {
    final requestBody = {
      'itemId': widget.itemId,
      'description': descriptionController.text,
      'maintenanceDate': maintenanceDateController.text,
      'nextMaintenanceDate': nextMaintenanceDateController.text,
    };

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/maintenance'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Item enviado para manutenção com sucesso!",
            text: "O item foi enviado para manutenção com sucesso.",
            type: ArtSweetAlertType.success,
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/itens');
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao enviar o item para manutenção.",
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

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blueAccent),
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
              'Enviar Item para Manutenção',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 4),
          ],
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Erro ao carregar detalhes do item.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: descriptionController,
                        decoration: _buildInputDecoration('Descrição'),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: maintenanceDateController,
                        decoration: _buildInputDecoration('Data da Manutenção'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              maintenanceDateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: nextMaintenanceDateController,
                        decoration: _buildInputDecoration('Próxima Manutenção'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              nextMaintenanceDateController.text =
                                  pickedDate.toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _sendToMaintenance,
                        child: Text('Enviar para Manutenção'),
                      ),
                    ],
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