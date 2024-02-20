import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewUserApi extends StatelessWidget {
  final User user;

  const NewUserApi({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Vous ne pouvez pas faire d'appel asynchrone directement dans build(),
    // vous pouvez soit extraire cette logique dans une méthode séparée ou
    // utiliser un StatefulWidget.
    createUserProfile(context);
    
    // Retournez ici le widget que vous voulez afficher pendant que la requête
    // HTTP est en cours, comme un indicateur de chargement.
    return CircularProgressIndicator();
  }

  Future<void> createUserProfile(BuildContext context) async {
    Map<String, dynamic> userData = user.toJson();

    // Envoyer les données à l'API
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users'),
        body: jsonEncode(userData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        // Succès de la requête
        print('Profil créé avec succès !');
      } else {
        // Gestion des erreurs
        print('Erreur lors de la création du profil: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête: $e');
    }
  }
}

class User {
  final int rfid;
  final bool admin;
  final String mail;
  final String password;

  User({
    required this.rfid,
    required this.admin,
    required this.mail,
    required this.password,
  });

  // Méthode pour convertir l'objet User en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'rfid': rfid,
      'admin': admin,
      'mail': mail,
      'password': password,
    };
  }
}
