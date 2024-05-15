// ignore_for_file: use_build_context_synchronously, use_super_parameters, library_private_types_in_public_api, unused_local_variable, prefer_const_constructors

import 'dart:convert';
import 'package:fablocker/PrincipalePage.dart';
import 'package:flutter/material.dart';
import 'Style/style.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'class/historique.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/bubbleBackground.dart';

List<Historique> historiqueList = [];

List<Historique> parseData(dynamic jsonData) {
  List<Historique> parsedData = [];
  if (jsonData != null && jsonData is List) {
    for (var histo in jsonData) {
      if (histo != null && histo is Map<String, dynamic>) {
        String id = histo['id'].toString();
        String item = histo['item']['name'].toString();
        String utilisateur = histo['user']['email'].toString();
        DateTime? startDate = histo['startDate'] != null ? DateTime.parse(histo['startDate']) : null;
        DateTime? endDate = histo['endDate'] != null ? DateTime.parse(histo['endDate']) : null;
        DateTime? returnDate = histo['returnDate'] != null ? DateTime.parse(histo['returnDate']) : null;
        int dureeAutorisee = histo['item']['borrow_duration'];
        int dureeEmprunt = endDate!.difference(startDate!).inDays + 1;
        parsedData.add(Historique(int.tryParse(id) ?? 0, item, utilisateur, startDate, endDate, returnDate!, dureeAutorisee));
      }
    }
  }
  print(parsedData);
  return parsedData;
}

class HistoriquePage extends StatefulWidget {
  final int data;

  const HistoriquePage({Key? key, required this.data}) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('token');
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $userToken',
      };
      int itemId = widget.data;
      final response = await http.get(
          Uri.parse('http://localhost:3000/api/borrows/$itemId'),
          headers: headers);
      if (response.statusCode == 200) {
        final data = response.body;
        if (data != null && data.isNotEmpty) {
          // Vérifier si la réponse est un tableau ou un objet
          dynamic jsonData = jsonDecode(response.body);
          if (jsonData is List) {
            // La réponse est un tableau, parse les données normalement
            setState(() {
              historiqueList = parseData(jsonData);
              _isLoading = false;
            });
          } else {
            // La réponse est un objet, encapsule-le dans un tableau et parse les données
            List<dynamic> jsonDataList = [jsonData];
            setState(() {
              historiqueList = parseData(jsonDataList);
              _isLoading = false;
            });
          }
        } else {
          // La réponse ne contient pas de données
          setState(() {
            _isLoading = false;
          });
          // Gérer le cas où la réponse ne contient pas de données
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Aucun historique trouvé'),
                content: const Text('Il n\'y a pas d\'historique d\'emprunt pour cet objet.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrincipalePage()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Gérer le cas où la récupération des données échoue
        throw Exception('Failed to fetch data response: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
      // Gérer le cas où une erreur se produit lors de la récupération des données
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur de récupération des données'),
            content: const Text('Une erreur s\'est produite lors de la récupération des données. Veuillez réessayer plus tard.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
            : Stack(
            children: [
              const BubbleBackground(),
               ListView.builder(
              itemCount: historiqueList.length,
              itemBuilder: (context, index) {
                final historique = historiqueList[index];
                final zeroDateTime = DateTime(0, 0, 0);
                final formattedDateTimeLoan = DateFormat('dd-MM-yyyy HH:mm')
                    .format(historique.dateEmprunt);
                final formattedDateTimeReturn = DateFormat('dd-MM-yyyy HH:mm')
                    .format(historique.dateRetour);
                final dureeEmprunt = DateTime.now()
                    .difference(historique.dateEmprunt)
                    .inDays +
                    1;
                final messageEmprunt =
                    'Objet encore en cours d\'emprunt depuis : $dureeEmprunt jours';
                if (widget.data == historique.casier) {
                  return ListTile(
                    subtitle: Column(
                      children: [
                        Text('Casier : ${historique.casier} \n',
                            style: basicText),
                        Text('Objet : ${historique.item}',
                            style: basicText),
                        Text('Utilisateur : ${historique.utilisateur}',
                            style: basicText),
                        Text('Date emprunt : $formattedDateTimeLoan',
                            style: basicText),
                        Text('Date retour : $formattedDateTimeReturn',
                              style: basicText),
                        Text('Durée autorisée pour l\'objet : ${historique.dureeAutorisee} jours',
                            style: basicText),
                        Text('Durée de l\'emprunt : $dureeEmprunt jours',
                            style: basicText),  
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
               ),
            ],
            ),
    );
  }
}
