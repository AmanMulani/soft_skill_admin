import 'package:flutter/material.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'package:soft_skill_admin/quiz_module/question_upload_ui.dart';
import 'package:soft_skill_admin/quiz_module/quiz_ui_bloc.dart';

class QuizUploadScreen extends StatefulWidget {

  @override
  _QuizUploadScreenState createState() => _QuizUploadScreenState();
}

class _QuizUploadScreenState extends State<QuizUploadScreen> {

  QuizBloc quizBloc;


  @override
  void initState() {
    super.initState();
    final quizUploadBloc = QuizUIBloc();
    quizBloc = QuizBloc(quizUploadBlock: quizUploadBloc);
    quizBloc.setValue();
  }

  @override
  void dispose() {
    quizUploadBloc.dispose();
    quizBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions Upload'),
      ),
      body: QuestionUploadUI(),
    );
  }
}
