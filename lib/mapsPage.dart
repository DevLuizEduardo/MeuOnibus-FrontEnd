import 'package:flutter/material.dart';

class Mapspage extends StatefulWidget {
  const Mapspage({super.key});

  @override
  State<Mapspage> createState() => _MapspageState();
}

class _MapspageState extends State<Mapspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('GOOGLE MAPS'),
    );
  }
}
