import 'package:flutter/material.dart';
import 'perfil.dart';

class ImportPage extends StatefulWidget {
  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home'); // Página inicial
      } else if (index == 1) {
        Navigator.pushReplacementNamed(
            context, '/import'); // Página de empréstimo
      } else if (index == 2) {
        Navigator.pushReplacementNamed(
            context, '/beneficiados'); // Página de beneficiados
      } else if (index == 3) {
        Navigator.pushReplacementNamed(context, '/itens'); // Página de itens
      }
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
                'Página de importação',
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
)
        ],
        toolbarHeight: 80, // Altura ajustada para 80px

      
      ),
          body: Center(
      child: Text(
        'Funcionalidade em construção',
        style: TextStyle(fontSize: 18, color: Colors.grey),
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
              offset: Offset(0, 3),
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
          selectedItemColor: Color(0xFF1A00FF),
          unselectedItemColor: Color.fromRGBO(64, 64, 64, 100),
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
