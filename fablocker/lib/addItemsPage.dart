import 'dart:convert';
import 'package:fablocker/add_items.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'class/locker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connexionPage.dart';

List<Locker> locks = [];

List<Locker> parseData(String jsonData) {
  final List<dynamic> data = json.decode(jsonData);
  List<Locker> parsedData = [];
  for (var item in data) {
    if (item['item'] == null ){
      parsedData.add(Locker(
        id : item["id"]
      ));
    }
  }
  return parsedData;
}


class addItemsPage extends StatefulWidget {
  addItemsPage({Key? key}) : super(key: key);

  @override
  _addItemsPageState createState() => _addItemsPageState();
}

class _addItemsPageState extends State<addItemsPage> {
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
    if (userToken != null) {
      Map<String, dynamic> payload = Jwt.parseJwt(userToken);
      if (payload['role'] == 'admin') {
        setState(() {
          isAdmin = true;  
        });
      } else {
        setState(() {
          isAdmin = false; 
        });
      }
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $userToken',
      };
      final response = await http.get(Uri.parse('http://localhost:3000/api/lockers'), headers: headers);
      if (response.statusCode == 200) {
        final jsonData = response.body;
        setState(() {
          locks = parseData(jsonData);
          locks.sort((a, b) => a.id.compareTo(b.id));
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
      appBar: AppBar(
        title: const Text('Ici vous retrouverez tous les casiers vides !'),
        actions:[
    if (isAdmin) ...[
      SizedBox(width: 250.0),
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
                
                try{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? userToken = prefs.getString('token');
                  final response = await http.post(
                        Uri.parse('http://localhost:3000/api/lockers/add'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization' : 'Bearer $userToken',
                        },
                      );
                      if (response.statusCode == 201) {
                        print('Objet créé avec succès !');
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addItemsPage()),
                        );
                      } else{
                        print("Erreur");
                      }
                }catch(e){
                  print('Erreur lors de la requête: $e');
                }
                
              },
            ),
          ],
        );
      },
    );
  },
),
    ],
    SizedBox(width: 250.0),
    IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () async {
        // Supprimer les informations de connexion enregistrées
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => connexionPage()),
                );
      },
    ),
    SizedBox(width: 150.0),
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
              ),
            )
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
                itemCount: locks.length,
                itemBuilder: (context, index) {
                  final GlobalKey itemKey = GlobalKey();
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
                              'Casier : ${locks[index].id}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Disponible',
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

  void _showCasierOptions(BuildContext context, int index, GlobalKey key, bool isAdmin) async {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx,
      offset.dy,
    );

    List<PopupMenuEntry<String>> menuItems = [
      const PopupMenuItem(
        value: 'Choisir ce casier',
        child: Text('Choisir'),
      ),
    ];

    final selection = await showMenu(
      context: context,
      position: position,
      items: menuItems,
    );

    switch(selection){
      case 'Choisir ce casier':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddItems(idLocker : locks[index].id)),
        );
        break;
    }
  }
}
