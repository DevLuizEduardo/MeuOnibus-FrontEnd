import 'package:meu_onibus_app/src/Controllers/request_geocoding.dart';
import 'package:meu_onibus_app/src/Models/Fotos_Parada.dart';
import 'package:meu_onibus_app/src/Models/Parada.dart';

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

  static final request_geocoding geocoding = request_geocoding();

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
