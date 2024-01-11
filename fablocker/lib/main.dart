import 'package:flutter/material.dart';
import 'my_home_page.dart'; // Import du fichier contenant MyHomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
