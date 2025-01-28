import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meu_onibus_app/LoginPage.dart';
import 'package:meu_onibus_app/menu_down.dart';

final storage = FlutterSecureStorage();

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Future.delayed(
        Duration(seconds: 3),
        () => verificarToken().then((value) {
              if (value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => menu_down()));
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9800), Colors.yellow],
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            child: Hero(
              tag: 'logo',
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 2), // Duração da animação
                curve: Curves.easeInOut, // Curva de animação
                child: Image.asset('assets/images/bus.png'), // Sua imagem
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<bool> verificarToken() async {
    String? token = await storage.read(key: 'acess_token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      return true;
    }

    return false;
  }
}
