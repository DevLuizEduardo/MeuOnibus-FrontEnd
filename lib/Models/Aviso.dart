class Aviso {
  final int id;
  final String titulo;
  final String mensagem;
  bool lido = false;

  Aviso({required this.id, required this.titulo, required this.mensagem});

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
        id: json['id'], titulo: json['titulo'], mensagem: json['mensagem']);
  }
}
