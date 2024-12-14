import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import '../models/user_loan.dart';
import 'notificacao_page.dart';

class DetalhesBeneficiarioPage extends StatefulWidget {
  final UserLoan userLoan;

  DetalhesBeneficiarioPage({required this.userLoan});

  @override
  _DetalhesBeneficiarioPageState createState() =>
      _DetalhesBeneficiarioPageState();
}

class _DetalhesBeneficiarioPageState extends State<DetalhesBeneficiarioPage> {
  late String _selectedStatus;
  late String _selectedType;

  final List<String> _statusOptions = ['ATIVO', 'DESATIVADO'];
  final List<String> _typeOptions = ['PROFESSOR', 'ALUNO', 'EMPRESA'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.userLoan.statusUserEnum;
    _selectedType = widget.userLoan.typeUserLoanEnum;
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
            widget.userLoan.name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildReadOnlyInput('Nome', widget.userLoan.name),
                      _buildReadOnlyInput('Email', widget.userLoan.email),
                      if (_selectedType != 'EMPRESA')
                        _buildReadOnlyInput('RNA', widget.userLoan.rna),
                      if (_selectedType != 'ALUNO' &&
                          _selectedType != 'PROFESSOR')
                        _buildReadOnlyInput(
                            'Empresa', widget.userLoan.enterprise),
                      if (_selectedType != 'EMPRESA' && _selectedType != 'ALUNO')
                        _buildReadOnlyInput(
                            'Identificação', widget.userLoan.identification),
                      _buildReadOnlyInput('Telefone', widget.userLoan.phone),
                      _buildReadOnlyInput(
                          'Status', widget.userLoan.statusUserEnum),
                      _buildReadOnlyInput(
                          'Tipo', widget.userLoan.typeUserLoanEnum),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1, // Índice da página de empréstimo
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
    return Container(
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
    );
  }
}