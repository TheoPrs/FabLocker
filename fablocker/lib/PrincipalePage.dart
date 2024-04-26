import 'dart:convert';
import 'package:flutter/material.dart';
import 'HistoriquePage.dart';
import 'package:http/http.dart' as http;
import 'class/locker.dart';
import 'class/toolInfos.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<ToolInfo> tools = [];

List<ToolInfo> parseData(String jsonData) {
  List<ToolInfo> parsedData = [];
  final List<dynamic> data = json.decode(jsonData);
  for (var item in data) {
    parsedData.add(ToolInfo(
      locker: item['locker'],
      availability: item['availability'],
      weight: item['weight'],
      name: item['name'],
      borrow_duration: item['borrow_duration'],
      description: item['description'],
    ));
  }
  return parsedData;
}

class PrincipalePage extends StatefulWidget {
  PrincipalePage({Key? key}) : super(key: key);

  @override
  _PrincipalePageState createState() => _PrincipalePageState();
}

class _PrincipalePageState extends State<PrincipalePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');
    print(userToken);
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization' : 'Bearer $userToken',};
    final response = await http.get(Uri.parse('http://localhost:3000/api/items'),headers: headers);
    if (response.statusCode == 200) {
      final jsonData = response.body;
      setState(() {
        tools = parseData(jsonData);
        tools.sort((a, b) => a.locker.id.compareTo(b.locker.id));
        isLoading = false;
      });
    } else {
      print('Erreur de requête: ${response.statusCode}');
    }
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
      body: isLoading
          ? Container(        
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            child: const Center(
            child: CircularProgressIndicator(), // Garder le CircularProgress ici
            ),)
          : Container(
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
                  final String textAvailability = stateAvailability == true ? 'Disponible' : 'Indisponible';

                  return InkWell(
                    key: itemKey,
                    onTap: () => _showCasierOptions(context, index, itemKey, isAdmin),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Casier : ${tools[index].locker.id}',
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
                              'État : $textAvailability',
                              style: const TextStyle(
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
          MaterialPageRoute(builder: (context) => HistoriquePage(data: tools[index].locker.id,)),
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
                Text('Description: ${toolInfo.description}'),
                Text('Durée d\'emprunt maximale : ${toolInfo.borrow_duration} jours'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
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