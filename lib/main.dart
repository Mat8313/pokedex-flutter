import 'package:flutter/material.dart';

import 'screens/Region_page.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const RegionPage(), // On appelle notre nouvelle page ici
    );
  }
}
