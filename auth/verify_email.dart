import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Kuiz/pages/navbar.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool emailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!emailVerified) {
      sendEmailVerification();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void deleteUnverified() async {
    FirebaseAuth.instance.currentUser?.reload();
    if (emailVerified == false) {
      print('ketu');
      print(FirebaseAuth.instance.currentUser.toString());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('points')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
      await FirebaseAuth.instance.currentUser?.delete();
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (emailVerified) {
      timer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Regjistrimi u krye me sukses!')),
      );
    }
  }

  Future sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return emailVerified
        ? const NavBar()
        : Scaffold(
            backgroundColor: Colors.lime,
            appBar: AppBar(
              title: const Text('Verifikimi i Email'),
              backgroundColor: Colors.lime.shade700,
            ),
            body: Column(children: [
              const Center(
                  child: Text(
                'Nje link verifikimi eshte derguar ne kete email, ju nuk mund te keni qasje ne aplikacion pa u verifikuar!',
                style: TextStyle(fontFamily: 'Raleway', fontSize: 20),
              )),
              TextButton(
                  onPressed: () async {
                   FirebaseAuth.instance.signOut();

                  },
                  child: const Text('Kthehu'))
            ]));
  }
}
