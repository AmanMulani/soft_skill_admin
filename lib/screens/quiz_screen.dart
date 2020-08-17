

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/firebaseBackend/quiz_upload_bloc.dart';
import 'package:soft_skill_admin/helper/quiz_Collection_Names.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/quiz_module/quiz_upload_screen.dart';
import 'package:soft_skill_admin/quiz_module/quiz_preview.dart';
import 'package:soft_skill_admin/quiz_module/result/result_distribution_screens/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin{

  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),

      bottomNavigationBar: Material(
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> QuizUploadScreen()));
          },
          child: Container(
            width: double.infinity,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Upload Quiz',
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(classifierProvider.group)
                .document(QuizCollectionNames.mainCollectionQuizDocumentName)
                .collection(QuizCollectionNames.subCollectionQuizDocument)
                .snapshots(),
        builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return Center(
            child: SpinKitWave(
              color: Color(0xFF11249F),
              size: 50.0,
              controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
            ),
          );
        }
          var allQuiz = snapshot.data.documents;
          List<ViewQuizCard> viewCards = [];
          for( var quiz in allQuiz){
            final title = quiz['title'];
//            print(title);
            final attempts = quiz['attempts'];
            final documentID = quiz.documentID;
            viewCards.add(ViewQuizCard(title: title, documentID: documentID, attempts: attempts,));
          }
          return allQuiz.length != 0 ? SingleChildScrollView(
            child: Column(
              children: viewCards,
            ),
          ):
          Center(
            child: Text(
              'No Quiz Uploaded',
              style: GoogleFonts.lato(
                fontSize: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ViewQuizCard extends StatefulWidget {

  final String title;
  final documentID;
  final int attempts;

  ViewQuizCard({@required this.title, @required this.documentID, @required this.attempts});

  @override
  _ViewQuizCardState createState() => _ViewQuizCardState();
}

class _ViewQuizCardState extends State<ViewQuizCard> {


  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);


    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.03,)),
        ),
        elevation: 5.0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.03,)),
            gradient: LinearGradient(
              colors: [Colors.blue,Colors.deepPurpleAccent,],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.montaga(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Students Appeared: ${widget.attempts}',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Check Scores',
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            ),
                            onTap: ()  {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => QuizResultScreen(documentID: widget.documentID,)));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Preview Quiz',
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                    QuizPreview(
                                      title: widget.title,
                                      documentID: widget.documentID,
                                      group: classifierProvider.group
                                    )
                                  )
                                );
                              },
                          ),
                        ),
                      ),

                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Warning!',
                                    style: GoogleFonts.cinzel(),
                                  ),
                                  content: Text(
                                    'You are about to delete: "${widget.title}"',
                                    style: GoogleFonts.philosopher(),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.lato(),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                      QuizUploadBloc quizQuestionModule = QuizUploadBloc(collection: classifierProvider.group);
                                      try{
                                        quizQuestionModule.deleteQuiz(widget.documentID);
                                        Navigator.pop(context);
                                      }
                                      catch(e){
                                        print(e);
                                        }
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.lato(),
                                      ),
                                    )
                                  ],
                                );
                              }
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}