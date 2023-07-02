import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/question_model.dart'; // our question model
import '../widgets/question_widget.dart'; // the question widget
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';
import '../models/db_connect.dart';
import '../auth/navbar.dart';
import 'package:Kuiz/services/firebase_Functions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  var db = DBconnect();
  late Future _questions;
  late List<Question> question;

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  // indeksi i pyetjes
  int index = 0;
  // rezultati
  int score = 0;
  // vlere per te vertetuar se a eshte klikuar butonin
  bool isPressed = true;
  // vlere per te pare a eshte i klikuar opsioni, alternon
  // true/false nese klikohet opsioni i njejte
  bool isAlreadySelected = false;

  List<OptionCard> optionCards = [];
  // ruhen pergjigjet e sakta
  Set<bool> values = {};

  final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final String? email = FirebaseAuth.instance.currentUser?.email;
      final String? name = FirebaseAuth.instance.currentUser?.displayName;



  // pergjigjet e zgjedhura
  List<String> selectedAnswers = [];
  // pyetja e rradhes
  void nextQuestion(int questionLength) async {
    if (index == questionLength - 1) {
      // Kur numri i pyetje arrin fundin
      showDialog(
          context: context,
          barrierDismissible:
              false, // nuk mund te klikoni jashte ketij 'dialogu'
          builder: (context) => ResultBox(
                result: score, // numri i pikeve
                questionLength: questionLength, // nga te gjithat pyetjet
              ));
               await FirebaseFirestore.instance
           .collection('points')
        .doc(userId).
    update({'points' : score});

          


    } else {
      if (isPressed) {
        //kur indeksi rritet, 'rindertohet' app-i
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
          selectedAnswers.clear();
          values.clear();
        });
      }
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dilni nga kuizi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('A jeni te sigurt qe doni te dilni nga kuizi?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Jo'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: const Text('Po'),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const NavBar();
                }));
              },
            ),
          ],
        );
      },
    );
  }

  void highlight(String answer) {
    if (selectedAnswers.contains(answer)) {
      setState(() {
        selectedAnswers.remove(answer);
      });
    } else {
      setState(() {
        selectedAnswers.add(answer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData ) {
            question = snapshot.data as List<Question>;

            print('sdssdsdsd');

            return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Scaffold(
                  backgroundColor: Colors.lime,

                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.lime.shade700,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed:
                          _showAlertDialog /* Navigator.pop(context,true); */
                    ),              
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Piket: $score',
                          style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),

                  body: Container(
                    height: MediaQuery.of(context).size.height * 0.795,
                    padding: (kIsWeb)
                        ? const EdgeInsets.symmetric(horizontal: 300)
                        : const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      // height: 800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //  mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 15),
                          // add the questionWIdget here
                          QuestionWidget(
                            indexAction: index, // fillimisht ne 0
                            question:
                                question[index].title, // pyetja e pare ne liste
                            totalQuestions: question.length,
                            url: question[index].url,
                            photo: question[index].photo,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  for (int i = 0;
                                      i < question[index].options.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          highlight(question[index]
                                              .options
                                              .keys
                                              .toList()[i]);
                                        },
                                        child: OptionCard(
                                          option: question[index]
                                              .options
                                              .keys
                                              .toList()[i],
                                          isselected: selectedAnswers.contains(
                                              question[index]
                                                  .options
                                                  .keys
                                                  .toList()[i]),
                                        ),
                                      ),
                                    ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),

                  // use the floating action button
                  floatingActionButton: GestureDetector(
                    //onTap: () => nextQuestion(question.length),
                    onTap: () {
                      // question[index].options.values.toList()[i])

                      for (int i = 0; i < question[index].options.length; i++) {
                        for (int j = 0; j < selectedAnswers.length; j++) {
                          if (question[index]
                              .options
                              .keys
                              .toList()[i]
                              .toString()
                              .contains(selectedAnswers.elementAt(j))) {
                            values.add(
                                question[index].options.values.toList()[i]);
                          }
                        }
                      }

                      if (!values.contains(false) && values.isNotEmpty) {
                        correctAnswer(context);
                        setState(() {
                          isPressed = true;
                          score++;
                        });
                        nextQuestion(question.length);
                      } else {
                        incorrectAnswer(context);

                        setState(() {
                          isPressed = true;
                        });

                        nextQuestion(question.length);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: NextButton(// the above function
                          ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ));
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.lime,
                  backgroundColor: Colors.black,
                ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Nuk ka te dhena!'),
        );
      },
    );
  }

  void correctAnswer(BuildContext correctctx) {
    showDialog(
        barrierDismissible: true,
        context: correctctx,
        builder: (correctctx) {
          return AlertDialog(
            scrollable: true,
            content: Text(
              question[index-1].explain,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.lime,
            title: const Text("SAKTE", textAlign: TextAlign.center),
            alignment: Alignment.center,
            titleTextStyle: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black),
          );
        });
  }

  void incorrectAnswer(BuildContext incorrectctx) {
    showDialog(
        barrierDismissible: true,
        context: incorrectctx,
        builder: (incorrectctx) {
          return AlertDialog(
            content: Text(question[index-1].explain, textAlign: TextAlign.center),
            backgroundColor: const Color.fromARGB(255, 171, 63, 63),
            title: const Text("PASAKTE", textAlign: TextAlign.center),
            alignment: Alignment.center,
            titleTextStyle: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black),
          );
        });
  }
}
