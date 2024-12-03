import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Importar o pacote intl para formatação de data
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class RetornarManutencaoPage extends StatefulWidget {
  final int itemId;

  const RetornarManutencaoPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _RetornarManutencaoPageState createState() => _RetornarManutencaoPageState();
}

class _RetornarManutencaoPageState extends State<RetornarManutencaoPage> {
  late TextEditingController descriptionController;
  late TextEditingController maintenanceDateController;
  late TextEditingController nextMaintenanceDateController;
  late TextEditingController costController;

  bool isLoading = true;
  bool hasError = false;

  late Map<String, dynamic> itemDetails;

  @override
  void initState() {
    super.initState();
    fetchMaintenanceDetails();
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
          itemDetails = data;
        });
      } else {
        setState(() {
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  Future<void> fetchMaintenanceDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/maintenance/${widget.itemId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          // Ordenar as manutenções pelo ID em ordem decrescente e pegar a primeira
          final maintenance = data.reduce((a, b) => a['idMaintenance'] > b['idMaintenance'] ? a : b);
          setState(() {
            descriptionController = TextEditingController(text: maintenance['description']);
            maintenanceDateController = TextEditingController(text: _formatDate(maintenance['creationDate']));
            nextMaintenanceDateController = TextEditingController(text: _formatDate(maintenance['deliveryDate']));
            costController = TextEditingController(text: maintenance['cost'].toString());
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        print('Erro ao carregar detalhes da manutenção: ${response.body}');
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro inesperado: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String _formatDate(List<dynamic> dateList) {
    final date = DateTime(
      dateList[0],
      dateList[1],
      dateList[2],
      dateList.length > 3 ? dateList[3] : 0,
      dateList.length > 4 ? dateList[4] : 0,
      dateList.length > 5 ? dateList[5] : 0,
    );
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _updateMaintenance() async {
    final now = DateTime.now();
    final requestBody = {
      'maintenanceType': 'CORRETIVA', // ou 'PREVENTIVA', conforme necessário
      'description': descriptionController.text,
      'statusMaintenance': 'CONCLUÍDA',
      'cost': double.tryParse(costController.text) ?? 0.0,
      'creationDate': DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(maintenanceDateController.text)),
      'deliveryDate': now.toIso8601String(),
      'laboratoryItem': {
        'id': widget.itemId,
        'status': 'ATIVO',
      },
    };

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/maintenance/up-date/${widget.itemId}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Atualizar o status do item para "ATIVO"
        final itemRequestBody = {
          'id': itemDetails['id'],
          'nameItem': itemDetails['nameItem'],
          'brand': itemDetails['brand'],
          'model': itemDetails['model'],
          'serialNumber': itemDetails['serialNumber'],
          'invoiceNumber': itemDetails['invoiceNumber'],
          'entryDate': _convertDateToList(itemDetails['entryDate']),
          'nextCalibration': _convertDateToList(itemDetails['nextCalibration']),
          'status': 'ATIVO',
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
              title: "Manutenção concluída com sucesso!",
              text: "O status da manutenção foi atualizado para CONCLUÍDA e o status do item foi alterado para ATIVO.",
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
        print('Erro ao atualizar a manutenção: ${response.body}');
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao atualizar a manutenção.",
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
              'Retornar Manutenção',
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
              ? Center(child: Text('Erro ao carregar detalhes da manutenção.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: descriptionController,
                        decoration: _buildInputDecoration('Descrição'),
                        readOnly: true,
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: costController,
                        decoration: _buildInputDecoration('Custo'),
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: maintenanceDateController,
                        decoration: _buildInputDecoration('Data da Manutenção'),
                        readOnly: true,
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: nextMaintenanceDateController,
                        decoration: _buildInputDecoration('Previsão de Retorno'),
                        readOnly: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateMaintenance,
                        child: Text('Concluir Manutenção'),
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