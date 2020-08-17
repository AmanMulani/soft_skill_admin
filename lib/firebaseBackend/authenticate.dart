import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:soft_skill_admin/helper/database_sql.dart';

class Authenticate extends ChangeNotifier {

  FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = DatabaseSQL.instance;
  String uid;
  dynamic user;

  FirebaseAuth get auth => _auth;

  signInUsingEmail(String password, String emailID) async {
    try{
      final user = await _auth.signInWithEmailAndPassword(
        email: emailID,
        password: password,
      );

      this.user = user;
      return user.user.uid;
    } catch(e) {
      throw e;
    }
  }

  addActivityToDatabase() async {
    Map<String, dynamic> row = {
      DatabaseSQL.columnName: 1,
      DatabaseSQL.columnName1: user.user.uid,
    };
    int i = await _db.insert(row);
    print('Successfully Inserted: $i');
  }


  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _db.delete(1);
  }

}