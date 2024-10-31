import 'dart:ffi';

import "participant.dart";
import 'question.dart';
import 'quiz.dart';
import 'dart:io';

main() {
  List<Quiz> quizList = [];
  List<Participant> participantList = [];

  // Create a quiz
  Quiz quiz1 = Quiz(id: 1, name: "Capital City Quiz");
  Quiz quiz2 = Quiz(id: 2, name: "Math Quiz");

  // Create a question
  // Quiz 1
  Question question1 = Question(1, "What is the capital of Indonesia?",
      ["Jakarta", "Bandung", "Bali", "Surabaya"], [1]);
  Question question2 = Question(2, "What is the capital of Japan?",
      ["Tokyo", "Kyoto", "Osaka", "Hokkaido"], [1]);
  Question question3 = Question(3, "What is the capital of South Korea?",
      ["Seoul", "Busan", "Incheon", "Jeju"], [1]);

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
  // Add question to the quiz
  quiz1.addQuestion([question1]);
  quiz1.addQuestion([question2]);
  quiz1.addQuestion([question3]);

  quiz2.addQuestion([multipleQuestion1]);
  quiz2.addQuestion([multipleQuestion2]);
  quiz2.addQuestion([multipleQuestion3]);
  // Add quiz to the quiz list
  quizList.add(quiz1);
  quizList.add(quiz2);
  // Create a participant
  Participant participant =
      Participant(name: "Tithya", completedQuiz: [], score: 0);
  Participant participant2 =
      Participant(name: "John", completedQuiz: [], score: 0);
  // Add participant to the participant list
  participantList.add(participant);
  participantList.add(participant2);

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
              Participant newParticipant =
                  Participant(name: name, completedQuiz: [], score: 0);
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
                print("Choose a quiz: ");
                for (var i = 0; i < quizList.length; i++) {
                  print("${i + 1}. ${quizList[i].name}");
                }
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
                    for (var i = 0; i < participantList.length; i++) {
                      if (participantList[i].name == name) {
                        participantList[i].answerSingle(quizList[quizChoice - 1], i, choiceInputs);
                      }
                    }
                  } else {
                    for (var i = 0; i < participantList.length; i++) {
                      if (participantList[i].name == name) {
                        participantList[i].answerMultiple(quizList[quizChoice - 1], i, choiceInputs);
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
        default:
          throw new ArgumentError("Invalid input!");
      }
    }
  } catch (e) {
    print(e);
  }
}
