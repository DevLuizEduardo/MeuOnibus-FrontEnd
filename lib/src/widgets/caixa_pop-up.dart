import 'package:flutter/material.dart';

class caixa_popup {
  void mostrarPopUp(BuildContext context, String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text("Descrição Completa"),
          content: SingleChildScrollView(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
