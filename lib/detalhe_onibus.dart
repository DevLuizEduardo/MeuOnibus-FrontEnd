import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meu_onibus_app/API/Request_Detalhe.dart';
import 'package:meu_onibus_app/Models/Detalhe.dart';
import 'package:meu_onibus_app/detalhe_parada.dart';

class DetalheOnibus extends StatefulWidget {
  final int id;
  const DetalheOnibus({super.key, required this.id});

  @override
  State<DetalheOnibus> createState() => _DetalheOnibusState();
}

class _DetalheOnibusState extends State<DetalheOnibus> {
  Detalhe? detalhe;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => carregarDetalhe());
  }

  void carregarDetalhe() async {
    detalhe = await Request_Detalhe().detalhe(widget.id, context);
    setState(() {});
  }

  void mostrarParada(int id, String endereco) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Detalhe_Parada(
                  id: id,
                  endereco: endereco,
                )));
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
        title: Text(
            detalhe != null ? 'Nº ${detalhe!.numOnibus}' : 'Carregando...',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              // backgroundImage: NetworkImage('https://www.exemplo.com/sua-foto.jpg'),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "Nome do Usuário",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFFF9800), width: 2),
                borderRadius: BorderRadius.circular(5), // Bordas arredondadas
              ),
              child: Column(
                children: [
                  Text(
                    "Horário do ônibus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (detalhe?.horarios != null && detalhe!.horarios.isNotEmpty)
                        ? '${detalhe!.horarios[0].horaInicio} - ${detalhe!.horarios[0].horaFim}'
                        : " ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (detalhe?.horarios != null && detalhe!.horarios.isNotEmpty)
                        ? '${detalhe!.horarios[1].horaInicio} - ${detalhe!.horarios[1].horaFim}'
                        : "  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFFFF9800)),
              child: Row(children: [
                Image.asset(
                  "assets/icons/icon_placa.png",
                  width: 50,
                  height: 30,
                ),
                Text(
                  "Paradas",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ]),
            ),
            Expanded(
                child: detalhe == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return Container(
                              color: Colors.white,
                              child: ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 20),
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/icons/icon_parada.png",
                                        width: 30,
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  title: Text(
                                    utf8.decode(detalhe!
                                        .paradas[index].endereco.codeUnits),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () => mostrarParada(
                                      detalhe!.paradas[index].id,
                                      detalhe!.paradas[index].endereco)));
                        },
                        separatorBuilder: (_, ____) => Divider(),
                        itemCount: detalhe!.paradas.length)),
          ],
        ),
      ),
    );
  }
}
