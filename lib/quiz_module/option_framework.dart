import 'package:flutter/material.dart';
import 'package:soft_skill_admin/helper/constants.dart';

class OptionFramework extends StatelessWidget {

  final optionFieldController;
  final int currentQuestionNumber;
  final int currentOptionNumber;

  OptionFramework({
    @required this.optionFieldController,
    @required this.currentQuestionNumber,
    @required this.currentOptionNumber,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            StreamBuilder<String>(
              initialData: ' ',
              stream: quizUploadBloc.optionField[currentQuestionNumber].value[currentOptionNumber].outStream,
              builder: (context, snapshot){
                return Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width  * 0.70,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      controller: optionFieldController,
                      style: TextStyle(
                        fontSize:14,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        labelText: 'Option ${currentOptionNumber+1}',
                        hintText: 'Insert a option...',
                        errorText: snapshot.error,
                      ),
                      onChanged: quizUploadBloc.optionField[currentQuestionNumber].value[currentOptionNumber].inStream,
                    ),
                  ),
                );
              },
            ),

            //TO REMOVE THE GIVEN OPTION.
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: () => quizUploadBloc.removeOptionField(currentQuestionNumber, currentOptionNumber),
            ),
          ],
        )
      ],
    );
  }
}
