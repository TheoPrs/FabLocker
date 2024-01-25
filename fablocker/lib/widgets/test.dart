import 'package:flutter/material.dart';

class SingleChoiceWidget extends StatefulWidget {
  final List<String> options;

  SingleChoiceWidget({required this.options, required GlobalKey<_SingleChoiceWidgetState> key});

  @override
  _SingleChoiceWidgetState createState() => _SingleChoiceWidgetState();
}

class _SingleChoiceWidgetState extends State<SingleChoiceWidget> {
  int selectedChoice = -1;

  String get selectedOption {
    return selectedChoice != -1 ? widget.options[selectedChoice] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;

        return RadioListTile(
          title: Text(option),
          value: index,
          groupValue: selectedChoice,
          onChanged: (value) {
            setState(() {
              selectedChoice = value as int;
            });
          },
        );
      }).toList(),
    );
  }

  void printSelectedOption() {
    String selectedValue = selectedOption;
    print('Option sélectionnée : $selectedValue');
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Single Choice Example'),
      ),
      body: Center(
        child: SingleChoiceWidget(
          options: ['Option 1', 'Option 2', 'Option 3'],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create a GlobalKey to access the widget's state
          GlobalKey<_SingleChoiceWidgetState> key = GlobalKey();
          // Wrap the widget with the GlobalKey
          SingleChoiceWidget(options: ['Option 1', 'Option 2', 'Option 3'], key: key);
          // Access the state and call the method
          key.currentState?.printSelectedOption();
        },
        child: Icon(Icons.print),
      ),
    ),
  ));
}
