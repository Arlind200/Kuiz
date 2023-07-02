import 'package:Kuiz/firebase_options.dart';
import 'package:Kuiz/pages/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Kuiz/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/firebase_Functions.dart';
import 'navbar.dart';
import 'package:Kuiz/auth/forgot_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    fullname.dispose();
    password.dispose();
    nickname.dispose();


    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final fullname = TextEditingController();
  final nickname = TextEditingController();
  final password = TextEditingController();

  String nicknameError = '';

  bool nicknameUsed = true;
  bool login = true;

  void nicknameTaken(String value) async {
    value = value.trim();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: value)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        nicknameError = 'Nickname eshte ne perdorim';
      });
    } else {
      nicknameError = '';
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> signup() async {
    try {
      final UserCredential value =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      await FirestoreServices.saveUser(fullname.text, nickname.text.trim(),
          email.text.trim(), value.user?.uid);
           await FirestoreServices.savePoints(fullname.text,
          email.text.trim(), value.user?.uid, 0);
          
      await value.user!.updateDisplayName(fullname.text);
      await value.user!.updateEmail(email.text.trim());
      await value.user!.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('weak-password')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fjalëkalimi shumë i dobët!')),
        );
      } else if (e.code.contains('email-already-in-use')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Emaili ekziston në bazën e të dhënave!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signIn() async {
    try {
      // if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      //      ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text('Me heret nuk jeni verifikuar me email valide, provoni perseri!')));

      // } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      // if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      //   FirebaseAuth.instance.currentUser?.delete();
      //    ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Me heret nuk jeni verifikuar me email valide, provoni perseri!')));

      // }else{

      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuk ka përdorues me këtë email!')),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fjalëkalimi nuk përputhet!')),
        );
      }
    }
  }

  InputDecoration fieldDecoration(String hintText, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(width: 3, color: Colors.red),
      ),
      errorStyle: const TextStyle(color: Colors.black),
      prefixIcon: Icon(
        iconData,
        color: Colors.black,
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: hintText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

// bool isWeb =(DefaultFirebaseOptions.currentPlatform ==
//                             DefaultFirebaseOptions.web);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(login ? 'Kycja' : 'Regjistrimi'),
        backgroundColor: Colors.lime.shade600,
      ),
      body: Builder(builder: (BuildContext scaffoldContext) {
        return Form(
          key: _formKey,
          child: Container(
            color: Colors.lime,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 400 : 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: AssetImage('images/kompjuterike.png'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      login
                          ? Container()
                          : TextFormField(
                              key: const ValueKey('Emri'),
                              decoration: fieldDecoration(
                                  'Emri dhe Mbiemri', Icons.person),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: Colors.white,
                              validator: (emri) {
                                if (emri!.isEmpty ||
                                    !RegExp(r"^[A-Z][a-z]*(?: [A-Z][a-z]*)*$")
                                        .hasMatch(emri)) {
                                  return 'Ju lutem, shkruani emrin dhe mbiemrin! (p.sh Ali Aliu)';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  fullname.text = value!.trim();
                                });
                              },
                            ),
                      const SizedBox(height: 10),
                      login
                          ? Container()
                          : TextFormField(
                              key: const ValueKey('nickname'),
                              decoration: fieldDecoration(
                                  'Nofka', Icons.person_outline_sharp),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (nickname) {
                                if (nickname!.isEmpty || nickname.length < 5) {
                                  return 'Ju lutem, shkruani nickname me mbi 5 karaktere!';
                                }

                                nicknameTaken(nickname);
                                if (nicknameError.contains('perdorim')) {
                                  return nicknameError;
                                }

                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  nickname.text = value!;
                                });
                              },
                            ),
                      const SizedBox(height: 10),
                      TextFormField(
                        key: const ValueKey('Email'),
                        decoration: fieldDecoration('Email', Icons.mail),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                  .hasMatch(value)) {
                            return 'Ju lutem, shkruani nje email valid!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            email.text = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        key: const ValueKey('password'),
                        obscureText: true,
                        decoration:
                            fieldDecoration('Fjalkalimi', Icons.vpn_key),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password-i duhet te kete minimumi 6 karaktere!';
                          } else {
                            return null;
                          }
                       },
                        onSaved: (value) {
                          setState(() {
                            password.text = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool check_internet = await checkInternet();

                            if (check_internet) {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                if (!login) {
                                  signup();
                                } else {signIn();
                                  print('login');
                                 
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                        'Nuk keni internet, provoni me vone!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white60,
                            shadowColor: Colors.black26,
                            elevation: 1,
                          ),
                          child: Text(login ? 'Kycuni' : 'Regjistrohuni'),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                          child: Text(
                            textAlign: TextAlign.center,
                            login
                                ? "Nuk keni llogari? Regjistrohuni"
                                : "Keni llogari? Kyquni",
                            selectionColor: Colors.black,
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            setState(() {
                              _formKey.currentState?.reset();

                              login = !login;
                            });
                          }),
                      GestureDetector(
                          child: const Text(
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              'Keni harruar fjalekalimin?'),
                          onTap: () {
                            navigatorKey.currentState?.push(MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
