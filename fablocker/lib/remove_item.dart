// ignore_for_file: camel_case_types, use_build_context_synchronously, use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'dart:convert';
import 'package:fablocker/PrincipalePage.dart';
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
  for (var lock in data) {
    if (lock['item'] != null ){
      parsedData.add(Locker(
        id : lock["id"]
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
        automaticallyImplyLeading: false,
        title: const Text('Ici vous retrouverez tous les casiers utilisés !'),
        actions:[
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrincipalePage()),
          );
        }
    ),
    const SizedBox(width: 740.0),
  ],
      ),
      body: isLoading
          ? const Center(
            child: CircularProgressIndicator(), // Garder le CircularProgress ici
          )
          : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 30.0,
              mainAxisSpacing: 30.0,
              childAspectRatio: 1,
            ),
            itemCount: locks.length,
            itemBuilder: (context, index) {
              if (index < locks.length) {
                final GlobalKey itemKey = GlobalKey();

                return InkWell(
                  key: itemKey,
                  onTap: () => _showCasierOptions(context, index, itemKey, isAdmin),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
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
                            'Casier id : ${locks[index].id}',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
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
        value: 'Vider ce casier',
        child: Text('Vider'),
      ),
    ];

    final selection = await showMenu(
      context: context,
      position: position,
      items: menuItems,
    );

    switch(selection){
      case 'Vider ce casier':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrincipalePage()),
        );
        break;
    }
  }
}
