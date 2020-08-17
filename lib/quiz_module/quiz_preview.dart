//This preview is used to display the quizzes fetched from firestore

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soft_skill_admin/firebaseBackend/quiz_upload_bloc.dart';
import 'package:soft_skill_admin/quiz_module/quiz_question_model.dart';

class QuizPreview extends StatefulWidget {

  final String title;
  final documentID;
  final String group;

  QuizPreview({@required this.group, @required this.documentID, @required this.title});

  @override
  _QuizPreviewState createState() => _QuizPreviewState();
}

class _QuizPreviewState extends State<QuizPreview> with TickerProviderStateMixin{


  QuizQuestionModule _quizQuestionModule;
  bool flag;

  @override
  void initState() {
    super.initState();
    QuizUploadBloc quizUploadBloc = QuizUploadBloc(collection: widget.group);
    print(widget.documentID);
    quizUploadBloc.getQuizData(widget.documentID).then((quizQuestionModule) {
      _quizQuestionModule = quizQuestionModule;
      setState(() {
        flag = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return flag!= null ? Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.lato(),
        ),
      ),
      body: ListView.builder(
          itemCount: _quizQuestionModule.questionList.length,
          itemBuilder: (context, index){
            String currentQuestion = _quizQuestionModule.questionList[index];
            int currentAnswer = _quizQuestionModule.answerList[index];
            int currentMarks = _quizQuestionModule.marksList[index];
            List<String> currentOptions = _quizQuestionModule.optionsList[index];

            List<Widget> _buildOptionsWidget() {
              List<Widget> options = [];
              for(int i = 0; i<currentOptions.length; i++){
                options.add(
//                    Text('${i+1}: ${currentOptions[i]}')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                            child: Icon(
                              currentAnswer-1 == i ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: currentAnswer-1 == i ? Colors.green: Colors.black,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${currentOptions[i]}',
                              style: GoogleFonts.philosopher(
                                color: currentAnswer-1 == i ? Colors.green: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }
              return options;
            }

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Question ${index + 1}',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.philosopher(),
                            ),
                            Text(
                              '${currentMarks.toString()}m',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.philosopher(
                                color: Colors.grey,
                              ),
                            ),
                          ],

                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          currentQuestion,
                          style: GoogleFonts.philosopher(),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: _buildOptionsWidget(),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Answer: $currentAnswer. ${currentOptions[currentAnswer-1]}',
                          style: GoogleFonts.philosopher(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ): Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Color(0xFF11249F),
          size: 50.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}
