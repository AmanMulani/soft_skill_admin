import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{

  static String collection = 'admin';

  Firestore _firestore = Firestore.instance;


  /*
  When the user has been authenticated using email and password,
  the user uid is then stored in firestore database.
   */
  createUser(Map<String, dynamic> values) async {

    String uid = values['uid'];
    await _firestore.collection(collection).document(uid).setData(values);

  }

  /*
  After the launch of application, the applications checks whether a UID is
  available in the internal SQLite Database.
  If available, then this method is used to fetch the information of that user
  from firestore using the UID from SQLite database.
  For this app, we have already created a user using email ID and password on
  firebase console. The UID of that user is used to create a document in the
  collection "admin".
  */
  Future<DocumentSnapshot> getUserByUID(String uid) =>
      _firestore.collection(collection).document(uid).get().then((snapshot){
        if(snapshot.data == null){
          return null;
        }
        return snapshot;
      });
}