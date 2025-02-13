import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/LoginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meu_onibus_app/Models/Aviso.dart';
import 'package:meu_onibus_app/env.dart';

class Request_Avisos {
  final storage = FlutterSecureStorage();

  Future<List<Aviso>> avisosNovos(BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');
    List<Aviso> aviso;

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('${Env.localHost}', '/aviso/listar_avisos');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

        aviso = (jsonResponse['avisos'] as List)
            .map((x) => Aviso.fromJson(x))
            .toList();

        return aviso;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return [];
    }
  }

  Future<List<Aviso>> avisoslidos(BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');
    List<Aviso> aviso;

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('${Env.localHost}', '/aviso/listar_avisoslidos');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

        aviso = (jsonResponse['avisos'] as List)
            .map(
              (x) => Aviso.fromJson(x),
            )
            .toList();

        aviso.forEach((x) => x.lido = true);
        aviso.forEach((x) => print(x));
        return aviso;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return [];
    }
  }

  Future<bool> marcarAvisoLido(int id, BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('${Env.localHost}', '/aviso/registrar_avisos');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response =
          await http.post(url, headers: headers, body: id.toString());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return true;
    }
  }

  Future<bool> excluirAviso(int id, BuildContext context) async {
    String? token = await storage.read(key: 'acess_token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      var url = Uri.http('${Env.localHost}', '/aviso/excluir_aviso');
      final headers = {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      };

      final response =
          await http.post(url, headers: headers, body: id.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Falha na requisição: ${response.statusCode}');
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      return true;
    }
  }
}
