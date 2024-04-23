import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Style/style.dart';
import 'PrincipalePage.dart';

class addUsers extends StatefulWidget {
  const addUsers({Key? key}) : super(key: key);

  @override
  _addUsersState createState() => _addUsersState();
}

class _addUsersState extends State<addUsers> {
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
        title: const Text('FabLocker'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Ajuster le chemin de l'image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment(0, -0.85),
                child: Text(
                  'Bienvenue sur votre espace d\'inscription !',
                  style: titleStyle,
                ),
              ),
              const SizedBox(height: 50.0),
              //Adresse email
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
              const SizedBox(height: 20.0),
              //Mot de passe
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe ',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),
              const SizedBox(height: 20.0),
              //Retype mot de passe
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: checkPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Tapez à nouveau votre mot de passe',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () async {

                  String username = usernameController.text;
                  String password = passwordController.text;
                  String checkPassword = checkPasswordController.text;

                  if (username.isEmpty || password.isEmpty || checkPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chaque champ doit être rempli !'),
                      ),
                    );
                  } else if (!usernameRegExp.hasMatch(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('L\'adresse e-mail doit être écrite au format isen@junia.com et le mot de passe au format valide.'),
                      ),
                    );
                  } else if ((!passwordRegExp.hasMatch(password) || (!passwordRegExp.hasMatch(checkPassword)))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Le mot de passe doit faire 8 caractères minimum avec des majuscules, minuscules ou bien des chiffres !'),
                      ),
                    );
                  } else if (password != checkPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Les mots de passe doivent être identiques !'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil créé avec succès !'),
                      ),
                    );


                    int rfid = 4515; 
                    User newUser = User(
                      rfid: rfid,
                      role: "user",
                      email: username,
                      password: password,
                    );
                    print(newUser.rfid);


                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrincipalePage()),
                      );

                    Map<String, dynamic> userData = newUser.toJson();

                    try {
                      final response = await http.post(
                        Uri.parse('http://localhost:3000/auth/register'),
                        body: {
                          'rfid': rfid.toString(),
                          'role': 'user',
                          'email': username,
                          'password': password,
                        },
                      );
                      print(response.statusCode);

                      if (response.statusCode == 200) {
                        print('Profil créé avec succès !');
                      } else if (response.statusCode == 400){
                        print('Le RFID est déjà attribué');
                      } else {
                        print('Erreur lors de la création du profil: ${response.statusCode}');
                      }
                    } catch (e) {
                      print('Erreur lors de la requête: $e');
                    }
                  }
                },
                child: const Text('Créer l\'utilisateur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final int rfid;
  final String role;
  final String email;
  final String password;

  User({
    required this.rfid,
    required this.role,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'rfid': rfid,
      'admin': role,
      'eemail': email,
      'password': password,
    };
  }
}
