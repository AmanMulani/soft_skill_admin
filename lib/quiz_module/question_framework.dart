import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'package:soft_skill_admin/quiz_module/option_framework.dart';

class QuestionFramework extends StatelessWidget {

  final int index;
  final questionFieldController;
  final answerFieldController;
  final marksFieldController;

  QuestionFramework({
    @required this.index,
    @required this.questionFieldController,
    @required this.answerFieldController,
    @required this.marksFieldController,
  });


  final optionFieldController = List<TextEditingController>();

  List<Widget> _buildOptions(int length) {

    optionFieldController.clear();
    for(int i = 0; i < length; i++) {
      final option = quizUploadBloc.optionField[index].value[i].value;
      optionFieldController.add(TextEditingController(text: option));
    }

    return List.generate(
      length,
      (index) => OptionFramework(
        currentQuestionNumber: this.index,
        currentOptionNumber: index,
        optionFieldController: optionFieldController[index],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Question ${index+1}: ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[

                      /*----------------------------------------------------------------------------*/
                      //TO INSERT THE QUESTION.
                      StreamBuilder<String>(
                        stream: quizUploadBloc.questionField.value[index].outStream,
                        initialData: ' ',
                        builder: (context, snapshot) {
                          return Column(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height * 0.10,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextField(
                                    controller: questionFieldController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    minLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                      labelText: 'Question',
                                      hintText: 'Insert a question...',
                                      errorText: snapshot.error,
                                    ),
                                    onChanged: quizUploadBloc.questionField.value[index].inStream,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      /*----------------------------------------------------------------------------*/
                      //TO INSERT THE NUMBER OF MARKS OF THAT QUESTION.
                      StreamBuilder<String>(
                        initialData: ' ',
                        stream: quizUploadBloc.marksField.value[index].outStream,
                        builder: (context, snapshot) {
                          return Container(
//                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: marksFieldController,
                                decoration: InputDecoration(
                                  labelText: 'Marks',
                                  hintText: 'Please enter the marks.',
                                  errorText: snapshot.error,
                                ),
                                onChanged: quizUploadBloc.marksField.value[index].inStream,
                              ),
                            ),
                          );
                        },
                      ),

                      /*----------------------------------------------------------------------------*/
                      //TO INSERT THE CORRECT ANSWER
                      StreamBuilder<String>(
                        stream: quizUploadBloc.ansField.value[index].outStream,
                        initialData: ' ',
                        builder: (context, snapshot) {
                          return Container(
//                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                controller: answerFieldController,
                                decoration: InputDecoration(
                                  labelText: 'Answer',
                                  hintText: 'Please enter the correct option.',
                                  errorText: snapshot.error,
                                ),
                                onChanged: quizUploadBloc.ansField.value[index].inStream,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),


                Column(
                  children: <Widget>[

                    //TO DELETE A COMPLETE QUESTION FIELD AND ITS OPTIONS, ANSWERS AND MARKS.
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => quizUploadBloc.removeField(index),
                    ),

                    //TO ADD OPTIONS TO THE GIVEN QUESTION.
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      color: Colors.green,
                      onPressed: (){
                        quizUploadBloc.addOneOption(this.index);
                      },
                    ),
                  ],
                ),
              ],
            ),

            /*----------------------------------------------------------------------------*/
            //TO DISPLAY THE OPTIONS.
            ValueBuilder<List<StreamedValue<String>>>(
              streamed: quizUploadBloc.optionField[index],
              builder: (context, snapshot){
                return Column(
                  children: _buildOptions(snapshot.data.length),
                );
              },
              noDataChild: Text('NO DATA'),
            ),
          ],
        ),
      ),
    );
  }
}
