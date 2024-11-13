import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import '../models/user_loan.dart';

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

  final List<String> _statusOptions = ['ACTIVE', 'DISABLED'];
  final List<String> _typeOptions = ['TEACHER', 'STUDENT', 'ENTERPRISE'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.userLoan.statusUserEnum;
    _selectedType = widget.userLoan.typeUserLoanEnum;
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    final returnDate = loan['returnDate'] != null
        ? loan['returnDate'].join('/')
        : 'Data não disponível';
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Empréstimo ID: ${loan['id']}'),
            Text('Status: ${loan['status']}'),
            Text('Data de Devolução: $returnDate'),
            Text('Nome do Usuário: ${loan['userName']}'),
            SizedBox(height: 8.0),
            Text('Itens Emprestados:'),
            ...loan['loanedItems'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '- ${item['nameItem']} (${item['brand']} ${item['model']})'),
                    Text('Serial Number: ${item['serialNumber']}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildReadOnlyInput('Nome', widget.userLoan.name),
            SizedBox(height: 8),
            _buildReadOnlyInput('Email', widget.userLoan.email),
            SizedBox(height: 8),
            _buildReadOnlyInput('RNA', widget.userLoan.rna),
            SizedBox(height: 8),
            _buildReadOnlyInput('Empresa', widget.userLoan.enterprise),
            SizedBox(height: 8),
            _buildReadOnlyInput('Identificação', widget.userLoan.identification),
            SizedBox(height: 8),
            _buildReadOnlyInput('Telefone', widget.userLoan.phone),
            SizedBox(height: 8),
            _buildReadOnlyInput('Status', widget.userLoan.statusUserEnum),
            SizedBox(height: 8),
            _buildReadOnlyInput('Tipo', widget.userLoan.typeUserLoanEnum),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: widget.userLoan.loans.map<Widget>((loan) {
                  return _buildLoanCard(loan);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
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

  Widget _buildReadOnlyInput(String label, String value) {
    return Container(
      height: 35,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5664F5)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5664F5)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5664F5)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        ),
        initialValue: value,
        readOnly: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}
