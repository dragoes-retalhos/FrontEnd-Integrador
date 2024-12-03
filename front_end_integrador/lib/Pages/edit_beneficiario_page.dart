import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_integrador/models/user_loan.dart';
import 'dart:convert';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';

class EditBeneficiarioPage extends StatefulWidget {
  final UserLoan userLoan;

  const EditBeneficiarioPage({Key? key, required this.userLoan}) : super(key: key);

  @override
  _EditBeneficiarioPageState createState() => _EditBeneficiarioPageState();
}

class _EditBeneficiarioPageState extends State<EditBeneficiarioPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController rnaController;
  late TextEditingController enterpriseController;
  late TextEditingController identificationController;
  late TextEditingController phoneController;

  late String selectedStatus;
  late String selectedType;

  final statusMap = {'Ativo': 'ACTIVE', 'Inativo': 'DISABLED'};
  final typeMap = {
    'Professor': 'TEACHER',
    'Aluno': 'STUDENT',
    'Empresarial': 'ENTERPRISE'
  };

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userLoan.name);
    emailController = TextEditingController(text: widget.userLoan.email);
    rnaController = TextEditingController(text: widget.userLoan.rna);
    enterpriseController = TextEditingController(text: widget.userLoan.enterprise);
    identificationController = TextEditingController(text: widget.userLoan.identification);
    phoneController = TextEditingController(text: widget.userLoan.phone);

    selectedStatus = statusMap.keys.firstWhere(
      (key) => statusMap[key] == widget.userLoan.statusUserEnum,
      orElse: () => statusMap.keys.first,
    );

    selectedType = typeMap.keys.firstWhere(
      (key) => typeMap[key] == widget.userLoan.typeUserLoanEnum,
      orElse: () => typeMap.keys.first,
    );
  }

  Future<void> _saveUserLoan() async {
    final requestBody = {
      'id': widget.userLoan.id,
      'name': nameController.text,
      'email': emailController.text,
      'rna': rnaController.text,
      'enterprise': enterpriseController.text,
      'identification': identificationController.text,
      'phone': phoneController.text,
      'statusUserEnum': statusMap[selectedStatus],
      'typeUserLoanEnum': typeMap[selectedType],
    };

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/userLoan/${widget.userLoan.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar o beneficiado: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o beneficiado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Beneficiado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              items: statusMap.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              items: typeMap.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserLoan,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}