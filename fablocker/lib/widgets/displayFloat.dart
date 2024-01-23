import 'package:flutter/material.dart';

class FloatDisplayWidget extends StatelessWidget {
  final double floatValue;

  const FloatDisplayWidget({Key? key, required this.floatValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0, // ajustez la largeur selon vos besoins
      height: 100.0, // ajustez la hauteur selon vos besoins
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '${floatValue.toStringAsFixed(2)} kg', // Ajoute "kg" à la chaîne
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}