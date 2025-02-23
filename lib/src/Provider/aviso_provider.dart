import 'package:flutter/cupertino.dart';
import 'package:meu_onibus_app/src/Controllers/request_avisos.dart';
import 'package:meu_onibus_app/src/Models/Aviso.dart';

class aviso_provider with ChangeNotifier {
  List<Aviso> _avisos = [];
  int _quantidadeAvisosNovos = 0;

  List<Aviso> get avisos => _avisos;
  int get quantidadeAvisosNovos => _quantidadeAvisosNovos;

  aviso_provider(BuildContext context) {
    carregarAvisos(context);
  }

  Future<void> carregarAvisos(BuildContext context) async {
    try {
      final novos = await request_avisos().avisosNovos(context);
      final lidos = await request_avisos().avisoslidos(context);

      _avisos = [...novos, ...lidos]; // Junta todas as listas
      _quantidadeAvisosNovos =
          novos.length; // Define a quantidade de avisos novos
      notifyListeners();
    } catch (e) {
      print("Erro ao carregar avisos: $e");
    }
  }

  Future<bool> excluirAviso(int idAviso, BuildContext context) async {
    try {
      await request_avisos().excluirAviso(idAviso, context);
      _avisos.clear;

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }
}
