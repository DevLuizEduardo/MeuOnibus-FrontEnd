import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/src/Controllers/request_markers.dart';
import 'package:meu_onibus_app/src/Controllers/request_routes.dart';
import 'package:meu_onibus_app/src/Models/Ponto.dart';
import 'package:meu_onibus_app/src/Pages/maps_page.dart';
import 'package:meu_onibus_app/src/widgets/marker_detalhes.dart';

class config_maps_provider extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = "";
  Set<Marker> markers = Set<Marker>();
  Set<Polyline> polylines = {};
  String distancia = "";
  String localId = "";
  String duracao = "";
  String modoTransporte = "DRIVE";
  StreamSubscription<Position>? _positionStream;
  GoogleMapController? _mapsController;
  bool isMapReady = false;

  Future<void> initializeMap() async {
    await _posicaoAtual();
    await loadPontos();
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    isMapReady = true;
    notifyListeners();
  }

  loadPontos() async {
    try {
      final List<Ponto> pontos = await request_markers().listarPontos();
      final BitmapDescriptor customIcon = await _getCustomMarker();

      Set<Marker> novosMarkers = pontos.map((ponto) {
        return Marker(
          markerId: MarkerId(ponto.parada.id.toString()),
          position: LatLng(ponto.latitude, ponto.longitude),
          icon: customIcon,
          onTap: () {
            showModalBottomSheet(
                context: appKey.currentState!.context,
                builder: (context) => marker_detalhes(ponto: ponto));
          },
        );
      }).toSet();

      markers = novosMarkers;
      notifyListeners(); // Notifica a UI sobre a atualização
    } catch (e) {
      erro = "Erro ao carregar os pontos: ${e.toString()}";
      notifyListeners();
    }
  }

  // Configura a imagem para marcar os pontos de ônibus
  Future<BitmapDescriptor> _getCustomMarker() async {
    return BitmapDescriptor.asset(ImageConfiguration(size: Size(32, 60)),
        'assets/icons/icon_ponto_onibus.png');
  }

  Future<void> _posicaoAtual() async {
    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error(
          "Por favor, habilite a localização no seu dispositivo.");
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error("Você precisa autorizar o acesso à localização.");
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      // Abre as configurações do dispositivo para o usuário ativar a permissão
      await Geolocator.openAppSettings();
      return Future.error(
          "A permissão para localização foi negada permanentemente. Ative-a nas configurações.");
    }

    // Obtém a posição com uma precisão adequada
    startTrackingUserLocation();
  }

  void atualizarCamera() {
    if (_mapsController != null) {
      _mapsController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, long)), // Atualiza a câmera no mapa
      );
    }
  }

  void mudarModoTransporte(String novoModo) {
    modoTransporte = novoModo;

    polylines.clear();

    notifyListeners();
  }

  Future<void> clearRoute() async {
    polylines.clear();
    localId = ""; // Remove as rotas do mapa
    notifyListeners();
    atualizarCamera(); // Atualiza a câmera no mapa
  }

  Future<void> tracarRota(String placeid) async {
    try {
      LatLng origem = LatLng(lat, long);
      Map<String, dynamic> rotaData =
          await request_routes().getRoute(origem, placeid, modoTransporte);
      List<LatLng> pontosRota = rotaData["rota"];

      Polyline rota = Polyline(
        polylineId: PolylineId("rota"),
        color: Colors.blueAccent,
        visible: true,
        width: 5,
        points: pontosRota,
      );

      polylines.add(rota);

      distancia = rotaData["distancia"];
      duracao = rotaData["duracao"];
      // vai armazenar a rota em memoria
      localId = placeid;

      _adjustCameraToRoute(pontosRota);

      notifyListeners();
    } catch (e) {
      erro = "Erro ao traçar rota: $e";
      notifyListeners();
    }
  }

  // Método para ajustar a câmera com base na rota
  void _adjustCameraToRoute(List<LatLng> pontosRota) {
    if (pontosRota.isNotEmpty && _mapsController != null) {
      LatLngBounds bounds = _getLatLngBounds(pontosRota);
      _mapsController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50), // 50 é o padding
      );
    }
  }

  // Método para calcular os limites da rota
  LatLngBounds _getLatLngBounds(List<LatLng> pontos) {
    double minLat = pontos[0].latitude;
    double maxLat = pontos[0].latitude;
    double minLng = pontos[0].longitude;
    double maxLng = pontos[0].longitude;

    for (LatLng ponto in pontos) {
      if (ponto.latitude < minLat) minLat = ponto.latitude;
      if (ponto.latitude > maxLat) maxLat = ponto.latitude;
      if (ponto.longitude < minLng) minLng = ponto.longitude;
      if (ponto.longitude > maxLng) maxLng = ponto.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Método para escutar a localização do usuário em tempo real
  Future<void> startTrackingUserLocation() async {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Atualiza quando o usuário se mover 10 metros
      ),
    ).listen((Position position) {
      lat = position.latitude;
      long = position.longitude;

      atualizarCamera();

      notifyListeners(); // Atualiza o estado para refletir a nova posição
    });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    _positionStream?.cancel();

    super.dispose();
  }
}
