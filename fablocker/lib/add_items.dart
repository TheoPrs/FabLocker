import 'package:flutter/material.dart';

class addItems extends StatefulWidget{
  const addItems({Key? key});
  
  @override 
  _addItems createState() =>_addItems();
}

class _addItems extends State<addItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController object_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('FabLocker'),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Ajuster le chemin de l'image
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: object_name,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'objet',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height:20.0),
              ElevatedButton(
                onPressed: () {
                  String object = object_name.text;
                  },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
