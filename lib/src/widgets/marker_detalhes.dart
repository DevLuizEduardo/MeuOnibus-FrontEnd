import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Provider/config_maps_provider.dart';
import 'package:meu_onibus_app/src/Models/Ponto.dart';
import 'package:meu_onibus_app/src/widgets/carrossel_imgs.dart';
import 'package:provider/provider.dart';

class marker_detalhes extends StatelessWidget {
  final Ponto ponto;

  const marker_detalhes({super.key, required this.ponto});

  @override
  Widget build(BuildContext context) {
    final List<String> imagens = ponto.fotos.map((x) => x.foto).toList();

    return Container(
      color: Color(0xFFEEE7EE),
      height: 400,
      child: Column(
        children: [
          carrossel_imgs(images: imagens),
          Text(
            ponto.parada.endereco,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final local = context.read<config_maps_provider>();
              if (local.polylines.isNotEmpty) {
                local.polylines.clear();
              }
              local.localId = ponto.place_id;
              await local.tracarRota(ponto.place_id);
              // Usa "driving" como exemplo
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            icon: Icon(Icons.directions, color: Colors.white, size: 30),
            label: Text(
              'Mostrar Rota',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
