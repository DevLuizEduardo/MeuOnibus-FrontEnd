import 'package:meu_onibus_app/Models/Fotos_Parada.dart';

class DescricaoParada {
  final String descricao;
  final List<Fotos> fotos;

  DescricaoParada({required this.descricao, required this.fotos});

  factory DescricaoParada.fromJson(Map<String, dynamic> json) {
    return DescricaoParada(
        descricao: json['descricao'],
        fotos: List<Fotos>.from(json['fotos'].map((x) => Fotos.fromJson(x))));
  }
}
