class Onibus {
  final int id;
  final String numOnibus;

  Onibus({required this.id, required this.numOnibus});

  factory Onibus.fromJson(Map<String, dynamic> json) {
    return Onibus(
      id: json['id'],
      numOnibus: json['numOnibus'],
    );
  }
}
