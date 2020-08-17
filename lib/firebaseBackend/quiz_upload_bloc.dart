import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:soft_skill_admin/quiz_module/quiz_question_model.dart';
import 'package:soft_skill_admin/helper/quiz_Collection_Names.dart';
import 'package:soft_skill_admin/helper/constants.dart';

class QuizUploadBloc {

  final String collection;

  QuizUploadBloc({@required this.collection});



  Firestore _firestore = Firestore.instance;

  uploadQuiz(QuizQuestionModule quizQuestionModule, String title) async{

    print('------------------------$title');
    try {
      DocumentReference documentReference = _firestore.collection(collection)
          .document(QuizCollectionNames.mainCollectionQuizDocumentName)
          .collection(QuizCollectionNames.subCollectionQuizDocument)
          .document();

      await documentReference.setData({
        QuizCollectionNames.titleField: title,
        QuizCollectionNames.resultDocumentAttemptField: 0,
      });


      await documentReference.collection(QuizCollectionNames.subSubCollection).document(documentReference.documentID).setData(
        {
          QuizCollectionNames.questionField: quizQuestionModule.questionList,
          QuizCollectionNames.answerField: quizQuestionModule.answerList,
          QuizCollectionNames.marksField: quizQuestionModule.marksList,
          QuizCollectionNames.optionsField: quizQuestionModule.convertOptionsToMap(),
        }
      );

      //These if else statements are used to create the collection/documents to store
      //the results.
      String computer = 'Computer';
      String mechanical = 'Mechanical';
      String civil = 'Civil';
      String chemical = 'Chemical';
      String entc = 'ENTC';
      String division = 'division';

      Map<String, String> demoStudentsMap =
        {
          'name': 'Demo',
          'rollNumber': '10000',
          'marks': '100',
        };

      Map<String, String> demoTeachersMap =
        {
          'name': 'Demo',
          'marks': '100',
        };

      if(collection == firstYear) {
        print('----------------------------------------');

        final firstYearDivisionCollectionReference = documentReference.collection(QuizCollectionNames.subSubCollectionResult);


        firstYearDivisionCollectionReference.document('A').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('B').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('C').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('D').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('E').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('F').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('G').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('H').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('I').setData({'demo1': demoStudentsMap});
        firstYearDivisionCollectionReference.document('J').setData({'demo1': demoStudentsMap});

      }
      else if(collection == teachersAndFaculties){

        final teacherDepartmentCollectionReference = documentReference.collection(QuizCollectionNames.subSubCollectionResult);

        teacherDepartmentCollectionReference.document(computer).setData({'demo1': demoTeachersMap});
        teacherDepartmentCollectionReference.document(mechanical).setData({'demo1': demoTeachersMap});
        teacherDepartmentCollectionReference.document(civil).setData({'demo1': demoTeachersMap});
        teacherDepartmentCollectionReference.document(chemical).setData({'demo1': demoTeachersMap});
        teacherDepartmentCollectionReference.document(entc).setData({'demo1': demoTeachersMap});
      }

      else {
        final computerDepartmentDocumentReference = documentReference
            .collection(QuizCollectionNames.subSubCollectionResult)
            .document(computer);

        computerDepartmentDocumentReference.setData({'demo': 'demo'});

        final computerDepartmentCollectionDivision = computerDepartmentDocumentReference.collection(division);
        computerDepartmentCollectionDivision.document('A').setData({'demo1': demoStudentsMap});
        computerDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        computerDepartmentCollectionDivision.document('C').setData({'demo1': demoStudentsMap});
        computerDepartmentCollectionDivision.document('D').setData({'demo1': demoStudentsMap});
        final mechanicalDepartmentDocumentReference = documentReference
            .collection(QuizCollectionNames.subSubCollectionResult)
            .document(mechanical);

        mechanicalDepartmentDocumentReference.setData({'demo': 'demo'});

        final mechanicalDepartmentCollectionDivision = mechanicalDepartmentDocumentReference.collection(division);
        mechanicalDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        mechanicalDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        mechanicalDepartmentCollectionDivision.document('C').setData({'demo1': demoStudentsMap});
        mechanicalDepartmentCollectionDivision.document('D').setData({'demo1': demoStudentsMap});

        final civilDepartmentDocumentReference = documentReference
            .collection(QuizCollectionNames.subSubCollectionResult)
            .document(civil);

        civilDepartmentDocumentReference.setData({'demo': 'demo'});

        final civilDepartmentCollectionDivision = civilDepartmentDocumentReference.collection(division);
        civilDepartmentCollectionDivision.document('A').setData({'demo1': demoStudentsMap});
        civilDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        civilDepartmentCollectionDivision.document('C').setData({'demo1': demoStudentsMap});
        civilDepartmentCollectionDivision.document('D').setData({'demo1': demoStudentsMap});

        final entcDepartmentDocumentReference = documentReference
            .collection(QuizCollectionNames.subSubCollectionResult)
            .document(entc);

        entcDepartmentDocumentReference.setData({'demo': 'demo'});

        final entcDepartmentCollectionDivision = entcDepartmentDocumentReference.collection(division);
        entcDepartmentCollectionDivision.document('A').setData({'demo1': demoStudentsMap});
        entcDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        entcDepartmentCollectionDivision.document('C').setData({'demo1': demoStudentsMap});
        entcDepartmentCollectionDivision.document('D').setData({'demo1': demoStudentsMap});

        final chemicalDepartmentDocumentReference = documentReference
            .collection(QuizCollectionNames.subSubCollectionResult)
            .document(chemical);

        chemicalDepartmentDocumentReference.setData({'demo': 'demo'});

        final chemicalDepartmentCollectionDivision = chemicalDepartmentDocumentReference.collection(division);
        chemicalDepartmentCollectionDivision.document('A').setData({'demo1': demoStudentsMap});
        chemicalDepartmentCollectionDivision.document('B').setData({'demo1': demoStudentsMap});
        chemicalDepartmentCollectionDivision.document('C').setData({'demo1': demoStudentsMap});
        chemicalDepartmentCollectionDivision.document('D').setData({'demo1': demoStudentsMap});

      }

      
    } catch (e) {
      throw e;
    }
  }

