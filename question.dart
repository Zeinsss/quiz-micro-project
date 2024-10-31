enum QuestionType { SingleChoice, MultipleChoice }

class Question {
  int _id;
  final String _title;
  final List<String> _answers;
  final List<int> _correctAnswers;
  final QuestionType _type;

  String get title => _title;
  List<String> get answer => _answers;
  List<int> get correctAnswers => _correctAnswers;
  String get type => _type.name;
  int get id => _id;

  set id(int newId) {
    if (newId < 0) {
      throw new ArgumentError("ID must be greater than 0!");
    } else {
      this._id = newId;
    }
  }

  // Defaults into single choice
  Question(this._id, this._title, this._answers, this._correctAnswers)
      : this._type = QuestionType.SingleChoice;

  Question.multiple(this._id, this._title, this._answers, this._correctAnswers)
      : this._type = QuestionType.MultipleChoice;

  void addAnswer(String newAnswer) {
    this._answers.add(newAnswer);
  }

  void addCorrectAnswer(List<int> answerChoice) {
    // Guaranteed that answer must be 5 before continuing
    if (_answers.length < 5) {
      throw new ArgumentError("Answer must have 4 choices!");
    } else {
      switch (this._type) {
        case QuestionType.SingleChoice:
          if (this._correctAnswers.length > 0) {
            throw new ArgumentError(
                "No more than one answer choice for single choice answer!");
          } else {
            this._correctAnswers.add(answerChoice[0]);
          }
        case QuestionType.MultipleChoice:
          // Limit answer of multiple choice to
          if (this._correctAnswers.length >= 2) {
            throw new ArgumentError(
                "The correct answer has reach the appropriate number for this question");
          } else {
            for (var i = 0; i < answerChoice.length; i++) {
              this._correctAnswers.add(answerChoice[i]);
            }
          }
      }
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Question: $_title\nAnswers: $_answers\nCorrect Answer: $_correctAnswers\nType: $_type";
  }
}
