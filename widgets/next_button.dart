import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({Key? key}) : super(key: key);


//Miniaplikacioni i butonit per pyetje te radhes, ne kete klase kemi vetem stilizim,
//logjika e tij eshte e implementuar ne klasen Quiz
  @override
  Widget build(BuildContext context) {
    return Container(
      
      
     width: double.infinity,
     height: MediaQuery.of(context).size.height*0.065,
      decoration: BoxDecoration(
       color: Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: const Text(
        'Pyetja Tjeter',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, color: Colors.white),
        
      ),
    );
  }
}
