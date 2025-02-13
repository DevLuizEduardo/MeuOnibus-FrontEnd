import 'package:meu_onibus_app/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meu_onibus_app/Models/Usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/env.dart';

class Request_Auth {
  final storage = FlutterSecureStorage();

  Future<bool> login(Usuario dados, BuildContext context) async {
    var url = Uri.http('${Env.localHost}', '/auth/login');
    final headers = {"Content-type": "application/json"};
    String json = convert.jsonEncode(toJson(dados));

    var response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);

      if (data.containsKey("tokenReset")) {
        // Caso o retorno seja um Tokenreset
        String tokenreset = data["tokenreset"];
        await storage.write(key: "tokenreset", value: tokenreset);

        // Redireciona o usuário para a tela de redefinição de senha
        //Navigator.pushReplacementNamed(context, "/resetPassword");
        print("Tokenreset salvo, redirecionando para a redefinição de senha.");
      } else if (data.containsKey("token")) {
        // Caso o retorno seja um token
        String token = data["token"];

        await saveToken(token);

        print(token);

        // Redireciona o usuário para a tela principal
        Navigator.pushReplacementNamed(context, MyApp.HOME);
        print("Token e refreshToken salvos com sucesso.");
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
