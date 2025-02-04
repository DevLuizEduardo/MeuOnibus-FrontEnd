import 'package:flutter/material.dart';
import 'package:meu_onibus_app/API/Request_Avisos.dart';
import 'package:meu_onibus_app/Models/Aviso.dart';

class DetalheAviso extends StatefulWidget {
  final Aviso aviso;
  DetalheAviso({super.key, required this.aviso});

  @override
  State<DetalheAviso> createState() => _DetalheAvisoState();
}

class _DetalheAvisoState extends State<DetalheAviso> {
  late Aviso avisoAtual;

  @override
  void initState() {
    super.initState();
    avisoAtual = widget.aviso;
    Future.delayed(Duration.zero, () => _marcarLido());
  }

  void _marcarLido() async {
    if (!avisoAtual.lido) {
      await Request_Avisos().marcarAvisoLido(avisoAtual.id, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          icon: Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: Icon(Icons.delete_forever_sharp, size: 30),
            onPressed: () {
              _excluirAviso();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              avisoAtual.titulo, // UTF-8 já tratado automaticamente
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              avisoAtual.mensagem, // UTF-8 já tratado automaticamente
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  void _excluirAviso() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Excluir Aviso"),
        content: Text("Tem certeza que deseja excluir este aviso?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Fecha o diálogo antes de excluir

              bool sucesso =
                  await Request_Avisos().excluirAviso(avisoAtual.id, context);

              if (sucesso) {
                if (mounted) {
                  // Verifica se o widget ainda está na árvore
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Aviso excluído com sucesso!")),
                  );
                  Navigator.pop(
                      context); // Retorna `true` para atualizar a lista
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro ao excluir o aviso!")),
                  );
                }
              }
            },
            child: Text("Excluir"),
          ),
        ],
      ),
    );
  }
}
