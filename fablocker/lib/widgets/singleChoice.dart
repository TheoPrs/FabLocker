import 'package:flutter/material.dart';

class SingleChoiceWidget extends StatefulWidget {
  final List<String> choices;

  SingleChoiceWidget({required this.choices});

  @override
  _SingleChoiceWidgetState createState() => _SingleChoiceWidgetState();

  int getSelectedChoice() {
    return _SingleChoiceWidgetState.selectedChoice;
  }
}

class _SingleChoiceWidgetState extends State<SingleChoiceWidget> {
  static int selectedChoice = -1; // -1 signifie qu'aucun choix n'est sélectionné

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.choices.length,
        (index) {
          return RadioListTile(
            title: Text(
              widget.choices[index],
              style: const TextStyle(
                color: Colors.white, // Changer la couleur du texte ici
              ),
            ),
            value: index,
            groupValue: selectedChoice,
            onChanged: (value) {
              setState(() {
                selectedChoice = value as int;
              });
            },
          );
        },
      ),
    );
  }
}
