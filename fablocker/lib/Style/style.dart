import 'package:flutter/material.dart';

const Color greenPastel =
    Color.fromARGB(235, 144, 238, 144); // vert pastel, plus opaque
const Color redPastel =
    Color.fromARGB(235, 255, 160, 122); // rouge pastel, plus opaque
const Color grayPastel =
    Color.fromARGB(235, 217, 218, 219); // gris pastel, complètement opaque


// Styles de texte
const TextStyle titleStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 28.0,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

const TextStyle inputDecorationStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 17.0,
  color: Colors.black,
);

const TextStyle inputStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 17.0,
  color: Colors.black,
);

const TextStyle basicText = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 20,
  color: Colors.black,
);

const TextStyle boldText = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

// Fonction pour obtenir la couleur de fond en fonction de la disponibilité
Color getBackgroundColor(bool availability) {
  return availability ? greenPastel : redPastel;
}

// Fonction pour obtenir une décoration de conteneur
BoxDecoration getToolContainerDecoration(bool availability) {
  return BoxDecoration(
    color: getBackgroundColor(availability),
    border: Border.all(
      color: availability ? Colors.green : Colors.red,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(1),
        blurRadius: 0.001,
        blurStyle: BlurStyle.outer,
      ),
    ],
  );
}

BoxDecoration getCasierHeaderDecoration() {
  return BoxDecoration(
    color: Color(0xFFA8A8A8), // Définit la couleur de fond
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10), // Arrondit les coins en haut à gauche
      topRight: Radius.circular(10), // Arrondit les coins en haut à droite
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 2,
        offset: const Offset(0, 1), // changes position of shadow
      ),
    ],
  );
}

// Style pour les boutons d'ajout
final ButtonStyle addButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue, // Couleur de fond
  foregroundColor: Colors.white, // Couleur du texte
);
