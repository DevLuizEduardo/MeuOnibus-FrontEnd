import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meu_onibus_app/API/Request_Markers.dart';
import 'package:meu_onibus_app/API/Request_Routes.dart';
import 'package:meu_onibus_app/Models/Ponto.dart';
import 'package:meu_onibus_app/mapsPage.dart';
import 'package:meu_onibus_app/widgets/PontoDetalhes.dart';

class GeolocationProvider extends ChangeNotifier {
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
  late GoogleMapController _mapsController;

  get mapsController => _mapsController;

  // Variáveis para a rota e para controlar o movimento do usuário
  List<LatLng> _rotaPoints = [];

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;

    _posicaoAtual();
    loadPontos();
  }

  loadPontos() async {
    try {
      final List<Ponto> pontos = await Request_Markers().listarPontos();
      final BitmapDescriptor customIcon = await _getCustomMarker();

      pontos.forEach((local) {
        print("Endereço : " +
            local.parada.endereco +
            " LAT : " +
            local.latitude.toString() +
            " LONG : " +
            local.longitude.toString());
      });

      Set<Marker> novosMarkers = pontos.map((ponto) {
        return Marker(
          markerId: MarkerId(ponto.parada.id.toString()),
          position: LatLng(ponto.latitude, ponto.longitude),
          icon: customIcon,
          infoWindow: InfoWindow(snippet: " "),
          onTap: () {
            showModalBottomSheet(
                context: appKey.currentState!.context,
                builder: (context) => PontoDetalhes(ponto: ponto));
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
    _mapsController.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, long)), // Atualiza a câmera no mapa
    );
  }

  void mudarModoTransporte(String novoModo) {
    modoTransporte = novoModo;
    polylines.clear();
    if (localId.isNotEmpty) {
      tracarRota(localId);
    }
    notifyListeners();
  }

  void clearRoute() {
    polylines.clear();
    localId = ""; // Remove as rotas do mapa
    notifyListeners();
    _mapsController.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, long)), // Atualiza a câmera no mapa
    );
    // Atualiza o mapa
  }

  Future<void> tracarRota(String placeid) async {
    try {
      LatLng origem = LatLng(lat, long);
      Map<String, dynamic> rotaData =
          await Request_Routes().getRoute(origem, placeid, modoTransporte);
      List<LatLng> pontosRota = rotaData["rota"];

      Polyline rota = Polyline(
        polylineId: PolylineId("rota"),
        color: Colors.blueAccent,
        visible: true,
        width: 5,
        points: pontosRota,
      );

      // Atualiza o conjunto de polylines com a rota
      polylines.add(rota);

      // Armazena os pontos da rota
      _rotaPoints = pontosRota;

      // Atualiza a distância e duração da rota
      distancia = rotaData["distancia"];
      duracao = rotaData["duracao"];
      // vai armazenar a rota em memoria
      localId = placeid;

      // Ajusta a câmera para cobrir toda a rota
      _adjustCameraToRoute(_rotaPoints);

      notifyListeners();
    } catch (e) {
      erro = "Erro ao traçar rota: $e";
      notifyListeners();
    }
  }

  // Método para ajustar a câmera com base na rota
  void _adjustCameraToRoute(List<LatLng> pontosRota) {
    if (pontosRota.isNotEmpty) {
      LatLngBounds bounds = _getLatLngBounds(pontosRota);
      _mapsController.animateCamera(
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

  Future<void> localizarNoMaps(String placeId) async {
    tracarRota(placeId);
  }
}
