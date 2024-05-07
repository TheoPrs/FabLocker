// ignore_for_file: file_names, must_be_immutable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'Style/style.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'class/historique.dart';


List<Historique> historiqueList = [];

List<Historique> parseData (String jsonData){
  List<Historique> parsedData = [];
  final List<dynamic> data = jsonDecode(jsonData);
  for  (var histo in data ){
    parsedData.add(Historique(
      histo['casier'],
      histo['item'],
      histo['utilisateur'],
      DateTime.parse(histo['dateEmprunt']),
      DateTime.parse(histo['dateRetour']),
    ));
  } 
  return parsedData;
}

class HistoriquePage extends StatelessWidget {
  final int data;
  List<Historique> historiqueList = [
    Historique(1, 'objet1','Alice', DateTime(2024,4,12,0,46),DateTime(2025,4,12,0,46)),
    Historique(1, 'objet1','Alice', DateTime(2024,4,12,0,46),DateTime(2025,4,12,0,46)),
    Historique(1, 'objet3','Bob', DateTime(2024,4,20,21,45), DateTime(2024,4,20,21,45)),
    Historique(3, 'objet2','Charlie',DateTime(2024,4,1,12,0), DateTime(0,0,0)),
  ];
  /*
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization' : 'Bearer $userToken',};
    
    final response = await http.get(Uri.parse('https://api.example.com/data'),headers: headers);
    if (response.statusCode == 200) {
      final data = response.body;
      historiqueList = parseData(data);
    } else {
      throw Exception('Failed to fetch data');
    }
    print(historiqueList);
  }
  */
  HistoriquePage({super.key, required this.data});
  

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
      ));
  }
}
