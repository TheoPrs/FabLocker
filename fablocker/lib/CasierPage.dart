import 'package:flutter/material.dart';
import 'my_home_page.dart';

class CasierPage extends StatelessWidget {
  const CasierPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casier n'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              ); // Logique de déconnexion
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Caractéristique :',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Quantité'),
            Text('Objets stockés'),
            Text('Utilisateurs récents'),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Logique de sélection
              },
              child: Text('Sélectionner'),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        // Logique pour aller au casier précédent
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // Logique pour aller au casier suivant
                      },
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
