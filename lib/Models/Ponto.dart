import 'package:meu_onibus_app/API/Request_Geocoding.dart';
import 'package:meu_onibus_app/Models/Fotos_Parada.dart';
import 'package:meu_onibus_app/Models/Parada.dart';

class Ponto {
  final Parada parada;
  final List<Fotos> fotos;
  final double latitude;
  final double longitude;
  final String place_id;

  Ponto(
      {required this.parada,
      required this.fotos,
      required this.latitude,
      required this.longitude,
      required this.place_id});

  static final Request_Geocoding geocoding = Request_Geocoding();

  static Future<Ponto> fromJson(Map<String, dynamic> json) async {
    final parada = Parada.fromJson(json['endereco']);
    final List<Fotos> fotos = (json['fotos'] as List<dynamic>?)
            ?.map((x) => Fotos.fromJson(x))
            .toList() ??
        [];

    final coordinates = await geocoding.getCoordenadas(parada.endereco);

    return Ponto(
      parada: parada,
      fotos: fotos,
      latitude: coordinates["latitude"]!,
      longitude: coordinates["longitude"]!,
      place_id: coordinates["place_id"]!,
    );
  }
}
