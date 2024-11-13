import 'package:flutter/material.dart';
import 'package:front_integrador/Components/bottomNavBar.dart'; // Ajuste o caminho de importação conforme necessário
import 'package:front_integrador/Pages/perfil.dart'; // Ajuste o caminho de importação conforme necessário
import 'package:art_sweetalert/art_sweetalert.dart'; // Certifique-se de adicionar essa dependência no seu projeto
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroBeneficiarioPage extends StatefulWidget {
  @override
  _CadastroBeneficiarioPageState createState() =>
      _CadastroBeneficiarioPageState();
}

class _CadastroBeneficiarioPageState extends State<CadastroBeneficiarioPage> {
  String? _selectedType;
  bool _showNewInputs = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _additionalField1Controller =
      TextEditingController();
  final TextEditingController _additionalField2Controller =
      TextEditingController();

  Future<void> _confirm() async {
    String url = 'http://localhost:8080/api/userLoan';

    Map<String, dynamic> userLoan = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "statusUserEnum": "ACTIVE",
      "typeUserLoanEnum": _selectedType == "Aluno"
          ? "STUDENT"
          : _selectedType == "Professor"
              ? "TEACHER"
              : _selectedType == "Empresarial"
                  ? "ENTERPRISE"
                  : null,
      if (_selectedType == 'Aluno') "rna": _additionalField1Controller.text,
      if (_selectedType == 'Professor')
        "identification": _additionalField2Controller.text,
      if (_selectedType == 'Empresarial')
        "enterprise": _additionalField1Controller.text,
    };

    if (_selectedType == null ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      print("Erro: Campos obrigatórios não preenchidos.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userLoan),
      );

      if (response.statusCode == 201 && mounted) {
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
      } else if (mounted) {
        final errorResponse = jsonDecode(response.body);
        print("Erro: ${errorResponse['message']}");
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
      print("Erro: $e");
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Campos de entrada existentes
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Nome completo',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Telefone',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Selecione o tipo de Beneficiado',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: <String>['Professor', 'Aluno', 'Empresarial']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue; // Atualiza o tipo selecionado
                  _showNewInputs =
                      true; // Mostra novos campos quando um tipo é selecionado
                  _additionalField1Controller.clear(); // Limpa o controlador
                  _additionalField2Controller.clear(); // Limpa o controlador
                });
              },
              value: _selectedType, // Define o valor selecionado
            ),
            SizedBox(height: 20),

            // Campos de entrada adicionais que aparecem quando um tipo é selecionado
            if (_showNewInputs) ...[
              if (_selectedType == 'Professor') ...[
                TextField(
                  controller: _additionalField2Controller,
                  decoration: InputDecoration(
                    hintText: 'Número do crachá',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
              ] else if (_selectedType == 'Aluno') ...[
                TextField(
                  controller: _additionalField1Controller,
                  decoration: InputDecoration(
                    hintText: 'Número do RA',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
              ] else if (_selectedType == 'Empresarial') ...[
                TextField(
                  controller: _additionalField1Controller,
                  decoration: InputDecoration(
                    hintText: 'Nome da empresa',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ],
            ElevatedButton(
              onPressed: _confirm,
              child: Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0000FF), // Cor do botão
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: -1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/emprestimo');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/beneficiados');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/itens');
          }
        },
      ), // Exibe a barra de navegação inferior
    );
  }
}
