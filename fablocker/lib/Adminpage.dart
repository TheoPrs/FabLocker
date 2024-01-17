import 'package:fablocker/HistoriquePage.dart';
import 'package:flutter/material.dart';

class Adminpage extends StatelessWidget {
  const Adminpage({super.key});

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriquePage()),
              );
              // Si vous voulez imprimer aussi, vous pouvez conserver cette ligne.
              print('Case $index tapped');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
