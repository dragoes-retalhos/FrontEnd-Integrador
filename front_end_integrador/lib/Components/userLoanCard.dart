import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:http/http.dart' as http;
import 'package:front_integrador/models/user_loan.dart';
import 'package:front_integrador/Pages/user_loan_detalhes.dart';
import 'package:front_integrador/Pages/edit_beneficiario_page.dart';

class UserLoanCard extends StatefulWidget {
  final UserLoan userLoan;

  const UserLoanCard({Key? key, required this.userLoan}) : super(key: key);

  @override
  _UserLoanCardState createState() => _UserLoanCardState();
}

class _UserLoanCardState extends State<UserLoanCard> {
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
    // Inicialize os controladores
    nameController = TextEditingController(text: widget.userLoan.name);
    emailController = TextEditingController(text: widget.userLoan.email);
    rnaController = TextEditingController(text: widget.userLoan.rna);
    enterpriseController =
        TextEditingController(text: widget.userLoan.enterprise);
    identificationController =
        TextEditingController(text: widget.userLoan.identification);
    phoneController = TextEditingController(text: widget.userLoan.phone);

    // Inicialize selectedStatus e selectedType com um valor padrão
    selectedStatus = statusMap.keys.firstWhere(
      (key) => statusMap[key] == widget.userLoan.statusUserEnum,
      orElse: () => statusMap.keys.first,
    );

    selectedType = typeMap.keys.firstWhere(
      (key) => typeMap[key] == widget.userLoan.typeUserLoanEnum,
      orElse: () => typeMap.keys.first,
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDropdown({
    required String value,
    required void Function(String?) onChanged,
    required Iterable<String> items,
  }) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  Future<void> _saveUserLoan(
      BuildContext context, Map<String, dynamic> requestBody) async {
    // Remove 'loans' from the request body to prevent it from being updated
    requestBody.remove('loans');

    try {
      final body = jsonEncode(requestBody);
      print('Sending JSON Body: $body');

      final response = await http.put(
        Uri.parse('http://localhost:8080/api/userLoan'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );

      if (response.statusCode == 201 && mounted) {
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Sucesso!",
            text: "Beneficiado atualizado com sucesso!",
            type: ArtSweetAlertType.success,
          ),
        );

        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/beneficiados');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro ao atualizar o beneficiado: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error encoding JSON: $e');
    }
  }

  Future<void> _deleteUserLoan() async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/userLoan/${widget.userLoan.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 204) {
      await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          title: "Sucesso!",
          text: "Beneficiado excluído com sucesso!",
          type: ArtSweetAlertType.success,
        ),
      );
      Navigator.pushReplacementNamed(context, '/beneficiados');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao excluir o beneficiado: ${response.body}')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final response = await ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        title: "Confirmar Exclusão",
        text: "Você tem certeza de que deseja excluir este beneficiado?",
        type: ArtSweetAlertType.warning,
        showCancelBtn: true,
        confirmButtonText: "Excluir",
        cancelButtonText: "Cancelar",
        confirmButtonColor: Colors.red,
      ),
    );

    if (response?.isTapConfirmButton ?? false) _deleteUserLoan();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'ACTIVE':
        return 'Ativo';
      case 'DISABLED':
        return 'Inativo';
      default:
        return status; // Retorna o status original se não corresponder
    }
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'TEACHER':
        return 'Professor';
      case 'STUDENT':
        return 'Aluno';
      case 'ENTERPRISE':
        return 'Empresarial';
      default:
        return type; // Retorna o tipo original se não corresponder
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalhesBeneficiarioPage(userLoan: widget.userLoan),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            widget.userLoan.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.userLoan.email),
              Text('Status: ${_getStatusText(widget.userLoan.statusUserEnum)}'),
              Text('Tipo: ${_getTypeText(widget.userLoan.typeUserLoanEnum)}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBeneficiarioPage(userLoan: widget.userLoan),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}