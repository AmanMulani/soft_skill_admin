import 'package:flutter/foundation.dart';


///the object of this class will contain all tbe quiz data.
class QuizQuestionModule {

  final List<String> questionList;
  final List<List<String>> optionsList;
  final List<int> answerList;
  final List<int> marksList;
  QuizQuestionModule({
    @required this.optionsList,
    @required this.questionList,
    @required this.answerList,
    @required this.marksList
  });

  ///to convert the List of List to a list of maps to upload it on firestore.
  List<Map<String, String>> convertOptionsToMap() {
    List<Map<String, String>> totalList = [];
    for(int i = 0; i<optionsList.length; i++) {
      Map<String, String> tempOptions = {};
      tempOptions = Map.fromIterable(
          optionsList[i],
          key: (option)=> optionsList[i].indexOf(option).toString(),
          value: (option)=>option
      );
      totalList.add(tempOptions);
    }
    return totalList;
  }

  void display() {
    int length = questionList.length;
    for(int i = 0; i<length; i++) {
      print('Marks: ${marksList[i]}');
      print('Question ${i+1}: ${questionList[i]}');
      for(int j=0; j<optionsList[i].length; j++) {
        print('Option ${j+1}: ${optionsList[i][j]}');
      }
      print('Correct Answer: ${answerList[i]}');

    }
  }

}