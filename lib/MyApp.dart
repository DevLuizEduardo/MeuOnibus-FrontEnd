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
          /*  appBarTheme: AppBarTheme(
            toolbarHeight: 50, // Altura padrão do cabeçalho
            backgroundColor: Color(0xFFFF9800),
          ),*/
          primaryColor: Color(0xFFFF9800),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(
            // Define a transição padrão
            builders: {
              TargetPlatform.android:
                  SlidePageTransition(), // Aparece da direita no Android
              TargetPlatform.iOS:
                  CupertinoPageTransitionsBuilder(), // Animação nativa do iOS
            },
          ),
        ),
        /*builder: (context, child) {
          return SafeArea(child: child!);
        },*/
        routes: {
          START: (context) => Startpage(),
          HOME: (context) => menu_down(),
        });
  }
}

class SlidePageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0), // Começa fora da tela à direita
        end: Offset.zero, // Termina na posição normal
      ).animate(animation),
      child: child,
    );
  }
}
