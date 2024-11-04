import 'package:flutter/material.dart';
import 'emprestimo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(
          context, '/home'); // Navega para a página inicial
    } else if (index == 1) {
      // Já estamos na página de empréstimo, então não faça nada
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
          context, '/beneficiados'); // Navega para a página de beneficiados
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
          context, '/itens'); // Navega para a página de itens
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0000FF),
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0, top: 5.0),
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10.0),
            child: Icon(Icons.notifications, color: Colors.white, size: 28),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, top: 10.0),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageButton(
                    context, 'assets/images/icon_emprestimo.png', 'Empréstimo'),
                _buildImageButton(
                    context, 'assets/images/icon_inventario.png', 'Inventário'),
                _buildImageButton(
                    context, 'assets/images/icon_relatorio.png', 'Relatórios'),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
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
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF1A00FF),
          unselectedItemColor: const Color.fromRGBO(64, 64, 64, 100),
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildImageButton(
      BuildContext context, String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Empréstimo') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmprestimoPage()),
          );
        }
        // Adicione navegação para outras páginas, se necessário
      },
      child: Column(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color.fromRGBO(53, 53, 53, 100),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      String title, String status, String location, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Status: $status'),
            Text('Localização: $location'),
            Text('Descrição: $description'),
          ],
        ),
      ),
    );
  }
}
