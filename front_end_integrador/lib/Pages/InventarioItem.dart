import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Pages/perfil.dart';
import '../Components/bottomNavBar.dart';
import '../Pages/item_detalhe.dart';
import '../Pages/edit_item_page.dart'; // Importe a página de edição
import '../Pages/manutencao_item_page.dart'; // Importe a página de manutenção
import '../Pages/retornar_manutencao_page.dart'; // Importe a página de retornar manutenção

class InventarioItem extends StatefulWidget {
  final String itemName;

  InventarioItem({required this.itemName});

  @override
  _InventarioItemState createState() => _InventarioItemState();
}

class _InventarioItemState extends State<InventarioItem> {
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  TextEditingController filterController = TextEditingController();
  Color iconColor = const Color.fromARGB(255, 0, 0, 0); // Cor padrão do ícone
  Color textColor = Colors.black; // Cor padrão do texto
  FocusNode focusNode = FocusNode(); // FocusNode para o campo de texto
  bool isLoading = true; // Variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    fetchItems();

    // Ouvir as mudanças de foco
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          // Quando o campo está em foco
          iconColor = Colors.black; // Altera a cor do ícone para preto
          textColor = Colors.black; // Altera a cor do texto para preto
        } else {
          // Quando o campo não está mais em foco
          iconColor =
              const Color.fromARGB(255, 0, 0, 0); // Restaura a cor do ícone
          textColor = Colors.black; // Restaura a cor do texto
        }
      });
    });
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/item/by-name/${widget.itemName}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          items = data; // Atribuição direta dos dados recebidos
          filteredItems =
              data; // Inicialmente, os itens filtrados são todos os itens
          isLoading = false; // Atualiza o estado de carregamento
        });
      } else {
        throw Exception('Falha ao carregar os itens: ${response.body}');
      }
    } catch (e) {
      print('Erro: $e');
      setState(() {
        isLoading = false; // Atualiza o estado de carregamento em caso de erro
      });
    }
  }

  void filterItems(String query) {
    final filtered = items.where((item) {
      final serialNumber = item['serialNumber']?.toString() ?? '';
      return serialNumber.toLowerCase().contains(query.toLowerCase());
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
            widget.itemName,
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
              controller: filterController,
              focusNode: focusNode, // Adiciona o FocusNode ao TextField
              decoration: InputDecoration(
                labelText: 'Filtrar pelo Número de Série',
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
              onChanged:
                  filterItems, // Filtra os itens conforme o texto é digitado
            ),
            SizedBox(height: 16), // Espaço entre o campo de filtro e a lista
            Expanded(
              child: isLoading // Verifica o estado de carregamento
                  ? Center(child: CircularProgressIndicator())
                  : filteredItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return buildItemCard(item);
                          },
                        )
                      : Center(
                          child: Text(
                              'Nenhum item encontrado.')), // Mensagem quando não há itens
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

  Widget buildItemCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailPage(itemId: item['id']),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nameItem'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (item['serialNumber'] != null)
                      Text('Número de Série: ${item['serialNumber']}'),
                    if (item['status'] != null)
                      Text('status: ${item['status']}'),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditItemPage(itemId: item['id']),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.build),
                    onPressed: () {
                      if (item['status'] == 'INATIVO') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Item está inativo e não pode ser enviado para manutenção.')),
                        );
                      } else if (item['status'] == 'INDISPONÍVEL') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Item está emprestado e não pode ser enviado para manutenção.')),
                        );
                      } else if (item['status'] == 'MANUTENÇÃO') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RetornarManutencaoPage(itemId: item['id']),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManutencaoPage(itemId: item['id']),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
