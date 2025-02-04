import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meu_onibus_app/LoginPage.dart';
import 'package:meu_onibus_app/Models/DescricaoParada.dart';

class Request_Parada {
  final storage = FlutterSecureStorage();

  Future<DescricaoParada?> paradaDescricao(BuildContext context, int id) async {
    String? token = await storage.read(key: 'acess_token');
    DescricaoParada? descricao;

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('192.168.3.2:8080', '/onibus/parada/$id');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        descricao = DescricaoParada.fromJson(
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes)));

        // print(descricao.descricao);

        return descricao;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return descricao;
    }
  }
}
