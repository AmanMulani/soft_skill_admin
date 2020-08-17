import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {

  User();

  static const EMAIL = 'email';
  static const UID = 'uid';

  String _uid;
  String _email;

  String get email => _email;
  String get uid => _uid;

  set userEmail(String email) => _email = email;
  set userUID(String uid) => _uid = uid;

  void convertToUserFromSnapshot(DocumentSnapshot snapshot) {
    _uid = snapshot.data[UID];
    _email = snapshot.data[EMAIL];
  }

  Map<String, dynamic> toMap() {
    return {
      UID: _uid,
      EMAIL: _email,
    };
  }
}