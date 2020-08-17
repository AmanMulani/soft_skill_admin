import 'package:frideos/frideos.dart';
import 'quiz_question_model.dart';

class QuizUIBloc {


  QuizUIBloc(){
    print('----------Inside QUIZ UI BLOC-------------');
  }


  //to store all the questions of the quiz
  final questionField = StreamedList<StreamedValue<String>>(initialData: []);
  //to store all the options of each question of the quiz
  final optionField = List<StreamedList<StreamedValue<String>>>();
  //to store the marks of each question of the quiz
  final marksField = StreamedList<StreamedValue<String>>(initialData: []);
  //to store the correct answer of each question of the quiz
  final ansField = StreamedList<StreamedValue<String>>(initialData: []);
  //to check whether the form is valid or not
  final isFormValid = StreamedValue<bool>();


  //to temporarily store the options of one(current) question
  final tempOptionField = StreamedList<StreamedValue<String>>(initialData: []);


  int currentQuestionNumber = 0;
  int questionIndex = 0;
  var completeQuiz;


  /*to remove a particular option field
  super index is the index of the current question number
  index is the option number to be deleted*/
  void removeOptionField(int superIndex, int index) {
    optionField[superIndex].removeAt(index);
  }

  /*this method adds a StreamedList to the optionsField
  it is used when we click on the add options button.*/
  void addOptionsStreamToList() {
    optionField.add(StreamedList<StreamedValue<String>>(initialData: []));
  }

  /*this method is called when we create a new question by
  clicking on the new question button.*/
  void addQuestionField() {
    questionField.addElement(StreamedValue<String>());
    questionField.value.last.onChange(checkForm);
    checkForm(null);
  }

  /*this method is called when we need to add one option to the list of
  answers of the given question.*/
  void addOneOption(int index) {
    optionField[index].addElement(StreamedValue<String>());
    this.currentQuestionNumber = index;
    optionField[index].value.last.onChange(checkForm);
    checkForm(null);
  }

  /*this method is called when we create a new question by
  clicking on the new question button.
  A new answer field, i.e. InputFormField is created.*/
  void addAnswerField() {
    ansField.addElement(StreamedValue<String>());

    ansField.value.last.onChange(checkForm);
    checkForm(null);
  }

  //to specify marks of each question.
  void addMarksField() {
    marksField.addElement(StreamedValue<String>());

    marksField.value.last.onChange(checkForm);
    checkForm(null);
  }

  //To dynamically keep checking for the change in the form.
  void checkForm(String _) {

    bool isValidQuestionType = true;
    bool isValidOptionType = true;
    bool isValidAnswerType = true;
    bool isValidMarksType = true;

    //to check the validity of questions entered.
    for(var item in questionField.value){

      if(item.value != null) {
        if(item.value.isEmpty) {
          item.stream.sink.addError('This field must not be empty');
          isValidQuestionType = false;
        }
      }
      else {
        isValidQuestionType = false;
      }
    }

    //to check the validity of all the options entered at once
    for(var listOfStream in optionField) {
      for(var item in listOfStream.value) {
        if(item.value!=null) {
          if(item.value.isEmpty) {
            item.stream.addError('This field must not be empty');
            isValidOptionType = false;
          }
        }
        else{
          isValidOptionType = false;
        }
      }
    }

    //to check the validity of answer field
    int index = 0;
    for(var item in ansField.value) {
      if(item.value != null) {
        final correctAnswer = int.tryParse(item.value);

        if(correctAnswer == null) {
          item.stream.addError('Enter a valid number');
          isValidAnswerType = false;
        }
        else if(correctAnswer < 1 ) {
          item.stream.addError('Invalid Option number');
          isValidAnswerType = false;
        }
        else if(correctAnswer > optionField[index].length) {
          item.stream.addError('Given answer exceeds the number of options');
          isValidAnswerType = false;
        }
      }
      else {
        isValidAnswerType = false;
      }
      index++;
    }

    //to check the validity of marks entered.
    for(var item in marksField.value) {
      if(item.value != null)  {
        final marks = int.tryParse(item.value);

        if(marks == null) {
          item.stream.addError('Marks must be a positive natural number');
          isValidMarksType = false;
        }
      }
      else {
        isValidMarksType = false;
      }
    }

    //to check whether all the parameters are satisfied or not.
    if(isValidMarksType && isValidAnswerType && isValidQuestionType && isValidOptionType) {
      isFormValid.value = true;
    }
    else {
      isFormValid.value = null;
    }

  }

  /*To convert all the data into QuizQuestionModule object*/
  QuizQuestionModule submit() {

    List<String> questions = [];
    List<List<String>> optionsOfAllQuestions = [];
    List<int> answers = [];
    List<int> marks = [];

    for(var questionStream in questionField.value) {
      questions.add(questionStream.value);
    }

    for(var optionsStreamedList in optionField) {
      List<String> optionOfCurrentQuestion = [];
      for(var optionsStreamedList in optionsStreamedList.value) {
        optionOfCurrentQuestion.add(optionsStreamedList.value);
      }
      optionsOfAllQuestions.add(optionOfCurrentQuestion);
    }

    for(var answerStream in ansField.value) {
      answers.add(int.parse(answerStream.value));
    }

    for(var marksStream in marksField.value) {
      marks.add(int.parse(marksStream.value));
    }

    completeQuiz = QuizQuestionModule(
      marksList: marks,
      questionList: questions,
      optionsList: optionsOfAllQuestions,
      answerList: answers,
    );

    return completeQuiz;
  }

  /*When we want to delete a whole question including all its field
  i.e options, marks and correct answer.*/
  void removeField(int index) {

    questionField.removeAt(index);
    marksField.removeAt(index);
    optionField.removeAt(index);
    ansField.removeAt(index);

  }

  /*To dispose all the data as soon as we are done with uploading the quiz*/
  void dispose() {
    print('------DISPOSING THE BLOC-------');
    for(var item in questionField.value) {
      item.dispose();
    }
    questionField.dispose();

    for(var item in ansField.value) {
      item.dispose();
    }
    ansField.dispose();

    for(var item in marksField.value) {
      item.dispose();
    }
    marksField.dispose();

    for(var items in optionField) {
      for(var item in items.value) {
        item.dispose();
      }
      items.dispose();
    }
    tempOptionField.dispose();
    isFormValid.dispose();

    print('------------FREED ALL RESOURCES----------');
  }
}



