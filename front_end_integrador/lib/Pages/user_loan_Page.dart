import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'perfil.dart';
import '../../Components/bottomNavBar.dart';
import '../../models/user_loan.dart';
import '../../Components/userLoanCard.dart';
import 'cadastro_beneficiario.dart';

class BeneficiadosPage extends StatefulWidget {
  @override
  _BeneficiadosPageState createState() => _BeneficiadosPageState();
}

class _BeneficiadosPageState extends State<BeneficiadosPage> {
  List<UserLoan> _beneficiados = [];
  List<UserLoan> _filteredBeneficiados = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _errorMessage = '';
  Color _iconColor = const Color.fromARGB(255, 0, 0, 0); // Cor padrão do ícone
  Color _textColor = Colors.black; // Cor padrão do texto
  FocusNode _focusNode = FocusNode(); // FocusNode para o campo de texto

  @override
  void initState() {
    super.initState();
    _fetchBeneficiados();

    // Ouvir as mudanças de foco
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          _iconColor = Colors.black; // Altera a cor do ícone para preto
          _textColor = Colors.black; // Altera a cor do texto para preto
        } else {
          _iconColor = const Color.fromARGB(255, 0, 0, 0); // Restaura a cor do ícone
          _textColor = Colors.black; // Restaura a cor do texto
        }
      });
    });
  }

  Future<void> _fetchBeneficiados() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/userLoan'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _beneficiados = data.map((json) => UserLoan.fromJson(json)).toList();
          _filteredBeneficiados = _beneficiados; // Inicialmente, todos os beneficiados são filtrados
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

  void _filterBeneficiados(String query) {
    final filtered = _beneficiados.where((beneficiado) {
      final nameBeneficiado = beneficiado.name?.toLowerCase() ?? ''; // Ajuste conforme necessário
      return nameBeneficiado.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredBeneficiados = filtered;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Liberar o FocusNode
    super.dispose();
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
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: 'Filtrar pelo Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide(
                      color: Color(0xFF5664F5), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                suffixIcon: Icon(Icons.search, color: _iconColor),
                labelStyle: TextStyle(color: _textColor),
              ),
              onChanged: _filterBeneficiados,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(child: Text(_errorMessage))
                      : _filteredBeneficiados.isNotEmpty
                          ? ListView.builder(
                              itemCount: _filteredBeneficiados.length,
                              itemBuilder: (context, index) {
                                final beneficiado = _filteredBeneficiados[index];
                                return UserLoanCard(userLoan: beneficiado);
                              },
                            )
                          : Center(child: Text('Nenhum beneficiado encontrado.')),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                // Lógica para navegar para a página de cadastro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroBeneficiarioPage()),
                );
              },
              backgroundColor: Color.fromARGB(100, 86, 100, 245),
              child: Icon(Icons.add),
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
}
