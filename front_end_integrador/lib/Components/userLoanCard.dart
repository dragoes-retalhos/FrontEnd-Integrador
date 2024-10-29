import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_integrador/models/user_loan.dart';
import 'package:front_integrador/Pages/beneficiados.dart';

class UserLoanCard extends StatefulWidget {
  final UserLoan userLoan;

  const UserLoanCard({Key? key, required this.userLoan}) : super(key: key);

  @override
  _UserLoanCardState createState() => _UserLoanCardState();
}

class _UserLoanCardState extends State<UserLoanCard> {
  Future<void> _showEditDialog(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: widget.userLoan.name);
    final TextEditingController emailController =
        TextEditingController(text: widget.userLoan.email);
    final TextEditingController rnaController =
        TextEditingController(text: widget.userLoan.rna);
    final TextEditingController enterpriseController =
        TextEditingController(text: widget.userLoan.enterprise);
    final TextEditingController identificationController =
        TextEditingController(text: widget.userLoan.identification);
    final TextEditingController phoneController =
        TextEditingController(text: widget.userLoan.phone);

    final Map<String, int> statusMap = {
      'Ativo': 0,
      'Inativo': 1,
    };

    final Map<String, int> typeMap = {
      'Professor': 0,
      'Aluno': 1,
      'Empresarial': 2,
    };

    String selectedStatus = widget.userLoan.statusUserEnum;
    if (!statusMap.keys.contains(selectedStatus)) {
      selectedStatus = statusMap.keys.first;
    }

    String selectedType = widget.userLoan.typeUserLoanEnum;
    if (!typeMap.keys.contains(selectedType)) {
      selectedType = typeMap.keys.first;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Beneficiado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: rnaController,
                  decoration: InputDecoration(labelText: 'RNA'),
                ),
                TextField(
                  controller: enterpriseController,
                  decoration: InputDecoration(labelText: 'Empresa'),
                ),
                TextField(
                  controller: identificationController,
                  decoration: InputDecoration(labelText: 'Identificação'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                ),
                DropdownButton<String>(
                  value: selectedStatus,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    }
                  },
                  items: statusMap.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedType = newValue;
                      });
                    }
                  },
                  items: typeMap.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                final int statusValue = statusMap[selectedStatus]!;
                final int typeValue = typeMap[selectedType]!;

                final requestBody = jsonEncode(<String, dynamic>{
                  'id': widget.userLoan.id,
                  'name': nameController.text,
                  'email': emailController.text,
                  'rna': rnaController.text,
                  'enterprise': enterpriseController.text,
                  'identification': identificationController.text,
                  'phone': phoneController.text,
                  'statusUserEnum': statusValue,
                  'typeUserLoanEnum': typeValue,
                  'loans': widget.userLoan.loans,
                });

                final response = await http.put(
                  Uri.parse('http://localhost:8080/api/userLoan'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: requestBody,
                );

                if (response.statusCode == 201) {
                  if (mounted) { // Verificando se o widget ainda está montado
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/beneficiados');
                  }
                } else {
                  if (mounted) { // Verificando se o widget ainda está montado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar o beneficiado: ${response.body}'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  String getStatusText(String status) {
    switch (status) {
      case 'ACTIVE':
        return 'Ativo';
      case 'DISABLED':
        return 'Inativo';
      default:
        return status;
    }
  }

  String getTypeText(String type) {
    switch (type) {
      case 'TEACHER':
        return 'Professor';
      case 'STUDENT':
        return 'Aluno';
      case 'ENTERPRISE':
        return 'Empresarial';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          widget.userLoan.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userLoan.email),
            Text('Status: ${getStatusText(widget.userLoan.statusUserEnum)}'),
            Text('Tipo: ${getTypeText(widget.userLoan.typeUserLoanEnum)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                _showEditDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                // Lógica de exclusão
              },
            ),
          ],
        ),
      ),
    );
  }
}
