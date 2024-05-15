// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'class/locker.dart';
import 'class/toolInfos.dart';
import 'PrincipalePage.dart';

List<ToolInfo> tools = [];

List<ToolInfo> parseData(String jsonData) {
  final List<dynamic> data = json.decode(jsonData);
  List<ToolInfo> parsedData = [];
  for (var item in data) {
    if(item['availability'] == true) {
          parsedData.add(ToolInfo(
            locker: Locker.fromJson(item['locker']),
            availability: item['availability'],
            weight: item['weight'],
            name: item['name'],
            borrow_duration: item['borrow_duration'],
            description: item['description'],
            itemId: item['id'], 
    ));
    }

  }
  return parsedData;
}

class removeItems extends StatefulWidget {
  const removeItems({Key? key}) : super(key: key);

  @override
  _removeItemsState createState() => _removeItemsState();
}

class _removeItemsState extends State<removeItems> {
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
      final response = await http.get(Uri.parse('http://localhost:3000/api/items'), headers: headers);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Page d\'accueil'),
        actions:[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrincipalePage()),
              );
            }
          ),
          const SizedBox(width: 1050.0),
        ],
      ),
      body: isLoading
          ? const Center(
            child: CircularProgressIndicator(), 
          )
          : GridView.builder(
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
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: tools[index].availability ? Colors.green : Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(1),
                        blurRadius: 15,
                        blurStyle: BlurStyle.outer, 
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Casier : ${tools[index].locker.id}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Outil : ${tools[index].name}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'État : $textAvailability',
                          style: const TextStyle(
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
        value: 'Supprimer',
        child: Text('Supprimer'),
      ),
    ];

    final selection = await showMenu(
      context: context,
      position: position,
      items: menuItems,
    );

    int? idItem = tools[index].itemId; 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $userToken',
    };

    switch (selection) {
      case 'Supprimer':
        try {
          final response = await http.delete(
            Uri.parse('http://localhost:3000/api/items/$idItem'), 
            headers: headers
          );
          print(response.request);
          if (response.statusCode == 200) {
            print('Objet supprimé avec succès !');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrincipalePage()),
            );
          } else {
            print('Erreur lors de la supppression de l\'item: ${response.statusCode}');
          }
        } catch (e) {
          print('Erreur lors de la requête: $e');
        }
        break;
      default:
    }
  }
}
