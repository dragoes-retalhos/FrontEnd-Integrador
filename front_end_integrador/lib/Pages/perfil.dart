import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

@override
class _PerfilPageState extends State<PerfilPage> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/home'); // Página inicial
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/import');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(
            context, '/beneficiados'); // Página de beneficiados
      } else if (index == 3) {
        Navigator.pushReplacementNamed(context, '/itens'); // Página de itens
      }
    }
  }

  String userName = 'João';
  String email = 'email@email.com';
  String senha = '*****';

  void _showEditNameDialog() {
    final TextEditingController _controller =
        TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Nome'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userName = _controller.text; // Atualiza o nome
                });
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailDialog() {
    final TextEditingController _controller =
        TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Email'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Novo Email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  email = _controller.text; // Atualiza o nome
                });
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSenhaDialog() {
    final TextEditingController _controller =
        TextEditingController(text: senha);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar senha'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Nova senha'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  senha = _controller.text; // Atualiza o nome
                });
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(245, 245, 245, 0),
        appBar: AppBar(
          backgroundColor: Color(0xFF0000FF),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Volta para a tela anterior
            },
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil',
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
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10.0),
              child: Icon(Icons.account_circle, color: Colors.white, size: 28),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: MediaQuery.of(context).size.height *
                        0.6, // Ajusta a posição do CircleAvatar
                    child: Container(
                      width: 160, // Diâmetro total (raiz * 2)
                      height: 160, // Diâmetro total (raiz * 2)
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black, // Cor da borda
                          width: 5, // Largura da borda
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 80,

                        // Tamanho do círculo maior
                        backgroundImage: NetworkImage(
                          'data:image/jpeg;base64,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',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.6 +
                        5, // Ajusta a posição do ícone para encostar no círculo
                    right: 180, // Distância à direita do CircleAvatar
                    child: GestureDetector(
                      onTap: () {
                        // Ação ao clicar no ícone
                        print("Ícone de edição clicado!");
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black, // Cor da borda
                            width: 2, // Largura da borda
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5), // Espaçamento interno
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Fundo do círculo menor
                          ),
                          child: Icon(
                            Icons.photo, // Ícone de edição
                            color: Colors.blue, // Cor do ícone
                            size: 20, // Tamanho do ícone
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 300, // Ajuste a posição vertical
              left: 100, // Ajuste a posição horizontal
              right: 100, // Ajusta a margem direita
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome:', // Texto principal
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${userName}', // Subtexto
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed:
                        _showEditNameDialog, // Chama o método para mostrar o diálogo

                    child: Text('Editar'), // Botão para abrir o diálogo
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Cor do texto
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Arredondar os cantos
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 370, // Ajuste a posição vertical
              left: 100, // Ajuste a posição horizontal
              right: 100, // Ajusta a margem direita
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:', // Texto principal
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${email}', // Subtexto
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed:
                        _showEditEmailDialog, // Chama o método para mostrar o diálogo

                    child: Text('Editar'), // Botão para abrir o diálogo
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Cor do texto
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Arredondar os cantos
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 440, // Ajuste a posição vertical
              left: 100, // Ajuste a posição horizontal
              right: 100, // Ajusta a margem direita
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Senha:', // Texto principal
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${senha}', // Subtexto
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed:
                        _showEditSenhaDialog, // Chama o método para mostrar o diálogo

                    child: Text('Editar'), // Botão para abrir o diálogo
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Cor do texto
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Arredondar os cantos
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      ),
    );
  }
}
