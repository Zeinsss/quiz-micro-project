import 'quiz.dart';

class Participant {
  final String _name;
  final List<int> _completedQuiz;
  int _score;

  String get name => _name;
  List<int> get completedQuiz => _completedQuiz;
  int get score => _score;

  Participant({required String name, required List<int> completedQuiz, required int score}): this._name = name, this._completedQuiz = completedQuiz, this._score = score;

  void answerSingle(Quiz q, int questionNumber,  List<int> choiceInputs) {
    if (q.questionlist[questionNumber].correctAnswers == choiceInputs[0] ) {
      this._score++;
      print("\"$choiceInputs\" is the correct answer.");
    }
    else {
      print("\"$choiceInputs\" is not the correct answer.");
      print("The right answer is \"${q.questionlist[questionNumber].correctAnswers[0]}\"");   
    }
  }

  void answerMultiple(Quiz q, int questionNumber, List<int> answerChoices) {
    if (q.questionlist[questionNumber].correctAnswers.length != answerChoices.length) {
      print("The number of answers is incorrect.");
      print("The right answer is \"${q.questionlist[questionNumber].correctAnswers}\"");
    }
    else {
      bool isCorrect = true;
      for (var i = 0; i < answerChoices.length; i++) {
        if (!q.questionlist[questionNumber].correctAnswers.contains(answerChoices[i])) {
          isCorrect = false;
          break;
        }
      }
      if (isCorrect) {
        this._score++;
        print("\"$answerChoices\" is the correct answer.");
      }
      else {
        print("\"$answerChoices\" is not the correct answer.");
        print("The right answer is \"${q.questionlist[questionNumber].correctAnswers}\"");
      }
    }
  }

  void addCompletedQuiz(int id) {
    this._completedQuiz.add(id);
  }

  @override
  String toString() {
    return "\nParticipant: $_name\nCompleted Quiz: $_completedQuiz\nScore: $_score\n";
  }
} 
