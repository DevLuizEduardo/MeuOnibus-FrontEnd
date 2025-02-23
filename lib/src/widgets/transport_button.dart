import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Provider/config_maps_provider.dart';
import 'package:provider/provider.dart';

class transportButton extends StatefulWidget {
  const transportButton({
    Key? key,
  }) : super(key: key);

  @override
  _transportButtonState createState() => _transportButtonState();
}

class _transportButtonState extends State<transportButton> {
  bool isExpanded = false;

  // Padrão: Caminhada

  @override
  Widget build(BuildContext context) {
    final status = context.watch<config_maps_provider>();
    return Positioned(
      bottom: 100, // Mantém o botão fixo no canto inferior direito
      right: 20,
      child: Row(
        children: [
          // 🔥 Envolve os botões em ClipRect para evitar overflow
          ClipRect(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isExpanded ? 180 : 0, // Expande na horizontal
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: isExpanded
                        ? [
                            _buildTransportButton(
                                Icons.directions_car, "DRIVE"),
                            _buildTransportButton(
                                Icons.directions_bike, "BICYCLE"),
                            _buildTransportButton(
                                Icons.directions_walk, "WALK"),
                          ]
                        : [],
                  ),
                )),
          ),

          // Botão principal com o ícone selecionado
          FloatingActionButton(
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                _getIconForMode(status
                    .modoTransporte), // Atualiza o ícone com base no modo selecionado
                key: ValueKey(status.modoTransporte),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para obter o ícone correspondente ao modo de transporte selecionado
  IconData _getIconForMode(String mode) {
    switch (mode) {
      case "DRIVE":
        return Icons.directions_car;
      case "BICYCLE":
        return Icons.directions_bike;
      case "WALK":
        return Icons.directions_walk;
      default:
        return Icons.directions; // ícone padrão
    }
  }

  Widget _buildTransportButton(IconData icon, String mode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FloatingActionButton(
        mini: true,
        shape: CircleBorder(),
        backgroundColor:
            context.read<config_maps_provider>().modoTransporte == mode
                ? Colors.blue
                : Colors.white,
        onPressed: () => {
          context.read<config_maps_provider>().mudarModoTransporte(mode),
          isExpanded = false
        },
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
