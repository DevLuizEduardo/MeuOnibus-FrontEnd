import 'package:meu_onibus_app/src/Models/Horario.dart';
import 'package:meu_onibus_app/src/Models/Parada.dart';

class Detalhe {
  final String numOnibus;
  final String motoristaNome;
  final String urlFoto;
  final List<Horario> horarios;
  final List<Parada> paradas;

  Detalhe(
      {required this.numOnibus,
      required this.motoristaNome,
      required this.urlFoto,
      required this.horarios,
      required this.paradas});

  factory Detalhe.fromJson(Map<String, dynamic> json) {
    return Detalhe(
        numOnibus: json['numOnibus'],
        motoristaNome: json['motoristaNome'],
        urlFoto: json['urlFoto'],
        horarios:
            List<Horario>.from(json['horario'].map((x) => Horario.fromJson(x))),
        paradas:
            List<Parada>.from(json['paradas'].map((x) => Parada.fromJson(x))));
  }
}
