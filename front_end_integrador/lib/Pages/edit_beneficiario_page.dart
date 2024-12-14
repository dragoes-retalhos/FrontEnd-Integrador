import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:front_integrador/models/user_loan.dart';
import 'dart:convert';
import 'perfil.dart';
import '../Components/bottomNavBar.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import '../service/auth_service.dart';
import 'notificacao_page.dart';

class EditBeneficiarioPage extends StatefulWidget {
  final UserLoan userLoan;

  const EditBeneficiarioPage({Key? key, required this.userLoan})
      : super(key: key);

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

  final statusMap = {'Ativo': 0, 'Inativo': 1};
  final typeMap = {'Professor': 0, 'Aluno': 1, 'Empresarial': 2};

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userLoan.name);
    emailController = TextEditingController(text: widget.userLoan.email);
    rnaController = TextEditingController(text: widget.userLoan.rna);
    enterpriseController =
        TextEditingController(text: widget.userLoan.enterprise);
    identificationController =
        TextEditingController(text: widget.userLoan.identification);
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
      'statusUser': statusMap[selectedStatus], // Envia 0 ou 1
      'typeUserLoan': typeMap[selectedType],   // Envia 0, 1 ou 2
    };
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    // Log do corpo da requisição
    print('Corpo da requisição: ${jsonEncode(requestBody)}');

    try {
      final token = await AuthService.getToken();
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/userLoan/${widget.userLoan.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Beneficiário cadastrado com sucesso!",
            text: "O beneficiário foi cadastrado com sucesso.",
            type: ArtSweetAlertType.success,
          ),
        );
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/beneficiados');
      } else {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Erro",
            text: "Falha ao cadastrar o beneficiário.",
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
              'Editar Beneficiário',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 4),
          ],
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
            TextField(
              controller: nameController,
              decoration: _buildInputDecoration('Nome'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: _buildInputDecoration('Email'),
            ),
            SizedBox(height: 15),
            if (selectedType != 'Empresarial' && selectedType != 'Professor')
              TextField(
                controller: rnaController,
                decoration: _buildInputDecoration('RNA'),
              ),
            if (selectedType != 'Aluno' && selectedType != 'Professor')
              TextField(
                controller: enterpriseController,
                decoration: _buildInputDecoration('Empresa'),
              ),
            if (selectedType != 'Empresarial' && selectedType != 'Aluno')
              TextField(
                controller: identificationController,
                decoration: _buildInputDecoration('Identificação'),
              ),
            SizedBox(height: 15),
            TextField(
              controller: phoneController,
              decoration: _buildInputDecoration('Telefone'),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: _buildInputDecoration('Status'),
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
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: _buildInputDecoration('Tipo'),
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
}
