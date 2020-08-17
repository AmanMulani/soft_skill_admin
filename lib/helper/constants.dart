
import 'package:soft_skill_admin/quiz_module/quiz_ui_bloc.dart';

final String firstYear = 'First Year';
final String secondYear = 'Second Year';
final String thirdYear = 'Third Year';
final String fourthYear = 'Fourth Year';
final String teachersAndFaculties = 'Teachers And Faculties';
QuizUIBloc quizUploadBloc;


/*
This class is made to make sure that each time the admin wants to upload a quiz,
a new QuizUploadBloc object is initialized and the previous object is disposed
safely, thus avoiding closed event state error.
*/
class QuizBloc{

  final quizUploadBlock;
  QuizBloc({this.quizUploadBlock});

  void setValue() {
    quizUploadBloc = quizUploadBlock;
  }

  void dispose() {
    quizUploadBloc = null;
  }
}