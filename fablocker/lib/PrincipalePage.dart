import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToolInfo {
  String name;
  String status;
  String description;

  ToolInfo({
    required this.name,
    required this.status,
    required this.description,
  });
}

List<ToolInfo> tools = [];

List<ToolInfo> parseData(String jsonData) {
  // Implémentez la logique de parsing ici
  return [];
}

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/items'));
  if (response.statusCode == 200) {
    final jsonData = response.body;
    print(jsonData); // Afficher les données récupérées
    tools = parseData(jsonData);
  
    // Vous pouvez traiter les données ici selon vos besoins
  } else {
    // Gérer les erreurs de requête
    print('Erreur de requête: ${response.statusCode}');
  }
}

class PrincipalePage extends StatefulWidget {
  PrincipalePage({Key? key}) : super(key: key);

  @override
  _PrincipalePageState createState() => _PrincipalePageState();
}

class _PrincipalePageState extends State<PrincipalePage> {
  @override
  void initState() {
    super.initState();
    // Appeler fetchData lorsque la page est construite
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    const bool isAdmin = true; // Modifier selon la logique de votre application

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context); // Retour à l'écran précédent
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
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1,
          ),
          itemCount: tools.length, // Utilise la longueur de la liste tools
          itemBuilder: (context, index) {
            // Créer une GlobalKey pour chaque élément de la grille.
            final GlobalKey itemKey = GlobalKey();

            return InkWell(
              key: itemKey,
              onTap: () => _showCasierOptions(context, index, itemKey, isAdmin),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Casier : ${tools[index].name}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Outil : ${tools[index].status}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Disponibilité : ${tools[index].description}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'État :',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

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
        // À remplacer par votre navigation vers la page Historique
        print('Navigation vers la page Historique');
        break;
      default:
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
                Text('Description: ${toolInfo.description}'),
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
}
