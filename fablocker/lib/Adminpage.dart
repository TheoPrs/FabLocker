import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  void _showCasierOptions(BuildContext context, int index, GlobalKey key) async {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx,
      offset.dy,
    );

    final selection = await showMenu(
      context: context,
      position: position, // Utilisez la position calculée ici
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
          // Créez une GlobalKey pour chaque élément de la grille
          final GlobalKey itemKey = GlobalKey();

          return InkWell(
            key: itemKey, // Attribuez la clé ici
            onTap: () => _showCasierOptions(context, index, itemKey),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Casier : $index', // Assurez-vous d'utiliser la variable index ici
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Outil :',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'Disponibilité :',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Text(
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

void main() {
  runApp(const MaterialApp(home: AdminPage()));
}
