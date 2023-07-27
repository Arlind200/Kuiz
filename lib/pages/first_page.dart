// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Kuiz/main.dart';
import 'package:Kuiz/pages/quiz.dart';
import 'package:Kuiz/auth/login.dart';

String quizTitle = '';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

//meret titulli i kuizit
  String getTitle() {
    return quizTitle;
  }

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
  }

  // versioni i ardhshem
  // void _isClickable(DateTime now) {
  //   final start = DateTime(now.year, now.month, now.day, now.hour, 0);
  //   final end = DateTime(now.year, now.month, now.day, now.hour, 59);
  //   setState(() {
  //     available = now.isAfter(start) && now.isBefore(end);
  //   });
  // }

  Widget buildClickableRectangularObject(
      String title, String subTitle, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        quizTitle = '';
        hasInternet = await const LoginForm().checkInternet();
        quizTitle = title;
        if (hasInternet) {
          navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
              builder: ((context) => Quiz(
                    key: Key(quizTitle),
                  ))));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(seconds: 2),
                content: Text(
                    'Nuk keni internet ose nje gabim tjeter ka ndodhur, provoni me vone!')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.black54,
            //hasInternet ? purple : Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Colors.black)),
        child: Row(
          children: [
            // margjine per foto
            const SizedBox(height: 10, width: 10),
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    style: const TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lime.shade700,
          title: const Text('Dilni nga kuizi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A jeni te sigurt qe doni shkyqeni?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  }
                  return Colors.lime;
                }),
              ),
              child: const Text('Jo'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  }
                  return Colors.lime;
                }),
              ),
              child: const Text('Po'),
              onPressed: () {
                logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginForm()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Kuizi'),
        backgroundColor: Colors.lime.shade700,
        actions: [
          IconButton(
              onPressed: () async {
                _showAlertDialog();
              },
              icon: const Icon(Icons.logout_sharp)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lime, Color.fromARGB(255, 255, 255, 255)])),
        child: Center(
          child: AspectRatio(
            aspectRatio: kIsWeb ? 10 / 9 : 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Shkence kompjuterike',
                    'Testoni njohurite tuaja ne fushen e Sh.K',
                    'images/kompjuterike.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Kimi',
                    'Testoni njohurite tuaja ne fushen e Kimise',
                    'images/kimi.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Fizike',
                    'Testoni njohurite tuaja ne fushen e Fizikes',
                    'images/fizike.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Gjeografi',
                    'Testoni njohurite tuaja ne fushen e Gjeografise',
                    'images/gjeografi.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Biologji',
                    'Testoni njohurite tuaja ne fushen e Biologjise',
                    'images/biologji.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Matematike',
                    'Testoni njohurite tuaja ne fushen e Matematikes',
                    'images/matematike.png',
                    context,
                  ),
                  const SizedBox(height: 20),
                  buildClickableRectangularObject(
                    'Matematike Financiare',
                    'Testoni njohurite tuaja ne fushen e M.F',
                    'images/financa.png',
                    context,
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
