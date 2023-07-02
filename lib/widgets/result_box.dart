import 'package:flutter/material.dart';
import 'package:Kuiz/auth/navbar.dart';
import 'package:Kuiz/main.dart';
import 'package:Kuiz/pages/first_page.dart';
import '../constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    //required this.onPressed,
  }) : super(key: key);
  final int result;
  final int questionLength;
 // final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lime.shade700,
      content: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Rezultati',
              style: TextStyle(color: neutral, fontSize: 22.0, fontFamily: 'Raleway'),
            ),
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 70.0,
              backgroundColor: result == questionLength / 2
                  ? Colors.yellow // when the result is half of the questions
                  : result < questionLength / 2
                      ? incorrect // when the result is less than half
                      : correct,
              child: Text(
                '$result/$questionLength',
                style: const TextStyle(fontSize: 30.0),
              ), // when the result is more than half
            ),
          
            const SizedBox(height: 25.0),
           GestureDetector(
              onTap: () {
  
navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: ((context) => const NavBar())));
//navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: ((context) => const NavBar())), (route) => true);
          
            },
              child: const Text(
                'Dilni',
                style: TextStyle(

                  color: Color.fromARGB(255, 1, 42, 86),
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                  fontFamily: 'Raleway-BoldItalic'
                ),
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
