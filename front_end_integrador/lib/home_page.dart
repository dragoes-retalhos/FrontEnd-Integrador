import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
                'Página inicial',
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
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            child: Icon(Icons.account_circle, color: Colors.white, size: 28),
          ),
        ],
        toolbarHeight: 80, // Altura ajustada para 80px
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageButton(
                    'assets/images/icon_emprestimo.png', 'Empréstimo'),
                _buildImageButton(
                    'assets/images/icon_inventario.png', 'Inventário'),
                _buildImageButton(
                    'assets/images/icon_relatorio.png', 'Relatórios'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search and filter',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildItemCard('Notebook', 'Emprestado',
                'Rua Armando Luis Arrosi 1370', 'Notebook Pichau Gamer'),
            _buildItemCard('Notebook', 'Emprestado',
                'Rua Armando Luis Arrosi 1370', 'Notebook Pichau Gamer'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Cor da sombra
              spreadRadius: 5, // Expansão da sombra
              blurRadius: 7, // Desfoque da sombra
              offset:
                  Offset(0, 3), // Deslocamento da sombra (horizontal, vertical)
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/icon_home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/icon_import.png')),
              label: 'Importar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Beneficiados',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Itens',
            ),
          ],
          selectedItemColor: Color(0xFF1A00FF),
          unselectedItemColor: Color.fromRGBO(64, 64, 64, 100),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImageButton(String imagePath, String label) {
    return Column(
      children: [
        Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 60,
                height: 60,
              ),
              SizedBox(
                  height: 8), // Aumentar o espaçamento entre imagem e label
              Text(
                label,
                style: TextStyle(
                  color: Color.fromRGBO(53, 53, 53, 100),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(
      String title, String status, String location, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Status: $status'),
            Text('Localização: $location'),
            Text('Descrição: $description'),
          ],
        ),
      ),
    );
  }
}
