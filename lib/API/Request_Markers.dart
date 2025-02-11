import 'package:meu_onibus_app/Models/Ponto.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Request_Markers {
  final storage = FlutterSecureStorage();

  Future<List<Ponto>> listarPontos() async {
    String? token = await storage.read(key: 'acess_token');

    if (token == null || JwtDecoder.isExpired(token)) {
      return []; // Retorna lista vazia se o token for inválido
    }

    var url = Uri.http('192.168.3.2:8080', '/maps/listar-markers');
    final headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (jsonResponse is List) {
        return await Future.wait(jsonResponse
            .map((x) async => await Ponto.fromJson(x as Map<String, dynamic>)));
      } else {
        throw Exception('Erro: resposta não é uma lista de pontos');
      }
    } else {
      throw Exception('Falha na requisição: ${response.statusCode}');
    }
  }
}
