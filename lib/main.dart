import 'package:flutter/material.dart';
import 'package:meu_onibus_app/GeolocationProvider.dart';
import 'package:meu_onibus_app/MyApp.dart';
import 'package:meu_onibus_app/AvisoProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AvisoProvider(context)),
      ChangeNotifierProvider(create: (context) => GeolocationProvider())
    ],
    child: MyApp(),
  ));
}
