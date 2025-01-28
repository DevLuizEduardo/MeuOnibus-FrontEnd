import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/LoginPage.dart';
import 'package:meu_onibus_app/Models/Detalhe.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Request_Detalhe {
  final storage = FlutterSecureStorage();

  Future<Detalhe?> detalhe(int id, BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');
    Detalhe? detalhe;

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('192.168.3.2:8080', '/onibus/$id/detalhe');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        detalhe = Detalhe.fromJson(convert.jsonDecode(response.body));
        return detalhe;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return detalhe;
    }
  }
}
