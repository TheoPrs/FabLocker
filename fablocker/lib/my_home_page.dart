import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // App est inactive ou détachée, vous pouvez effectuer des actions de nettoyage ici si nécessaire.
      usernameController.dispose();
      passwordController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FabLocker'),
      ),
      body: Padding(
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
            const SizedBox(
                height: 20.0,
                width: 50), // Ajoute un espace entre les zones de texte
            SizedBox(
              height: 50,
              width: 440,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                    color: Colors.white), // Ajouté pour le texte en blanc
              ),
            ),
            const SizedBox(height: 20.0), // Ajoute un espace entre les zones de texte
            SizedBox(
              height: 50,
              width: 440,
              child: TextField(
                controller: passwordController,
                obscureText: true, // Pour masquer le texte (mot de passe)
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                    color: Colors.white), // Ajouté pour le texte en blanc
              ),
            ),
            const SizedBox(height: 16.0), // Ajoute un espace entre les zones de texte
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;

                print('Nom d\'utilisateur : $username');
                print('Mot de passe : $password');
              },
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF3C2A53),
    );
  }
}