// ignore_for_file: camel_case_types, use_super_parameters, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Style/style.dart';
import 'PrincipalePage.dart';

class removeUsers extends StatefulWidget {
  const removeUsers({Key? key}) : super(key: key);

  @override
  _removeUsersState createState() => _removeUsersState();
}

class _removeUsersState extends State<removeUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  final RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9]{8,}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ici vous pourrez supprimer un utilisateur !'),
        actions:[
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrincipalePage()),
          );
        }
    ),
    const SizedBox(width: 740.0),
  ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment(0, -0.85),
              child: Text(
                'Bienvenue sur votre espace de suppression d\'utilisateur !',
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 70.0),
            SizedBox(
              height: 50,
              width: 440,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  labelStyle: inputDecorationStyle,
                  border: OutlineInputBorder(),
                ),
                style: inputStyle,
              ),
            ),
            const SizedBox(height: 100.0),
            ElevatedButton(
              onPressed: () async {
      
                String username = usernameController.text;
      
                if (username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pensez à bien remplir le champ !'),
                    ),
                  );
                } else if (!usernameRegExp.hasMatch(username)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('L\'adresse e-mail doit être écrite au format isen@junia.com.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil supprimé avec succès !'),
                    ),
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrincipalePage()),
                    );
      
      
                  try {
                    final response = await http.post(
                      Uri.parse('http://localhost:3000/auth/delete'),
                      body: {
                        'email': username,
                      },
                    );
      
                    if (response.statusCode == 200) {
                      print('Profil supprimé avec succès !');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrincipalePage()),
                      );
                    } else {
                      print('Erreur lors de la supppression du profil: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Erreur lors de la requête: $e');
                  }
                }
              },
              child: const Text('Supprimer l\'utilisateur'),
            ),
          ],
        ),
      ),
    );
  }
}

