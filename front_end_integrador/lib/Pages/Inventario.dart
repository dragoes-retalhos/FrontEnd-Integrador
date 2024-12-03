import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Pages/perfil.dart';
import '../Components/bottomNavBar.dart';
import '../Pages/InventarioItem.dart';

class InventarioPage extends StatefulWidget {
  @override
  _InventarioPageState createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  Color iconColor = const Color.fromARGB(255, 0, 0, 0); // Cor padrão do ícone
  Color textColor = Colors.black; // Cor padrão do texto
  FocusNode focusNode = FocusNode(); // FocusNode para o campo de texto

  @override
  void initState() {
    super.initState();
    fetchItems();

    // Ouvir as mudanças de foco
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          iconColor = Colors.black; // Altera a cor do ícone para preto
          textColor = Colors.black; // Altera a cor do texto para preto
        } else {
          iconColor = const Color.fromARGB(255, 0, 0, 0); // Restaura a cor do ícone
          textColor = Colors.black; // Restaura a cor do texto
        }
      });
    });
  }

  Future<void> fetchItems() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/item/dynamiclist'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          filteredItems = data;
        });
      } else {
        throw Exception('Falha ao carregar os itens');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void filterItems(String query) {
    final filtered = items.where((item) {
      final nameItem = item['nameItem']?.toString() ?? '';
      return nameItem.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredItems = filtered;
    });
  }

  @override
  void dispose() {
    focusNode.dispose(); // Liberar o FocusNode
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
          child: Text(
            'Página de Inventário',
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
          children: [
            TextField(
              controller: searchController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Filtrar pelo Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 86, 100, 245), width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
                suffixIcon: Icon(Icons.search, color: iconColor),
                labelStyle: TextStyle(color: textColor),
              ),
              onChanged: filterItems,
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return buildInventoryCard(item);
                      },
                    )
                  : Center(child: Text('Nenhum item encontrado.')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0, // Índice da página de empréstimo
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

  Widget buildInventoryCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InventarioItem(itemName: item['nameItem']),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['nameItem'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (item['amount'] != null) Text('Quantidade: ${item['amount']}'),
              if (item['description'] != null)
                Text('Descrição: ${item['description']}'),
            ],
          ),
        ),
      ),
    );
  }
}
