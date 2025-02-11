class Parada {
  final int id;
  final String endereco;
  final String placeId;
  final double lat;
  final double long;

  Parada(
      {required this.id,
      required this.endereco,
      required this.placeId,
      required this.lat,
      required this.long});

  factory Parada.fromJson(Map<String, dynamic> json) {
    return Parada(
        id: json['id'],
        endereco: json['endereco'],
        placeId: json['placeId'],
        lat: json['lat'],
        long: json['log']);
  }
}
