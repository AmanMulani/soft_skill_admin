import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/firebaseBackend/quiz_upload_bloc.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/screens/display_screen.dart';
import 'quiz_question_model.dart';


class PreviewQuiz extends StatefulWidget {


  final QuizQuestionModule quizQuestionModel;
  final String title;

  PreviewQuiz({@required this.quizQuestionModel, @required this.title});

  @override
  _PreviewQuizState createState() => _PreviewQuizState();
}

class _PreviewQuizState extends State<PreviewQuiz> with TickerProviderStateMixin{

  bool flag = true;
  @override
  Widget build(BuildContext context) {
    final collectionProvider = Provider.of<Classifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title} preview',
          style: GoogleFonts.philosopher(),
        ),
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: Material(
        child: InkWell(
          onTap: () async{
            setState(() {
              flag = false;
            });
            QuizUploadBloc questionUploadBloc = QuizUploadBloc(collection: collectionProvider.group);
            try{
              await questionUploadBloc.uploadQuiz(widget.quizQuestionModel, widget.title);
              setState(() {
                flag = true;
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Successful',
                        style: GoogleFonts.philosopher(),
                      ),
                      content: Text(
                        'Quiz Successfully Uploaded',
                        style: GoogleFonts.philosopher(),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => DisplayScreen()),
                            (route) => false
                          ),
                          child: Text('Done.'),
                        )
                      ],
                    );
                  }
              );
            }
            catch(e) {
              setState(() {
                flag = true;
                String errorCode = e.toString();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Error Signing In',
                          style: GoogleFonts.philosopher(),
                        ),
                        content: Text(errorCode),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.philosopher(),
                            ),
                          )
                        ],
                      );
                    }
                );
              });
            }

          },
          child: Container(
            width: double.infinity,
            color: Colors.redAccent,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Upload',
                textAlign: TextAlign.center,
                style: GoogleFonts.philosopher(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: flag ? ListView.builder(
          itemCount: widget.quizQuestionModel.questionList.length,
          itemBuilder: (context, index){
            String currentQuestion = widget.quizQuestionModel.questionList[index];
            int currentAnswer = widget.quizQuestionModel.answerList[index];
            int currentMarks = widget.quizQuestionModel.marksList[index];
            List<String> currentOptions = widget.quizQuestionModel.optionsList[index];

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
                        )
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
          })  :
      Center(
        child: SpinKitWave(
          color: Color(0xFF11249F),
          size: 50.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}
