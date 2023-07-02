import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String name, nickname, email, uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name, 'nickname': nickname});
  }

 static savePoints(String? name,email,uid, int? points) async {
    await FirebaseFirestore.instance
        .collection('points')
        .doc(uid)
        .set({'email': email, 'points': points});
  }

}