import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/LoginPage.dart';
import 'package:meu_onibus_app/Models/Instituicao.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Request_Onibus {
  final storage = FlutterSecureStorage();

  Future<Instituicao?> listOnibus(BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');
    Instituicao? instituicao;

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('192.168.3.2:8080', '/onibus/listar-onibus');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        instituicao = Instituicao.fromJson(
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes)));

        return instituicao;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );

      return instituicao;
    }
  }
}
