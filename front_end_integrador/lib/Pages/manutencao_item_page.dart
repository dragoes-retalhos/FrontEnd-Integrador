import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importar o pacote intl para formatação de data
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../service/auth_service.dart';

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
  late TextEditingController costController;
  late String selectedMaintenanceType;

  bool isLoading = true;
  bool hasError = false;

  final maintenanceTypeOptions = ['CORRETIVA', 'PREVENTIVA'];

  late Map<String, dynamic> itemDetails;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
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
        final data = json.decode(response.body);
        setState(() {
          itemDetails = data;
          descriptionController = TextEditingController();
          maintenanceDateController = TextEditingController();
          nextMaintenanceDateController = TextEditingController();
          costController = TextEditingController();
          selectedMaintenanceType = maintenanceTypeOptions.first;
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
    final maintenanceRequestBody = {
      'maintenanceType': selectedMaintenanceType,
      'description': descriptionController.text,
      'statusMaintenance': 'EM ANDAMENTO',
      'cost': double.tryParse(costController.text) ?? 0.0,
      'creationDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateFormat('dd/MM/yyyy').parse(maintenanceDateController.text)),
      'deliveryDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateFormat('dd/MM/yyyy').parse(nextMaintenanceDateController.text)),
      'laboratoryItem': {
        'id': widget.itemId,
        'status': 'MANUTENÇÃO',
      },
    };

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(maintenanceRequestBody)}');

    try {
      final token = await AuthService.getToken();
      final maintenanceResponse = await http.post(
        Uri.parse('http://localhost:8080/api/maintenance'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(maintenanceRequestBody),
      );

      if (maintenanceResponse.statusCode == 201) {
        // Atualizar o status do item para "MANUTENÇÃO"
        final itemRequestBody = {
          'id': itemDetails['id'],
          'nameItem': itemDetails['nameItem'],
          'brand': itemDetails['brand'],
          'model': itemDetails['model'],
          'serialNumber': itemDetails['serialNumber'],
          'invoiceNumber': itemDetails['invoiceNumber'],
          'entryDate': _convertDateToList(itemDetails['entryDate']),
          'nextCalibration': _convertDateToList(itemDetails['nextCalibration']),
          'status': 'MANUTENÇÃO',
        };

        final itemResponse = await http.put(
          Uri.parse('http://localhost:8080/api/item/${widget.itemId}'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(itemRequestBody),
        );

        if (itemResponse.statusCode == 200) {
          await ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: "Item enviado para manutenção com sucesso!",
              text: "O item foi enviado para manutenção com sucesso.",
              type: ArtSweetAlertType.success,
            ),
          );
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/inventario');
        } else {
          print('Erro ao atualizar o status do item: ${itemResponse.body}');
          await ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: "Erro",
              text: "Falha ao atualizar o status do item.",
              type: ArtSweetAlertType.danger,
            ),
          );
        }
      } else {
        print('Erro ao enviar o item para manutenção: ${maintenanceResponse.body}');
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

  List<int> _convertDateToList(dynamic date) {
    if (date is List) {
      return date.cast<int>();
    } else if (date is String) {
      final parsedDate = DateTime.parse(date);
      return [parsedDate.year, parsedDate.month, parsedDate.day];
    } else {
      throw ArgumentError('Formato de data inválido');
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
                      DropdownButtonFormField<String>(
                        value: selectedMaintenanceType,
                        decoration: _buildInputDecoration('Tipo de Manutenção'),
                        onChanged: (value) {
                          setState(() {
                            selectedMaintenanceType = value!;
                          });
                        },
                        items: maintenanceTypeOptions.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: descriptionController,
                        decoration: _buildInputDecoration('Descrição'),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: costController,
                        decoration: _buildInputDecoration('Custo'),
                        keyboardType: TextInputType.number,
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
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: nextMaintenanceDateController,
                        decoration: _buildInputDecoration('Previsão de Retorno'),
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
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
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