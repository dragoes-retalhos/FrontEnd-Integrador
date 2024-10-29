// lib/pages/beneficiados_page.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import '../models/user_loan.dart';
import '../Components/userLoanCard.dart';

class BeneficiadosPage extends StatefulWidget {
  @override
  _BeneficiadosPageState createState() => _BeneficiadosPageState();
}

class _BeneficiadosPageState extends State<BeneficiadosPage> {
  List<UserLoan> _beneficiados = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBeneficiados();
  }

  Future<void> _fetchBeneficiados() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/userLoan'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _beneficiados = data.map((json) => UserLoan.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar beneficiados');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Página de Beneficiados',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 4),
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
          ),
        ],
        toolbarHeight: 80, // Altura ajustada para 80px
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
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
                  suffixIcon: Icon(Icons.filter_list),
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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : ListView.builder(
                          itemCount: _beneficiados.length,
                          itemBuilder: (context, index) {
                            final beneficiado = _beneficiados[index];
                            return UserLoanCard(userLoan: beneficiado); // Usar o componente
                          },
                        ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                // Lógica para adicionar um novo beneficiado
              },
              backgroundColor: Color.fromARGB(100, 86, 100, 245),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2, // Índice da página de beneficiados
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
