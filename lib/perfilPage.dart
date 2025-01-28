import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meu_onibus_app/LoginPage.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "MENU",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true // Centraliza o título

            ),
        body: Column(children: [
          Container(
            child: TextButton(
              onPressed: _Logout,
              child: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 25,
                    color: Colors.black,
                  ),
                  Text('Sair do App',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ],
              ),
            ),
          )
        ]));
  }

  void _Logout() async {
    await storage.deleteAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
