import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  void _showCasierOptions(BuildContext context, int index) async {
    final selection = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 200.0, 100.0,
          100.0), // Vous pouvez ajuster la position si nécessaire
      items: [
        const PopupMenuItem(
          value: 'ouvrir',
          child: Text('Ouvrir'),
        ),
        const PopupMenuItem(
          value: 'informations',
          child: Text('Informations'),
        ),
        // Ajoutez d'autres options ici
      ],
    );

    // Effectuez des actions en fonction de l'option sélectionnée
    switch (selection) {
      case 'ouvrir':
        // Logique pour ouvrir le casier
        print('Ouvrir casier $index');
        break;
      case 'informations':
        // Logique pour afficher les informations
        break;
      default:
        print('Aucune action');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // TODO: Implement logout logic
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Nombre de colonnes
          crossAxisSpacing: 10.0, // Espace horizontal entre les cases
          mainAxisSpacing: 10.0, // Espace vertical entre les cases
          childAspectRatio: 1, // Ratio pour des cases carrées
        ),
        itemCount: 16, // Nombre total de cases
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => _showCasierOptions(context, index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Casier : int index',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Outil :',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Disponibilité :',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'État :',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
