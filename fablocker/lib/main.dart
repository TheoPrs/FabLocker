import 'package:flutter/material.dart';
import 'ConnexionPage.dart'; 
import 'add_items.dart';
import 'add_user.dart';
import 'PrincipalePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home : MyHomePage(),
      //home : addItems(),
      //home : addUsers(),
    );
  }
}
