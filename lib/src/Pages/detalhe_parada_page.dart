import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Controllers/request_parada.dart';
import 'package:meu_onibus_app/src/Provider/config_maps_provider.dart';
import 'package:meu_onibus_app/src/Models/DescricaoParada.dart';
import 'package:meu_onibus_app/src/Pages/maps_page.dart';
import 'package:meu_onibus_app/src/widgets/caixa_pop-up.dart';
import 'package:meu_onibus_app/src/widgets/carrossel_imgs.dart';
import 'package:provider/provider.dart';

class detalhe_parada_page extends StatefulWidget {
  final int id;
  final String endereco;
  const detalhe_parada_page(
      {super.key, required this.id, required this.endereco});

  @override
  State<detalhe_parada_page> createState() => _detalhe_parada_pageState();
}

class _detalhe_parada_pageState extends State<detalhe_parada_page> {
  DescricaoParada? descricao;
  bool exibirBotaoVerMais = false;
  bool exibirDescricao = false;
  bool _isExpanded = false;
  String text = " ";
  String textoExibido = "";
  String textoRestante = "";
  final List<String> images = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carregarDecricao();
    });
    super.initState();
  }

  void carregarDecricao() async {
    descricao = await request_parada().paradaDescricao(context, widget.id);

    if (descricao == null) {
      return; // Evita erro se 'descricao' for null
    }

    _processarTexto();
    _processarImagens();

    setState(() {});
  }

  void _processarImagens() {
    if (descricao?.fotos != null && descricao!.fotos.isNotEmpty) {
      images.addAll(descricao!.fotos.map((x) => x.foto).toList());
    }
  }

  void _processarTexto() {
    if (descricao?.descricao == null || descricao!.descricao.isEmpty) {
      return;
    }

    text = descricao!.descricao;
    int limiteCaracteres = 180;

    // Número de caracteres antes do "..."

    if (text.length > limiteCaracteres) {
      setState(() {
        textoExibido = text.substring(0, limiteCaracteres);

        exibirBotaoVerMais = true;
      });
    } else {
      textoExibido = text;

      exibirBotaoVerMais = false;
    }
    exibirDescricao = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEEE7EE),
        appBar: AppBar(
          backgroundColor: Color(0xFFFF9800),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ), // Personalizando a seta
            onPressed: () {
              Navigator.pop(context); // Ação de voltar
            },
          ),
          title: Text('Ponto de Referência',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: Column(children: [
          carrossel_imgs(images: images), //Chama o Carrossel de imagens
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded =
                    !_isExpanded; // Alterna entre expandido e colapsado
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFFFF9800)),
              child: Text(
                widget.endereco,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: _isExpanded
                    ? null
                    : 1, // Expande o texto se _isExpanded for true
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow
                        .ellipsis, // Exibe o texto completo ou com "..."
                textAlign: TextAlign.center, // Centraliza o texto no container
                softWrap: true, // Permite a quebra de linha automática
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
              visible: exibirDescricao,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFFF9800), width: 2),
                  borderRadius: BorderRadius.circular(5), // Bordas arredondadas
                ),
                child: RichText(
                  textAlign:
                      TextAlign.start, //alinhamento do texto no container
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: textoExibido,
                      ), // Parte visível do texto
                      if (exibirBotaoVerMais) ...[
                        const TextSpan(text: "... "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              caixa_popup().mostrarPopUp(context, text);
                              //_mostrarDescricaoCompleta(context, text);
                            },
                            child: const Text(
                              "Ver mais",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            child: CupertinoButton(
              color: Color(0xFFFF9800),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Localizar no Maps',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    "assets/icons/icon_localizacao.png",
                    width: 28,
                    height: 28,
                  ),
                ],
              ),
              onPressed: () async => {
                context.read<config_maps_provider>().localId =
                    descricao!.placeId,
                context.read<config_maps_provider>().polylines.clear(),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => maps_page(),
                    ))
              },
            ),
          )
        ]));
  }
}
