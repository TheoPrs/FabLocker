import 'package:flutter/material.dart';
import 'my_home_page.dart'; // Import du fichier contenant MyHomePage
import 'add_items.dart';
import 'add_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: MyHomePage(),
      //home: addItems(),
      home : addUsers()
    );
  }
}
