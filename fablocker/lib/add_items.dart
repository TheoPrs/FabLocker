import 'package:flutter/material.dart';
import './widgets/displayFloat.dart';
import 'package:flutter/services.dart';
import './widgets/singleChoice.dart';
import 'Style/style.dart';

class addItems extends StatefulWidget{
  const addItems({Key? key});
  
  @override 
  _addItems createState() =>_addItems();
}

class _addItems extends State<addItems> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController object_name = TextEditingController();
  TextEditingController object_description = TextEditingController();
  TextEditingController object_loan_duration = TextEditingController();
  double myValue = 999.15;
  var typeDeCasier = ['Petit casier', 'Casier moyen', 'Grand casier'];
  

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


              //Nom de l'objet
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: object_name,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'objet',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),


              const SizedBox(height:20.0),


              //Decription de l'objet
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: object_description,
                  decoration: const InputDecoration(
                    labelText: 'Description de l\'objet',
                    labelStyle: inputDecorationStyle,
                    border: OutlineInputBorder(),
                  ),
                  style: inputStyle,
                ),
              ),


              const SizedBox(height: 20.0),
              
              
              //Durée de l'emprunt
              SizedBox(
                height: 50,
                width: 440,
                child: TextField(
                  controller: object_loan_duration,
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
              
              
              const SizedBox(height:20.0),
              
              
              SizedBox(
                height: 60,
                child: FloatDisplayWidget(floatValue: myValue),
              ),
              
              
              const SizedBox(height:20.0),
              
              
              //Choix multiple
              SizedBox(
                width: 400,
                height: 50*typeDeCasier.length.toDouble(),
                child: SingleChoiceWidget(choices: typeDeCasier)),
              
              
              const SizedBox(height:20.0),
              
              
              //Bouton "Créer l'objet"
              ElevatedButton(
                onPressed: () {
                  //METHODE POST 
                  
                  //int selectedValue = SingleChoiceWidget.getSelectedChoice();
                  String object = object_name.text;
                  String description = object_description.text;
                  int loan_duration = int.parse(object_loan_duration.text);
                  
                  if (object.isEmpty | description.isEmpty | loan_duration.isNaN){
                      //print(selectedValue);
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
