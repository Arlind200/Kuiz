import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({Key? key, required this.option, required this.isselected})
      : super(key: key);

  final String option;
  final bool isselected;

//Miniaplikacioni i nje opsioni, me pas thirret aq here sa ka opsione ne nje pyetje, ne rastin tone 4 here.
  @override
  Widget build(BuildContext context) {
    final color = isselected ? Colors.blueGrey : Colors.lime;

    return ListTile(
      
      tileColor: color,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.lime.shade900),
        borderRadius: BorderRadius.circular(50),
      ),
      title: Text(
        option,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0, fontFamily: 'Raleway'),
      ),
    );
  }
}
