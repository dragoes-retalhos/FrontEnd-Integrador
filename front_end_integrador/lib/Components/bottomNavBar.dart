import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
      selectedItemColor: selectedIndex == -1 ? Color.fromRGBO(64, 64, 64, 100) : Color(0xFF1A00FF),
      unselectedItemColor: Color.fromRGBO(64, 64, 64, 100),
      backgroundColor: Colors.white,
      onTap: onItemTapped,
    );
  }
}
