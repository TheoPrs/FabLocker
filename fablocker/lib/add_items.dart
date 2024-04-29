// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './widgets/displayFloat.dart';
import 'package:flutter/services.dart';
import 'Style/style.dart';
import 'PrincipalePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/items.dart';
import 'class/locker.dart';

class AddItems extends StatefulWidget {
  final int idLocker;

  const AddItems({Key? key, required this.idLocker}) : super(key: key);

  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController objectNameController = TextEditingController();
  TextEditingController objectDescriptionController = TextEditingController();
  TextEditingController objectLoanDurationController = TextEditingController();
  double myValue = 999.15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('FabLocker'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment(0, -0.85),
                child: Text(
                  'Spécification de l\'objet que vous souhaitez ajouter : ',
                  style: titleStyle,
                ),
              ),
              const SizedBox(height: 40.0),
              // Nom de l'objet
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: objectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'objet',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),
              const SizedBox(height: 20.0),
              // Description de l'objet
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: objectDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description de l\'objet',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),
              const SizedBox(height: 20.0),
              // Durée de l'emprunt
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: objectLoanDurationController,
                  keyboardType: TextInputType.number, // Clavier numérique
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Durée de l\'emprunt souhaitée en jours',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 60,
                child: FloatDisplayWidget(floatValue: myValue),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String object = objectNameController.text;
                  String description = objectDescriptionController.text;
                  int borrowDuration = int.parse(objectLoanDurationController.text);
                  Locker locker = Locker(id: widget.idLocker);
                  Item item = Item(
                    name: object,
                    description: description,
                    availability: true,
                    weight: myValue,
                    borrow_duration: borrowDuration,
                    lockerId:locker,
                  );
                  Map<String, dynamic> itemData = item.toJson();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? userToken = prefs.getString('token');
                  try {
                    final response = await http.post(
                      Uri.parse('http://localhost:3000/api/items/create'),
                      body: jsonEncode(itemData),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization': 'Bearer $userToken',
                      },
                    );
                    if (response.statusCode == 201) {
                      print('Objet créé avec succès !');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrincipalePage()),
                      );
                    } else if (response.statusCode == 401) {
                      print('test');
                    } else {
                      print('Erreur lors de la création de l\'objet: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Erreur lors de la requête: $e');
                  }
                },
                child: const Text('Créer l\'objet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
