class Parada {
  final int id;
  final String endereco;

  Parada({required this.id, required this.endereco});

  factory Parada.fromJson(Map<String, dynamic> json) {
    return Parada(id: json['id'], endereco: json['endereco']);
  }
}
