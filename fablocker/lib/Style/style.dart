// lib/styles.dart
import 'package:flutter/material.dart';

// Couleurs personnalisées pour la disponibilité
const Color greenPastel = Color.fromARGB(127, 144, 238, 144); // vert pastel
const Color redPastel = Color.fromARGB(127, 255, 160, 122); // rouge pastel

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
        blurRadius: 15,
        blurStyle: BlurStyle.outer,
      ),
    ],
  );
}

// Style pour les boutons d'ajout
final ButtonStyle addButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue, // Couleur de fond
  foregroundColor: Colors.white, // Couleur du texte
);
