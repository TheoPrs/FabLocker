import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'HistoriquePage.dart';


class ToolInfo {
  int id_locker;
  bool availability;
  int weight;
  String name;
  String status;
  String description;

  ToolInfo({
    required this.id_locker,
    required this.availability,
    required this.weight,
    required this.name,
    required this.status,
    required this.description,
  });
}

List<ToolInfo> tools = [];

List<ToolInfo> parseData(String jsonData) {
  List<ToolInfo> parsedData = [];
  final List<dynamic> data = json.decode(jsonData);
  for (var item in data) {
    parsedData.add(ToolInfo(
      id_locker: item['id_locker'],
      availability: item['availability'],
      weight: item['weight'],
      name: item['name'],
      status: item['availability'] ? 'Disponible' : 'Indisponible',
      description: item['description'],
    ));
  }
  return parsedData;
}

Future<void> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/items'));
  if (response.statusCode == 200) {
    final jsonData = response.body;
    tools = parseData(jsonData);
  } else {
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    const bool isAdmin = true; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context); 
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
          itemCount: tools.length, 
          itemBuilder: (context, index) {
            final GlobalKey itemKey = GlobalKey();
            bool? stateAvailability = tools[index].availability;
            final String textAvailability = stateAvailability == true ? 'Ouvert' : 'Fermé';

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
                        'Casier : ${tools[index].id_locker}',
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
                        'Disponibilité : $textAvailability',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'État : ${tools[index].status}',
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
        // Mettre à jour la disponibilité de l'outil
        print('Ouvrir casier');
        //
        break;
      case 'informations':
        _showToolInformationDialog(context, tools[index]);
        break;
      case 'historique':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoriquePage(data: tools[index].id_locker,)),
        );
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
