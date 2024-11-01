import 'question.dart';


class Quiz {
  int _id;
  final List<Question> _questionlist = [];
  final String _name;

  List<Question> get questionlist => _questionlist;  
  String get name => _name;
  int get id => _id;
  
  Quiz({required int id, required String name}): this._name = name, this._id = id;

  void addQuestion(List<Question> newQuestionList) {
    for (var i = 0; i < newQuestionList.length; i++) {
      this._questionlist.add(newQuestionList[i]);
    }
  }

  @override
  String toString() {
    String result = "Quiz: $_name\n\n";
    for (var i = 0; i < _questionlist.length; i++) {
      result += "Question ${i+1}: ${_questionlist[i].title}\n";
      for (var j = 0; j < _questionlist[i].answer.length; j++) {
        result += "${j+1}. ${_questionlist[i].answer[j]}\n";
      }
    }
    return result;
  }
}
