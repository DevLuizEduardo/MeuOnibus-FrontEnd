import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/ConfigMapsProvider.dart';
import 'package:meu_onibus_app/widgets/transport_button.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class Mapspage extends StatefulWidget {
  const Mapspage({
    super.key,
  });

  @override
  State<Mapspage> createState() => _MapspageState();
}

class _MapspageState extends State<Mapspage> {
  late GoogleMapController mapController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Garante que a verificação acontece mesmo após mudanças no Provider
    _verificarERastrearRota();
  }

  void _verificarERastrearRota() {
    final geo = context.read<ConfigMapsProvider>();

    if (geo.localId.isNotEmpty && geo.polylines.isEmpty) {
      geo.tracarRota(geo.localId);
      print("Está chamando a rota");
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<ConfigMapsProvider>();
    bool visib = local.localId.isNotEmpty;

    return Scaffold(
        key: appKey,
        appBar: AppBar(
          title: Row(
            mainAxisSize:
                MainAxisSize.min, // Para evitar ocupar todo o espaço disponível
            children: [
              Text('Ponto de ônibus Map'),
              SizedBox(width: 8), // Espaço entre o título e o ícone
              ImageIcon(
                AssetImage('assets/icons/icon_ponto_onibus_page.png'),
                size: 24,
              ),
            ],
          ),
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(local.lat, local.long),
              zoom: 16.0,
            ),
            onMapCreated: local.onMapCreated,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: local.markers,
            polylines: local.polylines,
          ),
          Positioned(
              bottom: 20, // Ajusta a posição para ficar no rodapé
              right: 20,
              child: FloatingActionButton(
                heroTag: "bbt1",
                onPressed: () {
                  local.atualizarCamera();
                },
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                child: Icon(Icons.my_location, color: Colors.black),
              )),
          Visibility(
            visible: visib,
            child: TransportButton(),
          ),
          Visibility(
            visible: visib,
            child: Positioned(
              bottom: 170, // Ajuste a posição conforme necessário
              right: 20,
              child: FloatingActionButton(
                heroTag: "bbt2",
                onPressed: () {
                  context.read<ConfigMapsProvider>().clearRoute();
                },
                backgroundColor: Colors.redAccent,
                shape: const CircleBorder(),
                child: Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ),
          Visibility(
            visible: visib,
            child: Positioned(
              top: 10, // Ajuste a posição conforme necessário
              left: MediaQuery.of(context).size.width / 4,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer, color: Colors.blue),
                    SizedBox(width: 5),
                    Text(
                      "${local.duracao} | ${local.distancia}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
