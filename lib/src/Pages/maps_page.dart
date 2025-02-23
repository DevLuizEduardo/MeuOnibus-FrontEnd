import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/src/Provider/config_maps_provider.dart';
import 'package:meu_onibus_app/src/widgets/transport_button.dart';
import 'package:provider/provider.dart';

final appKey = GlobalKey();

class maps_page extends StatefulWidget {
  const maps_page({super.key});

  @override
  State<maps_page> createState() => _maps_pageState();
}

class _maps_pageState extends State<maps_page> {
  late GoogleMapController mapController;
  bool _isMapLoading = true; // Controla a exibição do indicador de carregamento

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificarERastrearRota();
  }

  void _verificarERastrearRota() {
    final geo = context.read<config_maps_provider>();

    if (geo.localId.isNotEmpty && geo.polylines.isEmpty) {
      geo.tracarRota(geo.localId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<config_maps_provider>();
    bool visib = local.localId.isNotEmpty;

    return Scaffold(
      key: appKey,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ponto de ônibus Map'),
            SizedBox(width: 8),
            ImageIcon(
              AssetImage('assets/icons/icon_ponto_onibus_page.png'),
              size: 24,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(local.lat, local.long),
              zoom: 16.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              local.onMapCreated(controller);
              setState(() {
                _isMapLoading = false; // Mapa carregado, esconder indicador
              });
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: local.markers,
            polylines: local.polylines,
          ),
          if (_isMapLoading) // Exibe indicador enquanto o mapa carrega
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Visibility(
              visible: !_isMapLoading,
              child: Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  heroTag: "bbt1",
                  onPressed: () {
                    local.atualizarCamera();
                  },
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: Icon(Icons.my_location, color: Colors.black),
                ),
              )),
          Visibility(
            visible: visib,
            child: transportButton(),
          ),
          Visibility(
            visible: visib,
            child: Positioned(
              bottom: 170,
              right: 20,
              child: FloatingActionButton(
                heroTag: "bbt2",
                onPressed: () {
                  context.read<config_maps_provider>().clearRoute();
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
              top: 10,
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
        ],
      ),
    );
  }
}
