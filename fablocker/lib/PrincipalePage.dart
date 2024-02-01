// ignore_for_file: avoid_print, file_names, use_build_context_synchronously

import 'package:fablocker/HistoriquePage.dart';
import 'package:flutter/material.dart';
import 'ConnexionPage.dart';

class ToolInfo {
  String name;
  String status;
  String description;

  ToolInfo(
      {required this.name, required this.status, required this.description});
}

class PrincipalePage extends StatelessWidget {
  PrincipalePage({Key? key}) : super(key: key);

  // Exemple de liste des outils
  final List<ToolInfo> tools = List.generate(
    16,
    (index) => ToolInfo(
      name: 'Outil $index',
      status: 'Disponible',
      description: 'Très bo outils',
    ),
  );

  void _showCasierOptions(
      BuildContext context, int index, GlobalKey key, bool isAdmin) async {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx,
      offset.dy,
    );

    List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem(
        value: 'ouvrir',
        child: Text('Ouvrir'),
      ),
      const PopupMenuItem(
        value: 'informations',
        child: Text('Informations'),
      ),
    ];

    if (isAdmin) {
      menuItems.add(
        const PopupMenuItem(
          value: 'historique',
          child: Text('Historique'),
        ),
      );
    }

    final selection = await showMenu(
      context: context,
      position: position,
      items: menuItems,
    );

    switch (selection) {
      case 'ouvrir':
        // Logique pour ouvrir le casier
        print('Ouvrir casier $index');
        break;
      case 'informations':
        _showToolInformationDialog(context, tools[index]);
        break;
      case 'historique':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HistoriquePage()),
        );

        print('Ouvrir historique pour casier $index');
        break;
      default:
        print('Aucune action');
    }
  }

  void _showToolInformationDialog(BuildContext context, ToolInfo toolInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informations de l\'Outil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom de l\'Outil : ${toolInfo.name}'),
                Text('Statut : ${toolInfo.status}'),
                Text('Description: ${toolInfo.description}')
                // Ajoutez d'autres informations ici si nécessaire
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = true; // Modifier selon la logique de votre application

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          // Créer une GlobalKey pour chaque élément de la grille.
          final GlobalKey itemKey = GlobalKey();

          return InkWell(
            key: itemKey,
            onTap: () => _showCasierOptions(context, index, itemKey, isAdmin),
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
                      'Casier : $index',
                      style: const TextStyle(
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
