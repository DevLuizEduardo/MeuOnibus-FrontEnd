import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/GeolocationProvider.dart';
import 'package:meu_onibus_app/widgets/transport_button.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class Mapspage extends StatefulWidget {
  const Mapspage({super.key});

  @override
  State<Mapspage> createState() => _MapspageState();
}

class _MapspageState extends State<Mapspage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final local = context.watch<GeolocationProvider>();
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
                  context.read<GeolocationProvider>().clearRoute();
                },
                backgroundColor: Colors.redAccent,
                shape: const CircleBorder(),
                child: Icon(Icons.clear, color: Colors.white),
              ),
            ),
          ),
        ]));
  }
}
