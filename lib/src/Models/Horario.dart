class Horario {
  final String horaInicio;
  final String horaFim;

  Horario({required this.horaInicio, required this.horaFim});

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(horaInicio: json['horaInicio'], horaFim: json['horaFim']);
  }
}
