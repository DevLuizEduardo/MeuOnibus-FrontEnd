class Fotos {
  final String foto;

  Fotos({required this.foto});

  factory Fotos.fromJson(Map<String, dynamic> json) {
    return Fotos(foto: json['urlFotos']);
  }
}
