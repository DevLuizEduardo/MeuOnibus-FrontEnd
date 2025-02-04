import 'package:flutter/cupertino.dart';
import 'package:meu_onibus_app/API/Request_Avisos.dart';
import 'package:meu_onibus_app/Models/Aviso.dart';

class AvisoProvider with ChangeNotifier {
  List<Aviso> _avisos = [];
  int _quantidadeAvisosNovos = 0;

  List<Aviso> get avisos => _avisos;
  int get quantidadeAvisosNovos => _quantidadeAvisosNovos;

  AvisoProvider(BuildContext context) {
    carregarAvisos(context);
  }

  Future<void> carregarAvisos(BuildContext context) async {
    try {
      final novos = await Request_Avisos().avisosNovos(context);
      final lidos = await Request_Avisos().avisoslidos(context);

      _avisos = [...novos, ...lidos]; // Junta todas as listas
      _quantidadeAvisosNovos =
          novos.length; // Define a quantidade de avisos novos
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar avisos: $e");
    }
  }
}
