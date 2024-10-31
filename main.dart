import 'dart:ffi';

import "participant.dart";
import 'question.dart';
import 'quiz.dart';
import 'dart:io';

main() async{
  List<Quiz> quizList = [];
  List<Participant> participantList = await Participant.loadAllData();

  Quiz quiz1 = Quiz(id: 1, name: "Capital City Quiz");
  Quiz quiz2 = Quiz(id: 2, name: "Math Quiz");

  // Quiz 1
  Question question1 = Question(1, "What is the capital of Indonesia?",
      ["Bandung", "Bali", "Jakarta", "Surabaya"], [3]);
  Question question2 = Question(2, "What is the capital of Japan?",
      ["Tokyo", "Kyoto", "Osaka", "Hokkaido"], [1]);
  Question question3 = Question(3, "What is the capital of South Korea?",
      ["Busan", "Seoul", "Incheon", "Jeju"], [2]);

  // Quiz 2

  Question multipleQuestion1 = Question.multiple(
      1,
      "Which of the following are gases found in the Earth's atmosphere?",
      ["Nitrogen", "Oxygen", "Helium", "Carbon Dioxide", "Mercury"],
      [1, 2, 4]);
  Question multipleQuestion2 = Question.multiple(
      2,
      "Which of the following are prime numbers?",
      ["1", "2", "3", "4", "5"],
      [1, 2, 3, 5]);
  Question multipleQuestion3 = Question.multiple(
      3,
      "Which of the following are even numbers?",
      ["1", "2", "3", "4", "5"],
      [2, 4]);

  quiz1.addQuestion([question1]);
  quiz1.addQuestion([question2]);
  quiz1.addQuestion([question3]);

  quiz2.addQuestion([multipleQuestion1]);
  quiz2.addQuestion([multipleQuestion2]);
  quiz2.addQuestion([multipleQuestion3]);

  quizList.add(quiz1);
  quizList.add(quiz2);

  print("Welcome to the quiz app!");
  String input = "";
  try {
    while (input != "Q") {
      print("Type P for participant");
      print("Type Q to quit!");
      print("Enter the values: ");
      input = stdin.readLineSync()!;
      switch (input) {
        case "P":
          print("\nEnter your name: ");
          String name = stdin.readLineSync()!;
          for (var i = 0; i < participantList.length; i++) {
            if (participantList[i].name == name) {
              print("\nWelcome back, $name!");
              break;
            } else {
              Participant newParticipant = Participant(name: name, completedQuiz: [], score: 0);
              participantList.add(newParticipant);
              print("\nWelcome, $name!");
              break;
            }
          }
          while (input != "Q") {
            print("Type S to start the quiz");
            print("Type D to display the participant's information");
            print("Type Q to quit!");
            print("\nEnter the values: ");
            input = stdin.readLineSync()!;
            switch (input) {
              case "S":
                print("\nChoose a quiz: \n");
                for (var i = 0; i < quizList.length; i++) {
                  print("${i + 1}. ${quizList[i].name}");
                }
                print("Enter your choice: ");
                int quizChoice = int.parse(stdin.readLineSync()!);

                print(quizList[quizChoice - 1]);
                for (var i = 0; i < quizList[quizChoice - 1].questionlist.length; i++) {

                  print("Question ${i + 1}:");
                  print(quizList[quizChoice - 1].questionlist[i].title + "\n");

                  for (var j = 0; j < quizList[quizChoice - 1].questionlist[i].answer.length; j++) {
                    print("${j + 1}. ${quizList[quizChoice - 1].questionlist[i].answer[j]}");
                  }

                  print("Enter your answer: ");
                  List<int> choiceInputs = stdin.readLineSync()!.split(",").map((e) => int.parse(e)).toList();

                  if (quizList[quizChoice - 1].questionlist[i].type == QuestionType.SingleChoice) {
                    for (var participant in participantList) {
                      if (participant.name == name) {
                        participant.answerSingle(quizList[quizChoice - 1], i, choiceInputs);
                      }
                    }
                  } else {
                    for (var participant in participantList) {
                      if (participant.name == name) {
                        participant.answerMultiple(quizList[quizChoice - 1], i, choiceInputs);
                      }
                    }
                  }
                }
                for (var i = 0; i < participantList.length; i++) {
                  if (participantList[i].name == name) {
                    participantList[i].addCompletedQuiz(quizChoice);
                    break;
                  }
                }
                break;
              case "Q":
                break;
              case "D":
                for (var i = 0; i < participantList.length; i++) {
                  if (participantList[i].name == name) {
                    print(participantList[i]);
                    break;
                  }
                }
                break;
              default:
                throw new ArgumentError("Invalid input!");
            }
          }
          break;
        case "Q":
          break;
        default:
          throw new ArgumentError("Invalid input!");
      }
    }
  } catch (e) {
    print(e);
  }
  for (var i = 0; i < participantList.length; i++) {
    participantList[i].storeData(i + 1);
  }
}
