import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Provider/aviso_provider.dart';
import 'package:meu_onibus_app/src/Models/Aviso.dart';
import 'package:meu_onibus_app/src/Pages/detalhe_aviso_page.dart';
import 'package:provider/provider.dart';

class avisos_Page extends StatefulWidget {
  @override
  _avisos_PageState createState() => _avisos_PageState();
}

class _avisos_PageState extends State<avisos_Page> {
  // Função para atualizar a lista de avisos
  Future<void> _atualizarLista() async {
    if (mounted) {
      await Provider.of<aviso_provider>(context, listen: false)
          .carregarAvisos(context);
    }
  }

  Future<void> _abrirDetalheAviso(BuildContext context, Aviso aviso) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detalhe_aviso_page(aviso: aviso)),
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
      body: Consumer<aviso_provider>(
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
