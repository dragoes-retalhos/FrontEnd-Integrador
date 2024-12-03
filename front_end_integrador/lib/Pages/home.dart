import 'package:flutter/material.dart';
import 'package:front_integrador/Pages/Inventario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'emprestimo.dart';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'relatorioPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> activeLoans = [];

  @override
  void initState() {
    super.initState();
    fetchLoans();
  }

  Future<void> fetchLoans() async {
    final url = Uri.parse('http://localhost:8080/api/loan/dinamic');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filtrar empréstimos com status "ATIVO"
        setState(() {
          activeLoans =
              data.where((loan) => loan['status'] == "ATIVO").toList();
        });
      } else {
        print("Erro ao buscar empréstimos: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao realizar a requisição: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0000FF),
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Página inicial',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 4),
              Text(
                'Olá, Name',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
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
        toolbarHeight: 80, // Altura ajustada para 80px
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageButton(
                    context, 'assets/images/icon_emprestimo.png', 'Empréstimo'),
                _buildImageButton(
                    context, 'assets/images/icon_inventario.png', 'Inventário'),
                _buildImageButton(
                    context, 'assets/images/icon_relatorio.png', 'Relatórios'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search and filter',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: activeLoans.map((loan) {
                  return _buildItemCard(
                    loan['loanedItems'] ?? 'Item desconhecido',
                    loan['loanDate'] ?? 'Data não informada',
                    loan['expectedReturnDate'] ?? 'Data não informada');                      
                }).toList(),
              ),
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

  Widget _buildImageButton(
      BuildContext context, String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Empréstimo') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmprestimoPage()),
          );
        }
        if (label == 'Inventário') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventarioPage()),
          );
        }
        if (label == 'Relatórios') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelatorioPage()),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Color.fromRGBO(53, 53, 53, 100),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      String item, List<dynamic> loanDate, List<dynamic> expectedReturnDate) {
    String formatDate(List<dynamic> date) {
      if (date.isEmpty) return "Data não disponível";
      return "${date[2]}/${date[1]}/${date[0]} ${date.length > 3 ? '${date[3]}:${date[4]}' : ''}";
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Data de Empréstimo: ${formatDate(loanDate)}'),
            Text('Data de Previsão: ${formatDate(expectedReturnDate)}'),
          ],
        ),
      ),
    );
  }
}
