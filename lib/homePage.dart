import 'package:flutter/material.dart';
import 'package:meu_onibus_app/API/Request_Onibus.dart';
import 'package:meu_onibus_app/detalhe_onibus.dart';
import 'package:meu_onibus_app/Models/Instituicao.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Instituicao? listOnibus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => carregarLista());
  }

  void carregarLista() async {
    listOnibus = await Request_Onibus().listOnibus(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEE7EE),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          // Define o tamanho do cabeçalho
          child: AppBar()),
      body: Column(children: [
        Image.asset(
          "assets/images/onibus_escolar.jpg",
          fit: BoxFit.cover,
          height: 200,
          width: 400,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFFF9800)),
          child: Row(children: [
            Image.asset(
              "assets/icons/icon_bus.png",
              width: 50,
              height: 30,
            ),
            Text(
              "ônibus",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ]),
        ),
        Expanded(
            child: listOnibus == null
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
                                  "assets/icons/icon_listBus.png",
                                  width: 30,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  listOnibus!.onibus[index].numOnibus,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            title: Text(
                              listOnibus!.nomeInstituicao,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () =>
                                mostrarDetalhes(listOnibus!.onibus[index].id),
                          ));
                    },
                    separatorBuilder: (_, ____) => Divider(),
                    itemCount: listOnibus!.onibus.length))
      ]),
    );
  }

  void mostrarDetalhes(int id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => DetalheOnibus(id: id)));
  }
}
