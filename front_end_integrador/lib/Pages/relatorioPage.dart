import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../Components/bottomNavBar.dart';

class RelatorioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar Relatório'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categoria
            const Text('Categoria',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione a categoria',
              ),
              items: [],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),

            // Modelo
            const Text('Modelo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione o modelo',
              ),
            ),
            const SizedBox(height: 16),

            // Marca
            const Text('Marca', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione a marca',
              ),
            ),
            const SizedBox(height: 16),

            // Status
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCheckbox('Disponível')),
                Expanded(child: _buildCheckbox('Emprestado')),
                Expanded(child: _buildCheckbox('Em manutenção')),
                Expanded(child: _buildCheckbox('Inativo')),
              ],
            ),
            const SizedBox(height: 16),

            // Tipo de data
            const Text('Tipo de data',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione o tipo de data',
              ),
              items: [],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),

            // Período
            const Text('Selecione o período',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'dd/mm/aaaa',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'dd/mm/aaaa',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Número de Patrimônio
            const Text('Número de Patrimônio',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione o nº de patrimônio',
              ),
            ),
            const SizedBox(height: 32),

            // Botão Gerar Relatório
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Gerar relatório',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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

  Widget _buildCheckbox(String label) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Expanded(child: Text(label)),
      ],
    );
  }
}
