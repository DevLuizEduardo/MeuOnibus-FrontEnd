import 'package:flutter/material.dart';
import 'package:meu_onibus_app/AvisoProvider.dart';
import 'package:meu_onibus_app/homePage.dart';
import 'package:meu_onibus_app/mapsPage.dart';
import 'package:meu_onibus_app/avisosPage.dart';
import 'package:meu_onibus_app/perfilPage.dart';
import 'package:provider/provider.dart';

class menu_down extends StatefulWidget {
  const menu_down({super.key});

  @override
  State<menu_down> createState() => _menu_downState();
}

class _menu_downState extends State<menu_down> {
  int _selectedIndex = 0;

  final List<Widget> _page = [
    Homepage(),
    Mapspage(),
    AvisosPage(),
    PerfilPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: _page[_selectedIndex],
      ),
      bottomNavigationBar: Consumer<AvisoProvider>(
        builder: (context, avisoProvider, child) {
          return BottomNavigationBar(
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
                  clipBehavior: Clip.none,
                  children: [
                    const ImageIcon(
                        AssetImage('assets/icons/icon_notification.png')),
                    if (_selectedIndex != 2 &&
                        avisoProvider.quantidadeAvisosNovos > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              avisoProvider.quantidadeAvisosNovos.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
                label: 'Mais',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFFF9800),
            unselectedItemColor: Colors.black54,
            selectedIconTheme: const IconThemeData(size: 45),
            unselectedIconTheme: const IconThemeData(size: 35),
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
