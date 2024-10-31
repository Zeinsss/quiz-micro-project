import 'dart:convert';
import 'dart:io';

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
    int count = 0;
    final List<int> correctAnswers = [];
    final List<int> wrongAnswers = [];
    if (q.questionlist[questionNumber].correctAnswers.length != answerChoices.length) {
      print("The number of answers is incorrect.");
      print("The right answer is \"${q.questionlist[questionNumber].correctAnswers}\"");
    }
    else {
      bool isCorrect = true;
      for (var i = 0; i < answerChoices.length; i++) {
        if (!q.questionlist[questionNumber].correctAnswers.contains(answerChoices[i])) {
          isCorrect = false;
          wrongAnswers.add(answerChoices[i]);
          break;
        }
        else {
          count++;
          correctAnswers.add(answerChoices[i]);
        }
      }
      final List<int> forgetAnswers = [];
      for (var i = 0; i < q.questionlist[questionNumber].correctAnswers.length; i++) {
        if (!answerChoices.contains(q.questionlist[questionNumber].correctAnswers[i])) {
          forgetAnswers.add(q.questionlist[questionNumber].correctAnswers[i]);
        }
      }
      if (isCorrect) {
        this._score += count;
        print("\"$answerChoices\" is the correct answer.");
      }
      else {
        print("Your answer: $answerChoices");
        print("Corrected: $correctAnswers");
        print("Wrong: $wrongAnswers");
        print("Forget: $forgetAnswers");
        print("The total right answer is \"${q.questionlist[questionNumber].correctAnswers}\"");

      }
    }
  }

  void storeData(int num) async {
    final participantData = {
      'name': _name,
      'completedQuiz': _completedQuiz,
      'score': _score,
    };

    final jsonString = jsonEncode(participantData);
    final file = File('participant_data-$num.json');
    await file.writeAsString(jsonString);
    print("Data saved to participant_data-$num.json");
  }

  static Future<List<Participant>> loadAllData() async {
    int count = 1;
    List<Participant> participants = [];

    while (true) {
      final file = File('participant_data-$count.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);

        participants.add(
          Participant(
            name: jsonData['name'],
            completedQuiz: List<int>.from(jsonData['completedQuiz']),
            score: jsonData['score'],
          ),
        );
        count++;
      } else {
        break;
      }
    }

    if (participants.isEmpty) {
      print("No saved data found.");
    } else {
      print("${participants.length} participants loaded.\n");
    }

    return participants;
  }


  void addCompletedQuiz(int id) {
    if (!_completedQuiz.contains(id)) {
      this._completedQuiz.add(id);
    }
  }

  @override
  String toString() {
    return "\nParticipant: $_name\nCompleted Quiz: $_completedQuiz\nScore: $_score\n";
  }
} 
