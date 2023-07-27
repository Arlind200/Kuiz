import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:Kuiz/models/question_model.dart';
import 'package:Kuiz/pages/first_page.dart';

class DBconnect {
  HomePage home = const HomePage();
  late String quizName = home.getTitle();

  // Metode per marrjen e pyetjeve nga databaza

  Future<List<Question>> fetchQuestions() async {
    try {
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child(quizName.toLowerCase());
      DatabaseEvent event = await databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        List<Question> newquestions = [];

        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
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
        print(event);
        return newquestions;
      }
    } on Exception catch (e) {
      e.toString();
    }

    return []; // Kthehet nje varg i zbrazet
  }
}
