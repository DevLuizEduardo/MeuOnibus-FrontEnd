import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/env.dart';

class Request_Routes {
  static String apiKey = Env.apiKey;
  static const String endpoint =
      "https://routes.googleapis.com/directions/v2:computeRoutes";

  Future<Map<String, dynamic>> getRoute(
      LatLng origem, String placeId, String modo) async {
    final headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask":
          "routes.duration,routes.distanceMeters,routes.polyline"
    };

    final body = {
      "origin": {
        "location": {
          "latLng": {"latitude": origem.latitude, "longitude": origem.longitude}
        }
      },
      "destination": {"placeId": placeId},
      "travelMode": modo.toUpperCase(), // O modo deve estar em MAIÚSCULO
      "computeAlternativeRoutes": false,
      "polylineEncoding": "ENCODED_POLYLINE"
    };

// Se o modo for DRIVE, adicionamos o routingPreference
    if (modo.toUpperCase() == "DRIVE") {
      body["routingPreference"] = "TRAFFIC_AWARE";
    }

    try {
      final response = await http.post(Uri.parse(endpoint),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);

        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final route = data["routes"][0];

// Decodifica a polyline
          List<List<num>> decodedPoints =
              decodePolyline(route["polyline"]["encodedPolyline"]);

// Converte para uma lista de LatLng
          List<LatLng> routeCoords = decodedPoints
              .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
              .toList();

          // Obtém distância e duração
          String distancia =
              "${(route["distanceMeters"] / 1000).toStringAsFixed(2)} km";
          String duracao = _formatarDuracao(route["duration"]);

          return {
            "rota": routeCoords,
            "distancia": distancia,
            "duracao": duracao,
          };
        } else {
          throw Exception("Nenhuma rota encontrada.");
        }
      } else {
        throw Exception(
            "Erro na requisição: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Erro ao obter rota: $e");
    }
  }

  // Método para formatar duração (ex: "1h 23min")
  String _formatarDuracao(String duration) {
    int totalSegundos = int.tryParse(duration.replaceAll("s", "")) ?? 0;

    int horas = totalSegundos ~/ 3600;
    int minutos = (totalSegundos % 3600) ~/ 60;
    int segundos = totalSegundos % 60;

    print(duration);

    if (horas > 0) {
      return "${horas}h ${minutos}min";
    } else if (minutos > 0) {
      return "${minutos}min";
    } else {
      return "${segundos}s";
    }
  }
}
