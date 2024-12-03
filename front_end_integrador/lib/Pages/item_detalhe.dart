import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importa o pacote para formatação de data
import 'perfil.dart';
import '../../Components/bottomNavBar.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, dynamic>? itemDetails;
  List<dynamic> loanHistory = [];
  List<dynamic> maintenanceHistory = [];
  bool isLoading = true;
  bool hasError = false;
  bool showLoanHistory = true;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
    fetchLoanHistory();
    fetchMaintenanceHistory();
  }

  // Função para buscar detalhes do item
  Future<void> fetchItemDetails() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/item/${widget.itemId}'));
      if (response.statusCode == 200) {
        setState(() {
          itemDetails = json.decode(response.body);
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

  // Função para buscar o histórico de empréstimos do item
  Future<void> fetchLoanHistory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api/loan/LoanItemHistory/${widget.itemId}'));
      if (response.statusCode == 200) {
        setState(() {
          loanHistory = json.decode(response.body);
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

  // Função para buscar o histórico de manutenções do item
  Future<void> fetchMaintenanceHistory() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api/maintenance/${widget.itemId}'));
      if (response.statusCode == 200) {
        setState(() {
          maintenanceHistory = json.decode(response.body);
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

  // Função para formatar valores
  String getStringValue(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).join(', ');
    }
    return value?.toString() ?? 'Valor não disponível';
  }

  // Função para formatar datas no padrão dd/MM/yy
  String getFormattedDate(dynamic date) {
    try {
      if (date is List && date.length >= 3) {
        // Formato [ano, mês, dia, hora?, minuto?]
        final parsedDate = DateTime(
          date[0],
          date[1],
          date[2],
          date.length > 3 ? date[3] : 0, // Hora (opcional)
          date.length > 4 ? date[4] : 0, // Minuto (opcional)
        );
        return DateFormat('dd/MM/yy')
            .format(parsedDate); // Alterado para dd/MM/yy
      } else if (date is String) {
        final parsedDate = DateTime.parse(date);
        return DateFormat('dd/MM/yy')
            .format(parsedDate); // Alterado para dd/MM/yy
      }
      return 'Data inválida';
    } catch (e) {
      return 'Data inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          itemDetails?['nameItem'] ?? 'Nome não disponível',
          style: TextStyle(color: Colors.white, fontSize: 20),
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildReadOnlyInput(
                          'Nome', getStringValue(itemDetails!['nameItem'])),
                      SizedBox(height: 8),
                      _buildReadOnlyInput('Número de Série',
                          getStringValue(itemDetails!['serialNumber'])),
                      SizedBox(height: 8),
                      _buildReadOnlyInput('Número de Nota fiscal',
                          getStringValue(itemDetails!['invoiceNumber'])),
                      SizedBox(height: 8),
                      _buildReadOnlyInput(
                          'Marca', getStringValue(itemDetails!['brand'])),
                      SizedBox(height: 8),
                      _buildReadOnlyInput(
                          'Modelo', getStringValue(itemDetails!['model'])),
                      SizedBox(height: 8),
                      _buildReadOnlyInput(
                        'Data de Entrada',
                        itemDetails!['entryDate'] != null
                            ? getFormattedDate(itemDetails!['entryDate'])
                            : 'Data de entrada não disponível',
                      ),
                      SizedBox(height: 8),
                      _buildReadOnlyInput(
                        'Próxima Manutenção',
                        itemDetails!['nextCalibration'] != null
                            ? getFormattedDate(itemDetails!['nextCalibration'])
                            : 'Data de manutenção não disponível',
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showLoanHistory = false;
                              });
                            },
                            child: Text('Manutenção'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showLoanHistory = true;
                              });
                            },
                            child: Text('Empréstimo'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      showLoanHistory
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Histórico de Empréstimos:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                ...loanHistory
                                    .map((loan) => _buildLoanHistoryCard(loan))
                                    .toList(),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Histórico de Manutenções:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                ...maintenanceHistory
                                    .map((maintenance) =>
                                        _buildMaintenanceHistoryCard(
                                            maintenance))
                                    .toList(),
                              ],
                            ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0, // Índice da página de empréstimo
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

  Widget _buildReadOnlyInput(String label, String value) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Adapta o tamanho
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
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
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          initialValue: value,
          readOnly: true,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _buildLoanHistoryCard(dynamic loan) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Usuário: ${loan['nameUser']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data de Empréstimo: ${getFormattedDate(loan['loanDate'])}'),
            Text(
                'Data Esperada de Retorno: ${getFormattedDate(loan['expectedReturnDate'])}'),
            Text(
                'Data de Retorno: ${loan['returnDate'] != null ? getFormattedDate(loan['returnDate']) : "Não devolvido"}'),
            Text('Status: ${loan['status']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceHistoryCard(dynamic maintenance) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Tipo: ${maintenance['maintenanceType']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${maintenance['description']}'),
            Text(
                'Data de Criação: ${getFormattedDate(maintenance['creationDate'])}'),
            Text(
                'Data de Entrega: ${getFormattedDate(maintenance['deliveryDate'])}'),
            Text('Custo: ${maintenance['cost']}'),
            Text('Status: ${maintenance['statusMaintenance']}'),
          ],
        ),
      ),
    );
  }
}