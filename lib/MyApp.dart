import 'package:flutter/material.dart';
import 'package:meu_onibus_app/menu_down.dart';
import 'package:meu_onibus_app/startPage.dart';

class MyApp extends StatelessWidget {
  static const START = '/';
  static const HOME = 'menu_dow';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFFF9800),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(),
        ),
        routes: {
          START: (context) => Startpage(),
          HOME: (context) => menu_down(),
        });
  }
}