  List<dynamic> quizQuestions = [];
  List<dynamic> quizAnswers = [];
  List<dynamic> quizMarks = [];
  List<List<String>> quizOptions = [];
  var quizOptionsMap;

  _convertQuizData(var documentID) async {
    await _firestore.collection(collection)
        .document(QuizCollectionNames.mainCollectionQuizDocumentName)
        .collection(QuizCollectionNames.subCollectionQuizDocument)
        .document(documentID)
        .collection(QuizCollectionNames.subSubCollection)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) async {
        quizQuestions =  result[QuizCollectionNames.questionField];
        quizOptionsMap =  result[QuizCollectionNames.optionsField];
        quizAnswers =  result[QuizCollectionNames.answerField];
        quizMarks =  result[QuizCollectionNames.marksField];
      });
    });
  }

  /*
  This function is used when we have to display the quiz by fetching the data from
  firestore.
  Here the documentID is already provided.
  */
  getQuizData(var documentID) async{

    await _convertQuizData(documentID);

    List<int> _quizAnswers = quizAnswers.map((answer) => answer as int).toList();
    List<int> _quizMarks = quizMarks.map((answer) => answer as int).toList();
    List<String> _quizQuestions = quizQuestions.map((answer) => answer as String).toList();

    await _convertQuizData(documentID);
    for(var options in quizOptionsMap) {
      List<String> optionList = [];
      for(String option in options.values) {
        optionList.add(option.toString());
      }
      quizOptions.add(optionList);
    }

    return QuizQuestionModule(
      questionList: _quizQuestions,
      optionsList: quizOptions,
      answerList: _quizAnswers,
      marksList: _quizMarks,
    );
  }

  deleteQuiz(String documentID) {
    try{

      //TO Delete the quiz collection.
      _firestore.collection(collection)
        .document(QuizCollectionNames.mainCollectionQuizDocumentName)
        .collection(QuizCollectionNames.mainCollectionQuizDocumentName)
        .document(documentID)
        .collection(QuizCollectionNames.subSubCollection)
        .document()
        .delete();

      //TO delete the quiz fields.
      _firestore.collection(collection)
        .document(QuizCollectionNames.mainCollectionQuizDocumentName)
        .collection(QuizCollectionNames.subCollectionQuizDocument)
        .document(documentID)
        .delete();
    }
    catch(e){
      throw e;
    }
  }


}