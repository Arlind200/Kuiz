import 'package:Kuiz/auth/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Kuiz/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/firebase_Functions.dart';
import 'package:Kuiz/auth/forgot_password.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

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
  String emailError='';

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
      setState(() {
        nicknameError = '';
      });
    }
  }
    void checkIfEmailExists(String email) async {

      final snapshot = await FirebaseFirestore.instance
          .collection('users') 
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
      setState(() {
        emailError = 'Email eshte ne perdorim';
      });
    } else {
      setState(() {
        emailError = '';
      });
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
      await FirestoreServices.savePoints(
          fullname.text, email.text.trim(), value.user?.uid, 0);

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );
      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const VerifyEmail()));
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
    } catch (e) {
      e.toString();
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
      errorStyle: const TextStyle(color: Colors.black, fontSize: 10),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.lime,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          login ? 'Kycja' : 'Regjistrimi',
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.lime.shade600,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: AspectRatio(
            aspectRatio: kIsWeb ? 9 / 16 : 0.5,
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kIsWeb ? 300 : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: 190,
                      height: 190,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: AssetImage('images/logo_login.png'),
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
                    login ? Container() : const SizedBox(height: 10),
                    login
                        ? Container()
                        : TextFormField(
                            key: const ValueKey('nickname'),
                            decoration: fieldDecoration(
                                'Nofka', Icons.person_outline_sharp),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.white,
                            validator: (nickname) {
                              if (nickname!.isEmpty ||
                                  nickname.length < 5 ||
                                  nickname.length > 15) {
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
                      cursorColor: Colors.white,
                      validator: (value) {
                        
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                .hasMatch(value) ){
                          return 'Ju lutem, shkruani nje email valid!';
                        } 
                         checkIfEmailExists(value);

                              if (emailError.contains('perdorim') && !login) {
                                return emailError;
                              }
                        
                          return null;
                        
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
                      decoration: fieldDecoration('Fjalkalimi', Icons.vpn_key),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: Colors.white,
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
                          bool hasInternet =
                              await const LoginForm().checkInternet();

                          if (hasInternet) {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate() ) {
                              _formKey.currentState!.save();

                              if (!login) {
                                signup();
                              } else {
                                signIn();
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
                    const SizedBox(height: 10),
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
      ),
    );
  }
}
