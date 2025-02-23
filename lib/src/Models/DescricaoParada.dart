import 'package:meu_onibus_app/src/Models/Fotos_Parada.dart';

class DescricaoParada {
  final String descricao;
  final String placeId;
  final List<Fotos> fotos;

  DescricaoParada(
      {required this.descricao, required this.placeId, required this.fotos});

  factory DescricaoParada.fromJson(Map<String, dynamic> json) {
    return DescricaoParada(
        descricao: json['descricao'],
        placeId: json['placeId'],
        fotos: List<Fotos>.from(json['fotos'].map((x) => Fotos.fromJson(x))));
  }
}
