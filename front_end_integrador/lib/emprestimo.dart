import 'package:flutter/material.dart';

class EmprestimoPage extends StatefulWidget {
  const EmprestimoPage({super.key});

  @override
  _EmprestimoPageState createState() => _EmprestimoPageState();
}

class _EmprestimoPageState extends State<EmprestimoPage> {
  int _selectedIndex = 1;

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
        backgroundColor: const Color(0xFF0000FF),
        iconTheme: const IconThemeData(
            color: Colors.white), // Define a cor do ícone de voltar como branco
        title: const Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Página de Emprestimo',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 4),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Alinha o conteúdo no topo
            children: [
              const SizedBox(height: 20),
              const Text(
                'VAMOS REALIZAR UM EMPRESTIMO!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildInputField('Quem será o responsável', Icons.filter_list),
              const SizedBox(height: 16),
              _buildInputField(
                  'Insira o número de Patrimonio', Icons.filter_list),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          100, 86, 100, 245), // Cor do botão "Confirmar"
                      padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: () {
                      // Ação de confirmação
                    },
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  Widget _buildInputField(String hintText, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
