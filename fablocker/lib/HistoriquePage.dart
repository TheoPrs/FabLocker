import 'package:flutter/material.dart';

// D'abord, nous définirons une classe pour représenter les données historiques.
class Historique {
  final String casier;
  final String utilisateur;
  final DateTime date;

  Historique(this.casier, this.utilisateur, this.date);
}

class HistoriquePage extends StatelessWidget {
  final List<Historique> historiqueList = [
    Historique('Casier 1', 'Alice', DateTime.now().subtract(Duration(days: 1))),
    Historique('Casier 2', 'Bob', DateTime.now().subtract(Duration(days: 2))),
    Historique(
        'Casier 3', 'Charlie', DateTime.now().subtract(Duration(days: 3))),
  ];

  HistoriquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
