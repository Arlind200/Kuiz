import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import './question_model.dart';
import 'package:Kuiz/pages/first_page.dart';

class DBconnect {

  HomePage home = const HomePage();
  late String quizName = home.getTitle();
 

  // Metode per marrjen e pyetjeve nga databaza
 
 Future<List<Question>> fetchQuestions() async {
  try {
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(quizName.toLowerCase());
    DatabaseEvent snapshot = await databaseReference.once();

    if (snapshot.snapshot.value != null) {
      List<Question> newquestions = [];

      Map<dynamic, dynamic> values =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        final imageUrl =
            value.containsKey('imageUrl') ? value['imageUrl'] : '';

        Question questions = Question(
          id: key,
          photo: value['photo'],
          url: imageUrl,
          title: value['title'],
          options: Map<String, bool>.from(value['options']),
          explain: value['explain'],
        );
        newquestions.add(questions);
      });
      return newquestions;
    }
  } on Exception catch (e) {
    print(e.toString());
  }
  
  return []; // Return an empty list if no questions are found
}

 }
