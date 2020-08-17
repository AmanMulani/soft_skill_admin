import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'package:soft_skill_admin/quiz_module/preview_quiz.dart';
import 'package:soft_skill_admin/quiz_module/question_framework.dart';


class QuestionUploadUI extends StatelessWidget {

  final questionFieldController = List<TextEditingController>();
  final answerFieldController = List<TextEditingController>();
  final marksFieldController = List<TextEditingController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    String _title;

    List<Widget> _buildFields(int length) {
      questionFieldController.clear();
      answerFieldController.clear();
      marksFieldController.clear();

      for(int i = 0; i<length; i++) {
        final question = quizUploadBloc.questionField.value[i].value;
        final answer = quizUploadBloc.ansField.value[i].value;
        final marks = quizUploadBloc.marksField.value[i].value;

        questionFieldController.add(TextEditingController(text: question));
        answerFieldController.add(TextEditingController(text: answer));
        marksFieldController.add(TextEditingController(text: marks));

      }

      return List.generate(
        length,
        (index) => QuestionFramework(
          index: index,
          questionFieldController: questionFieldController[index],
          answerFieldController: answerFieldController[index],
          marksFieldController: marksFieldController[index],
        ),
      );
    }

    Future _customDialog() {
      final quizQuestionModel = quizUploadBloc.submit();
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (title){
                  if(title == null) {
                    return 'Please enter your mail id.';
                  }
                  return null;
                },
                onChanged: (title) {
                  _title = title;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Please enter a title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Cancel'),
                onPressed: ()=> Navigator.pop(context),
              ),
              RaisedButton(
                child: Text('Proceed'),
                onPressed: (){
                  if(_formKey.currentState.validate()) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviewQuiz(quizQuestionModel: quizQuestionModel, title: _title,)));
                  }
                },
              ),
            ],
          );
        }
      );
    }



    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueBuilder<List<StreamedValue<String>>>(
            streamed: quizUploadBloc.questionField,
            builder: (context, snapshot) {
              return Column(
                children: _buildFields(snapshot.data.length),
              );
            },
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Add Question',
                style: GoogleFonts.philosopher(),
              ),
              onPressed: (){
                quizUploadBloc.addQuestionField();
                quizUploadBloc.addAnswerField();
                quizUploadBloc.addMarksField();
                quizUploadBloc.addOptionsStreamToList();
              },
            ),

            StreamBuilder<bool>(
              stream: quizUploadBloc.isFormValid.outStream,
              builder: (context, snapshot){
                return RaisedButton(
                  child: snapshot.hasData ?
                    snapshot.data ?  Text('Upload Quiz', style: GoogleFonts.philosopher(),) : Text('Invalid', style: GoogleFonts.philosopher(),)
                  : Text('No data', style: GoogleFonts.philosopher(),),
                  onPressed: snapshot.hasData ? ()=> _customDialog() : null,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
