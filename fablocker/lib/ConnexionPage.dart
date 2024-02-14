import 'package:fablocker/PrincipalePage.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  final RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9]{8,}$'); // Exige au moins 8 caractères alphanumériques

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
                  'Bienvenue sur votre application FabLocker !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse e-mail',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String testUsername = "theo@junia.student.com";
                  String testPassword = "17022001Tp";
                  
                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez bien entrer un nom d\'utilisateur ainsi qu\'un mot de passe !'),
                      ),
                    );
                  } else if ((!usernameRegExp.hasMatch(username)) || (!passwordRegExp.hasMatch(password))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('L\'adresse e-mail doit être ecrite au format isen@junia.com et le mot de passe au format valide.'),
                      ),
                    );
                  } else {
                    if (username == testUsername && password == testPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bienvenue'),
                        ),
                      );
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrincipalePage()),
                      );
                    }
                    else{
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Adresse e-mail ou mot de passe incorrect !'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}