import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/firebaseBackend/authenticate.dart';
import 'package:soft_skill_admin/firebaseBackend/user.dart';
import 'package:soft_skill_admin/firebaseBackend/user_services.dart';
import 'package:soft_skill_admin/helper/database_sql.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/screens/home_screen.dart';
import 'package:soft_skill_admin/screens/sign_in_screen.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Classifier>(create: (context){
            return Classifier();
          },
        ),
        ChangeNotifierProvider<User>(create: (context){
          return User();
          },
        ),
        ChangeNotifierProvider<Authenticate>(create: (context){
          return Authenticate();
          },
        )
      ],
      child: Consumer3<Classifier, User, Authenticate>(
        builder: (context, classifier, user, authenticate, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CheckStatus(),
          );
        },
      ),
    );
  }
}

class CheckStatus extends StatefulWidget {
  @override
  _CheckStatusState createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> with TickerProviderStateMixin{

  bool flag;
  DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    super.initState();

    getLoginInfoAtStart().then((value){
      print(value);
      final listOfRows = value;
      if(listOfRows.length == 0) {
        setState(() {
          flag = false;
        });
      }
      else {
        String uid = listOfRows[0][DatabaseSQL.columnName1];
        fetchUserInfo(uid).whenComplete((){
          setState(() {
            flag = true;
          });
        });
      }
    });
  }

  getLoginInfoAtStart() async {
    final db = DatabaseSQL.instance;
    final listOfRows = await db.queryAllRows();
    return listOfRows;
  }

  fetchUserInfo(String uid) async {
    UserServices userServices = UserServices();
    final snapshot = await userServices.getUserByUID(uid);
    documentSnapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<User>(context);
    if(flag==null) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage('images/dypiemrLogo.jpg'),
                height: 300,
                width: 180,
              )
            ),
            SpinKitWave(
              color: Color(0xFF11249F),
              size: 50.0,
              controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
            )
          ],
        )
      );
    }
    if(flag == true && documentSnapshot!=null) {
      userProvider.convertToUserFromSnapshot(documentSnapshot);
      print(userProvider.toMap());
    }
    return flag ? HomeScreen() : SignInScreen();
  }
}

