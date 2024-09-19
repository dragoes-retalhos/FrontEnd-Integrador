import 'package:flutter/material.dart';

void main() {
  runApp(const Perfil(
    title: 'perfil',
  ));
}

class Perfil extends StatefulWidget {
  const Perfil({super.key, required this.title});

  final String title;

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Header'), backgroundColor: Colors.lightBlue),
        body: Stack(
          children: [
            // Conteúdo principal da tela
            Align(
              alignment: const Alignment(0, 0), // Centralizado
              child: CircleAvatar(
                radius: 80, // Tamanho do círculo
                backgroundImage: NetworkImage(
                  'https://example.com/link_da_sua_imagem.jpg',
                ), // Coloque o link da sua imagem
              ),
            ),
            // Botão no canto superior direito
            Positioned(
              top: 16, // Distância do topo da tela
              right: 16, // Distância da borda direita
              child: ClipOval(
                child: Material(
                  color: Colors.red, // Cor de fundo do botão
                  child: InkWell(
                    splashColor: Colors.blue, // Efeito de splash ao clicar
                    onTap: () {
                      //fazer logout do sistema
                    },
                    child: const SizedBox(
                      width: 56, // Largura do botão (circular)
                      height: 56, // Altura do botão (circular)
                      child: Icon(
                        Icons.logout, // Ícone de logout
                        color: Colors.white, // Cor do ícone
                        size: 30, // Tamanho do ícone
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*Positioned(
                child: ClipOval(
              child: Column(children: [
                const Text('teste'),
              ]),
            )),*/
          ],
        ),
      ),
    );
  }
}
