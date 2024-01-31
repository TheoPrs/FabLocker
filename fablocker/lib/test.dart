import 'package:flutter/material.dart';

class MultipleChoiceWidget extends StatefulWidget {
  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  List<bool> isCheckedList = [false, false, false]; // Pour suivre l'état de chaque choix

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Option 1'),
          value: isCheckedList[0],
          onChanged: (value) {
            setState(() {
              isCheckedList[0] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Option 2'),
          value: isCheckedList[1],
          onChanged: (value) {
            setState(() {
              isCheckedList[1] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Option 3'),
          value: isCheckedList[2],
          onChanged: (value) {
            setState(() {
              isCheckedList[2] = value!;
            });
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Multiple Choice Example'),
      ),
      body: Center(
        child: MultipleChoiceWidget(),
      ),
    ),
  ));
}
