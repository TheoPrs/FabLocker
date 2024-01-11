import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FabLocker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment(0, -0.85),
              child: Text(
                'Bienvenue sur votre application FabLocker !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(
                height: 20.0,
                width: 50), // Ajoute un espace entre les zones de texte
            SizedBox(
              height: 50,
              width: 440,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20.0), // Ajoute un espace entre les zones de texte
            SizedBox(
              height: 50,
              width: 440,
              child: TextField(
                obscureText: true, // Pour masquer le texte (mot de passe)
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16.0), // Ajoute un espace entre les zones de texte
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'appui sur le bouton
                print('Bouton appuyé!');
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF3C2A53),
    );
  }
}
