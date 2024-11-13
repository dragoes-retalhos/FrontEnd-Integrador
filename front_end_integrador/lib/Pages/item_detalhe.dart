import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  Map<String, dynamic>? itemDetails;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/item/${widget.itemId}'));
      
      if (response.statusCode == 200) {
        setState(() {
          itemDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Item"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Erro ao carregar detalhes do item.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemDetails!['nameItem'] ?? 'Nome não disponível',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      if (itemDetails!['serialNumber'] != null)
                        Text('Número de Série: ${itemDetails!['serialNumber']}'),
                      if (itemDetails!['amount'] != null)
                        Text('Quantidade: ${itemDetails!['amount']}'),
                      if (itemDetails!['description'] != null)
                        Text('Descrição: ${itemDetails!['description']}'),
                      // Adicione outros detalhes conforme necessário
                    ],
                  ),
                ),
    );
  }
}
