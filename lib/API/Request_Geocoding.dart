import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meu_onibus_app/env.dart';

class Request_Geocoding {
  static String apiKey = Env.apiKey; // Substitua pela sua API Key

  Future<Map<String, dynamic>> getCoordenadas(String address) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "OK") {
          final result = data["results"][0];
          final location = result["geometry"]["location"];
          final placeId = result["place_id"];

          return {
            "latitude": location["lat"],
            "longitude": location["lng"],
            "place_id": placeId,
          };
        } else {
          throw Exception("Endereço não encontrado");
        }
      } else {
        throw Exception("Erro ao buscar coordenadas");
      }
    } catch (e) {
      throw Exception("Erro na requisição: $e");
    }
  }
}
