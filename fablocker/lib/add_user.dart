import 'package:flutter/material.dart';
import 'Style/style.dart';

class addUsers extends StatefulWidget {
  const addUsers({super.key});

  @override
  _addUsers createState() => _addUsers();
}

class _addUsers extends State<addUsers> {
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
                  style: titleStyle
                ),
              ),

              
              const SizedBox(height: 40.0),
              
              
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
                  style: inputStyle
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
                  style: inputStyle
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
                  style: inputStyle
                ),
              ),

              
              const SizedBox(height: 30.0),
              
              
              //Bouton envoie formulaire
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String checkPassword = checkPasswordController.text;
    
                  if (username.isEmpty || password.isEmpty ||checkPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chaque champ doit être rempli !'),
                      ),
                    );
                  } 
                  else if (!usernameRegExp.hasMatch(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('L\'adresse e-mail doit être ecrite au format isen@junia.com et le mot de passe au format valide.'),
                      ),
                    );
                  } 
                  else if((!passwordRegExp.hasMatch(password) ||(!passwordRegExp.hasMatch(checkPassword)))){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Le mot de passe doit faire 8 caractères minimum avec des majuscules, minuscules ou bien des chiffres !'),
                      ),
                    );
                  } 
                  else if (password != checkPassword){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Les mots de passes doivent être identiques !'),
                      ),
                    ); 
                  }
                   else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil créé avec succès !'),
                      ),
                    );
                   }
                },
                child: const Text('Créer l\'utilsateur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}