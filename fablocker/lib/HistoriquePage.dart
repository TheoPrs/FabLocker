// ignore_for_file: file_names

import 'package:fablocker/PrincipalePage.dart';
import 'package:flutter/material.dart';

class Historique {
  final String casier;
  final String utilisateur;
  final DateTime date;

  Historique(this.casier, this.utilisateur, this.date);
}

class HistoriquePage extends StatelessWidget {
  final List<Historique> historiqueList = [
    Historique(
        'Casier 1', 'Alice', DateTime.now().subtract(const Duration(days: 1))),
    Historique(
        'Casier 2', 'Bob', DateTime.now().subtract(const Duration(days: 2))),
    Historique('Casier 3', 'Charlie',
        DateTime.now().subtract(const Duration(days: 3))),
  ];

  HistoriquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PrincipalePage()),
            );
          },
        ),
        title: const Text('Historique'),
      ),
      body: ListView.builder(
        itemCount: historiqueList.length,
        itemBuilder: (context, index) {
          final historique = historiqueList[index];
          return ListTile(
            title: Text(historique.casier),
            subtitle: Text('${historique.utilisateur} - ${historique.date}'),
          );
        },
      ),
    );
  }
}
