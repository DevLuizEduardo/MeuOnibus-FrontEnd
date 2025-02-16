import 'package:flutter/material.dart';
import 'package:meu_onibus_app/AvisoProvider.dart';
import 'package:meu_onibus_app/Models/Aviso.dart';
import 'package:meu_onibus_app/detalheAvisos.dart';
import 'package:provider/provider.dart';

class AvisosPage extends StatefulWidget {
  @override
  _AvisosPageState createState() => _AvisosPageState();
}

class _AvisosPageState extends State<AvisosPage> {
  // Função para atualizar a lista de avisos
  Future<void> _atualizarLista() async {
    if (mounted) {
      await Provider.of<AvisoProvider>(context, listen: false)
          .carregarAvisos(context);
    }
  }

  Future<void> _abrirDetalheAviso(BuildContext context, Aviso aviso) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalheAviso(aviso: aviso)),
    );
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Avisos'),
            SizedBox(width: 8),
            ImageIcon(
              AssetImage('assets/icons/icon_notification.png'),
              size: 24,
            ),
          ],
        ),
      ),
      body: Consumer<AvisoProvider>(
        builder: (context, avisoProvider, child) {
          final avisos = avisoProvider.avisos;

          if (avisos.isEmpty) {
            return Center(child: Text("Nenhum aviso disponível"));
          }

          return RefreshIndicator(
            onRefresh: _atualizarLista,
            child: ListView.builder(
              itemCount: avisos.length,
              itemBuilder: (context, index) {
                final aviso = avisos[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.asset(
                      aviso.lido
                          ? "assets/icons/icon_mensage_lido.png"
                          : "assets/icons/icon_mensage.png",
                      width: 20,
                    ),
                    title: Text(aviso.titulo),
                    subtitle: Text(
                      aviso.mensagem,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => _abrirDetalheAviso(context, aviso),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
