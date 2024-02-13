import 'package:flutter/material.dart';
import 'HistoriquePage.dart'; // Assurez-vous que le chemin d'accès est correct

class ToolInfo {
  String name;
  String status;
  String description;

  ToolInfo(
      {required this.name, required this.status, required this.description});
}

class PrincipalePage extends StatefulWidget {
  @override
  _PrincipalePageState createState() => _PrincipalePageState();
}

class _PrincipalePageState extends State<PrincipalePage> {
  final List<ToolInfo> tools = List.generate(
    16,
    (index) => ToolInfo(
      name: 'Outil $index',
      status: 'Disponible',
      description: 'Très bon outil',
    ),
  );

  List<bool> isMenuOpen = List.generate(16, (index) => false);

  void toggleMenu(int index) {
    setState(() {
      isMenuOpen[index] = !isMenuOpen[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenez la hauteur de l'écran avec MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculez la hauteur disponible pour le menu déroulant
    // En supposant que l'AppBar et la barre de statut prennent ensemble 120px
    double availableHeight =
        screenHeight - 120; // Ajustez cette valeur si nécessaire

    return Scaffold(
        appBar: AppBar(
          title: const Text('Page d\'accueil'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Insérez ici la logique de déconnexion
                // Par exemple, naviguez vers l'écran de connexion ou appelez une fonction de déconnexion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Déconnexion'),
                      content:
                          const Text('Voulez-vous vraiment vous déconnecter ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Non'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Ferme la boîte de dialogue
                          },
                        ),
                        TextButton(
                          child: const Text('Oui'),
                          onPressed: () {
                            // Exécutez ici la logique de déconnexion
                            // Par exemple, effacez les données de l'utilisateur ou la session stockée
                            Navigator.of(context)
                                .pop(); // Ferme la boîte de dialogue
                            // Redirigez vers l'écran de connexion ou la page souhaitée après la déconnexion
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 2),
            image: const DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return GridTile(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    InkWell(
                      onTap: () => toggleMenu(index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          // Ajoutez un léger fond sombre pour assurer la lisibilité du texte blanc
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Casier : $index',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Outil : ${tools[index].name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Disponibilité : ${tools[index].status}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'État : ${tools[index].description}',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: isMenuOpen[index] ? 0 : -availableHeight,
                      left: 0,
                      right: 0,
                      child: Material(
                        elevation: 2.0,
                        color: Colors.blue,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: availableHeight),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Ouvrir',
                                      style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    // Logique pour ouvrir le casier
                                  },
                                ),
                                ListTile(
                                  title: const Text('Informations',
                                      style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    // Logique pour afficher les informations
                                  },
                                ),
                                ListTile(
                                  title: const Text('Historique',
                                      style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HistoriquePage()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
