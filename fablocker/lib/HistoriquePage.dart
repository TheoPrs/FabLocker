// ignore_for_file: file_names
import 'package:fablocker/PrincipalePage.dart';
import 'package:flutter/material.dart';
import 'Style/style.dart';
import 'package:intl/intl.dart';

class Historique {
  final int casier;
  final String item;
  final String utilisateur;
  final DateTime dateEmprunt;
  DateTime dateRetour;

  Historique(this.casier,this.item, this.utilisateur, this.dateEmprunt,this.dateRetour);
}

class HistoriquePage extends StatelessWidget {
  final int data;
  final List<Historique> historiqueList = [
    Historique(4, 'objet1','Alice', DateTime(2024,4,12,0,46),DateTime(2025,4,12,0,46)),
    Historique(4, 'objet1','Alice', DateTime(2024,4,12,0,46),DateTime(2025,4,12,0,46)),
    Historique(75, 'objet3','Bob', DateTime(2024,4,20,21,45), DateTime(2024,4,20,21,45)),
    Historique(3, 'objet2','Charlie',DateTime(2024,4,1,12,0), DateTime(0,0,0)),
  ];

  HistoriquePage({super.key, required this.data});

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 2),
          image: const DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
      child: ListView.builder(
        itemCount: historiqueList.length,
        itemBuilder: (context, index) {
          final historique = historiqueList[index];
          final zeroDateTime = DateTime(0,0,0);
          final formattedDateTimeLoan = 
            DateFormat('dd-MM-yyyy HH:mm').format(historique.dateEmprunt);
          final formattedDateTimeReturn = 
            DateFormat('dd-MM-yyyy HH:mm').format(historique.dateRetour);
          final dureeEmprunt = DateTime.now().difference(historique.dateEmprunt).inDays+1;
          final messageEmprunt = 'Objet encore en cours d\'emprunt depuis : $dureeEmprunt jours';
            if (data == historique.casier){
            return ListTile(
              subtitle: Column(
                children: [
                  Text('Casier : ${historique.casier} \n', style: basicText),
                  Text('Objet : ${historique.item}', style: basicText),
                  Text('Utilisateur : ${historique.utilisateur}', style: basicText),
                  Text('Date emprunt : $formattedDateTimeLoan', style: basicText),
                  if (historique.dateRetour == zeroDateTime) // Vérifie si la date de retour est égale à DateTime(0,0,0)
                    Text(messageEmprunt, style: basicText)
                  else
                  Text('Date retour : $formattedDateTimeReturn \n', style: basicText),
                ],
              ),
            );
            }
            else{
              return Container();
            }
        },
      ),
    ));
  }
}
