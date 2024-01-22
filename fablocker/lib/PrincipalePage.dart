// ignore_for_file: avoid_print, file_names

import 'package:fablocker/HistoriquePage.dart';
import 'package:flutter/material.dart';

class PrincipalePage extends StatelessWidget {
  const PrincipalePage({Key? key}) : super(key: key);

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
        // Logique pour afficher les informations
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

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = true;

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
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
        ),
        itemCount: 16,
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
