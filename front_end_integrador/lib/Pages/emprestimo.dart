import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'perfil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Components/bottomNavBar.dart';
import 'confirmEmprestimo.dart';

class EmprestimoPage extends StatefulWidget {
  @override
  _EmprestimoPageState createState() => _EmprestimoPageState();
}

class _EmprestimoPageState extends State<EmprestimoPage> {
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic>? _selectedUser;
  List<Map<String, dynamic>> _selectedItems = [];
  Map<String, dynamic>? _selectedItem;
  List<Map<String, dynamic>> _items = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchAllItems();
  }

  Future<void> _fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/userLoan'));
    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      setState(() {
        _users = List<Map<String, dynamic>>.from(usersJson);
      });
    } else {
      print('Failed to load users');
    }
  }

  Future<void> _fetchAllItems() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/item/all-itens'));
    if (response.statusCode == 200) {
      final List<dynamic> itemsJson = jsonDecode(response.body);
      setState(() {
        // Filtrar itens com status "ATIVO"
        _items = List<Map<String, dynamic>>.from(itemsJson)
            .where((item) => item['status'] == 'ATIVO')
            .toList();
      });
    } else {
      print('Failed to load items');
    }
  }

  void _addSelectedItem(Map<String, dynamic> item) {
    setState(() {
      if (!_selectedItems.any((selectedItem) =>
          selectedItem['serialNumber'] == item['serialNumber'])) {
        _selectedItems.add(item);
        _selectedItem = null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Este item já foi selecionado!')),
        );
      }
    });
  }

  void _removeSelectedItem(Map<String, dynamic> item) {
    setState(() {
      _selectedItems.remove(item);
    });
  }

  void _navigateToConfirmationPage() {
    if (_selectedUser != null && _selectedItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmacaoPage(
            selectedUser: _selectedUser!,
            selectedItems: _selectedItems,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione um responsável e ao menos um item')),
      );
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
                'Emprestimo',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'VAMOS REALIZAR UM EMPRÉSTIMO!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildUserDropdown(),
            SizedBox(height: 20),
            _buildItemDropdown(),
            SizedBox(height: 20),
            Expanded(
                child:
                    _buildSelectedItemsList()), // Expande para preencher espaço
            Spacer(), // Adiciona espaço flexível antes do botão
            ElevatedButton(
              onPressed: _navigateToConfirmationPage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Avançar'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1)
            Navigator.pushReplacementNamed(context, '/beneficiados');
          if (index == 2) Navigator.pushReplacementNamed(context, '/itens');
        },
      ),
    );
  }

  TextEditingController _userController = TextEditingController();
  TextEditingController _itemController = TextEditingController();

  Widget _buildItemDropdown() {
    return TypeAheadFormField<Map<String, dynamic>>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _itemController,
        decoration: InputDecoration(
          labelText: 'Selecione um item',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        return _items
            .where((item) =>
                item['nameItem']
                    .toLowerCase()
                    .contains(pattern.toLowerCase()) ||
                item['serialNumber']
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, Map<String, dynamic> item) {
        return ListTile(
          title: Text('${item['nameItem']} (${item['serialNumber']})'),
        );
      },
      onSuggestionSelected: (Map<String, dynamic> item) {
        _addSelectedItem(item); // Adiciona o item à lista de selecionados
        _itemController.clear(); // Limpa o campo após a seleção
      },
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Nenhum item encontrado'),
      ),
    );
  }

  Widget _buildUserDropdown() {
    return TypeAheadFormField<Map<String, dynamic>>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _userController, // Usando o controlador
        decoration: InputDecoration(
          labelText: 'Quem será o responsável',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        return _users
            .where((user) =>
                user['name'].toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, Map<String, dynamic> user) {
        return ListTile(
          title: Text(user['name']),
        );
      },
      onSuggestionSelected: (Map<String, dynamic> user) {
        setState(() {
          _selectedUser = user;
          _userController.text = user['name']; // Atualiza o texto do campo
        });
      },
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Nenhum responsável encontrado'),
      ),
    );
  }

  Widget _buildSelectedItemsList() {
    if (_selectedItems.isEmpty) {
      return Center(child: Text('Nenhum item selecionado.'));
    }

    return ListView.builder(
      itemCount: _selectedItems.length,
      itemBuilder: (context, index) {
        final item = _selectedItems[index];
        return ListTile(
          title: Text('${item['nameItem']} (${item['serialNumber']})'),
          trailing: IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () => _removeSelectedItem(item),
          ),
        );
      },
    );
  }
}