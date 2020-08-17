import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/firebaseBackend/authenticate.dart';
import 'package:soft_skill_admin/firebaseBackend/user.dart';
import 'package:soft_skill_admin/firebaseBackend/user_services.dart';
import 'package:soft_skill_admin/screens/home_screen.dart';





class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin{


  final _formKey = GlobalKey<FormState>();
  final _resetPasswordKey = GlobalKey<FormState>();
  String _email;
  String _password;
  UserServices userServices = UserServices();
  bool flag = true;

  showCustomErrorDialog(BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error Signing In'),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retry'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<Authenticate>(context);
    final userProvider = Provider.of<User>(context);

    return Builder(
      builder: (context)=> Scaffold(
//        appBar: AppBar(
//          title: Text('Sign-In'),
//          backgroundColor: Colors.redAccent,
//        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF3383CD), Color(0xFF11249F),]
            )
          ),
          child: flag ? Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
//                color: Colors.white,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[

                          Text(
                            'Sign In',
                            style: GoogleFonts.pacifico(
                              color: Colors.white,
                              fontSize: 27,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          Divider(
                            color: Colors.white,
                          ),

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                              ),
                              child: TextFormField(
                                validator: (email){
                                  if(email == null) {
                                    return 'Please enter your mail id.';
                                  }
                                  return null;
                                },
                                onChanged: (email) {
                                  _email = email;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Please enter your mail id.',
                                  hintText: 'Email ID',
                                  labelStyle: GoogleFonts.lato(
                                      color: Colors.grey
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                              ),
                              child: TextFormField(
                                validator: (password){
                                  if(password == null) {
                                    return 'Please enter your mail id.';
                                  }
                                  return null;
                                },
                                onChanged: (password) {
                                  _password = password;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Please enter your password.',
                                  hintText: 'Password',
                                  labelStyle: GoogleFonts.lato(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    borderSide: BorderSide(width: 0.0, color: Colors.white),
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                          ),

                          RaisedButton(
                            child: Text(
                              'Sign-In',
                              style: GoogleFonts.lato(),
                            ),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
                            onPressed: () async{
                              try {
                                setState(() {
                                  flag = false;
                                });
                                String uid = await authProvider.signInUsingEmail(_password, _email);
                                final snapshot = await userServices.getUserByUID(uid);
                                if(snapshot!=null){
                                  userProvider.convertToUserFromSnapshot(snapshot);
                                  authProvider.addActivityToDatabase();
//                          print('In here----------------------------------------------');
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

                                }
                              } catch (e) {
                                setState(() {
                                  flag = true;
                                });
//                        print('--------------------------------------------------------');
//                        print('ERROR: ${e.code}');
                                switch(e.code){
                                  case 'ERROR_USER_NOT_FOUND' : {
                                    String code = 'User does not exist.';
                                    showCustomErrorDialog(context, code);
                                  }
                                  break;

                                  case 'ERROR_WRONG_PASSWORD' : {
                                    String code = 'Wrong Password. Please try again.';
                                    showCustomErrorDialog(context, code);
                                  }
                                  break;

                                  case 'ERROR_INVALID_EMAIL' : {
                                    String code = 'Please enter a valid email id';
                                    showCustomErrorDialog(context, code);
                                  }
                                  break;

                                  case 'ERROR_NETWORK_REQUEST_FAILED' : {
                                    String code = 'Please ensure you have a stable internet connectivity.';
                                    showCustomErrorDialog(context, code);
                                  }
                                  break;

                                  default: {
                                    String code = e.code;
                                    showCustomErrorDialog(context, code);
                                  }
                                  break;

                                }
//                        print(e.toString());
                              }
                              finally{
                                setState(() {
                                  flag = true;
                                });
                              }
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Reset Password'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Form(
                                            key: _resetPasswordKey,
                                            child: TextFormField(
                                              validator: (email){
                                                if(email == null) {
                                                  return 'Please enter your mail id.';
                                                }
                                                return null;
                                              },
                                              onChanged: (email) {
                                                _email = email;
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Please enter your mail id.',
                                                hintText: 'Email ID',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'The link to reset password will be sent on this mail id.',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        FlatButton(
                                          onPressed: () async{
                                            try {
                                              if(_resetPasswordKey.currentState.validate()) {
                                                await authProvider.resetPassword(_email);
                                              }
                                            } catch (e) {
                                              print(e.toString());
                                            }

                                          },
                                          child: Text('Confirm'),
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ) :
          Center(
              child: SpinKitWave(
                color: Colors.white,
                size: 50.0,
                controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
              )
          ),
        )
      ),
    );
  }
}
