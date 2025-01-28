import 'package:flutter/material.dart';
import 'package:meu_onibus_app/MyApp.dart';
import 'package:meu_onibus_app/TokenSave.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TokenSave(),
    child: MyApp(),
  ));
}
