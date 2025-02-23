import 'package:flutter/material.dart';
import 'package:meu_onibus_app/src/Provider/config_maps_provider.dart';
import 'package:meu_onibus_app/src/Pages/myApp.dart';
import 'package:meu_onibus_app/src/Provider/aviso_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => aviso_provider(context)),
      ChangeNotifierProvider(create: (context) => config_maps_provider())
    ],
    child: myApp(),
  ));
}
