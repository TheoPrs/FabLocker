import 'dart:convert';
import 'package:fablocker/ConnexionPage.dart';
import 'package:fablocker/remove_user.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'HistoriquePage.dart';
import 'package:http/http.dart' as http;
import 'class/locker.dart';
import 'class/toolInfos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addItemsPage.dart';
import 'Style/style.dart';
import 'remove_item.dart';
import 'widgets/bubbleBackground.dart';

List<ToolInfo> tools = [];

List<ToolInfo> parseData(String jsonData) {
  final List<dynamic> data = json.decode(jsonData);
  List<ToolInfo> parsedData = [];
  for (var item in data) {
    parsedData.add(ToolInfo(
      locker: Locker.fromJson(item['locker']),
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
  const PrincipalePage({Key? key}) : super(key: key);

  @override
  _PrincipalePageState createState() => _PrincipalePageState();
}

class _PrincipalePageState extends State<PrincipalePage> {
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');
    print(userToken);

    if (userToken != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(userToken);
      setState(() {
        isAdmin = payload['role'] == 'admin';
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $userToken',
      };
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/items'),
        headers: headers,
      );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayPastel,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Page d\'accueil'),
        actions: [
          if (isAdmin) ...[
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Supprimer un élément'),
                      content: const Text('Que souhaitez-vous supprimer ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Supprimer un objet'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const removeItems(),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: const Text('Supprimer un utilisateur'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const removeUsers(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 250.0),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ajouter un nouvel élément'),
                      content: const Text('Que souhaitez-vous ajouter ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Ajouter un casier'),
                          onPressed: () async {
                            try {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? userToken = prefs.getString('token');
                              final response = await http.post(
                                Uri.parse('http://localhost:3000/api/lockers'),
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'Bearer $userToken',
                                },
                              );
                              if (response.statusCode == 201) {
                                print('Objet créé avec succès !');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => addItemsPage(),
                                  ),
                                );
                              } else {
                                print('Erreur');
                              }
                            } catch (e) {
                              print('Erreur lors de la requête: $e');
                            }
                          },
                        ),
                        TextButton(
                          child: const Text('Ajouter un objet'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => addItemsPage()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          const SizedBox(width: 250.0),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const connexionPage()),
              );
            },
          ),
          const SizedBox(width: 150.0),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                BubbleBackground(),
                GridView.builder(
                  padding: const EdgeInsets.all(30.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
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
                        decoration: getToolContainerDecoration(tools[index].availability),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              decoration: getCasierHeaderDecoration(),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                'Casier ${tools[index].locker.id}',
                                style: basicText.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Outil : ${tools[index].name}', style: basicText),
                                    Text('État : $textAvailability', style: basicText),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  void _showCasierOptions(BuildContext context, int index, GlobalKey key, bool isAdmin) async {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double centerX = offset.dx + size.width / 2.4;
    final double centerY = offset.dy + size.height / 2.4;
    final RelativeRect position = RelativeRect.fromLTRB(
      centerX,
      centerY,
      MediaQuery.of(context).size.width - centerX,
      MediaQuery.of(context).size.height - centerY,
    );

    List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem(value: 'ouvrir', child: Text('Ouvrir')),
      const PopupMenuItem(value: 'informations', child: Text('Informations')),
    ];

    if (isAdmin) {
      menuItems.add(const PopupMenuItem(value: 'historique', child: Text('Historique')));
    }

    final selection = await showMenu(context: context, position: position, items: menuItems);

    switch (selection) {
      case 'ouvrir':
        print('Ouvrir casier');
        break;
      case 'informations':
        _showToolInformationDialog(context, tools[index]);
        break;
      case 'historique':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoriquePage(data: tools[index].locker.id)),
        );
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
                Text('Nom : ${toolInfo.name}'),
                Text('Casier : ${toolInfo.locker.id}'),
                Text('Durée d\'emprunt : ${toolInfo.borrow_duration}'),
                Text('Description : ${toolInfo.description}'),
                Text('Poids : ${toolInfo.weight} kg'),
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

