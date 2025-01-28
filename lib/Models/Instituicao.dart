import 'package:meu_onibus_app/Models/Onibus.dart';

class Instituicao {
  final String nomeInstituicao;
  final List<Onibus> onibus;

  Instituicao({required this.nomeInstituicao, required this.onibus});

  factory Instituicao.fromJson(Map<String, dynamic> json) {
    return Instituicao(
      onibus: List<Onibus>.from(
        json['onibus'].map((x) => Onibus.fromJson(x)),
      ),
      nomeInstituicao: json['nomeInstituicao'],
    );
  }
}
