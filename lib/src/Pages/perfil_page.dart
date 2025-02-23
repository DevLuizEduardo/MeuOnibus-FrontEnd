import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meu_onibus_app/src/Pages/login_page.dart';

class perfil_page extends StatefulWidget {
  const perfil_page({super.key});

  @override
  State<perfil_page> createState() => _perfil_pageState();
}

class _perfil_pageState extends State<perfil_page> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
      MaterialPageRoute(builder: (context) => login_page()),
      (route) => false,
    );
  }
}
