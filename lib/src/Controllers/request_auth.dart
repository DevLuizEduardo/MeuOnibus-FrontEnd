import 'package:meu_onibus_app/src/Provider/aviso_provider.dart';
import 'package:meu_onibus_app/src/Provider/env.dart';
import 'package:meu_onibus_app/src/Pages/myApp.dart';
import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Models/Usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/src/Pages/redefinir_senha_page.dart';
import 'package:provider/provider.dart';

class request_auth {
  final storage = FlutterSecureStorage();

  Future<bool> login(Usuario dados, BuildContext context) async {
    var url = Uri.http(Env.localHost, '/auth/login');
    final headers = {"Content-type": "application/json"};
    String json = convert.jsonEncode(toJson(dados));

    var response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);

      if (data.containsKey("tokenReset")) {
        // Caso o retorno seja um Tokenreset
        String tokenreset = data["tokenReset"];

        await storage.write(key: "tokenReset", value: tokenreset);

        // Redireciona o usuário para a tela de redefinição de senha
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => redefinir_senha_page()));
        return true;
      } else if (data.containsKey("token")) {
        // Caso o retorno seja um token
        String token = data["token"];

        await saveToken(token);
        await Provider.of<aviso_provider>(context, listen: false)
            .carregarAvisos(context);
        // Redireciona o usuário para a tela principal
        Navigator.pushReplacementNamed(context, myApp.HOME);
      } else {
        print("Resposta inesperada da API.");
        return false;
      }

      return true;
    } else {
      print("Erro ao fazer login: ${response.statusCode}");
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: "acess_token", value: token);
  }
}
