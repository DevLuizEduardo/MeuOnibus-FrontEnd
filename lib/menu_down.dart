import 'package:flutter/material.dart';
import 'package:meu_onibus_app/detalhe_onibus.dart';
import 'package:meu_onibus_app/homePage.dart';
import 'package:meu_onibus_app/mapsPage.dart';
import 'package:meu_onibus_app/notificationPage.dart';
import 'package:meu_onibus_app/perfilPage.dart';

class menu_down extends StatefulWidget {
  const menu_down({super.key});

  @override
  State<menu_down> createState() => _menu_downState();
}

class _menu_downState extends State<menu_down> {
  int _selectedIndex = 0;

  var _page = [
    Homepage(),
    Mapspage(),
    Notificationpage(),
    PerfilPage(),
    DetalheOnibus(id: 0)
  ];

  int _notificationCount = 5;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 2) {
        _notificationCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
          )),
      body: Center(
        child: _page[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/icon_guide.png')),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/icon_maps.png')),
            label: 'Paradas',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior:
                  Clip.none, // Permite o ponto vermelho ultrapassar o ícone
              children: [
                ImageIcon(AssetImage('assets/icons/icon_notification.png')),
                if (_notificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$_notificationCount', // Exibe a quantidade de notificações
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10, // Tamanho da fonte
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notificação',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFF9800),
        unselectedItemColor: Colors.black54,
        selectedIconTheme: IconThemeData(
          size: 45, // Tamanho do ícone quando selecionado
        ),
        unselectedIconTheme: IconThemeData(
          size: 35, // Tamanho do ícone quando não selecionado
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}
