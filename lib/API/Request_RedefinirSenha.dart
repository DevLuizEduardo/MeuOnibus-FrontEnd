import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/MyApp.dart';
import 'package:meu_onibus_app/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Request_DefinirSenha {
  final storage = FlutterSecureStorage();

  Future<bool> redefinirSenha(String senha, BuildContext context) async {
    var url = Uri.http('${Env.localHost}', '/auth/redefinir-senha');
    String? token = await storage.read(key: 'tokenReset');
    String json = convert.jsonEncode({'novaSenha': senha});

    final headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };

    var response = await http.post(url, headers: headers, body: json);

    if (response.statusCode == 200) {
      await storage.delete(key: 'tokenReset');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha redefinida com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, MyApp.START);

      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Problemas no Servidor por favor aguarde...')),
      );
      Navigator.pushReplacementNamed(context, MyApp.START);
      return false;
    }
  }
}
