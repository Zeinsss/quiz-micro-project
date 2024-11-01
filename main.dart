import 'dart:ffi';

import "participant.dart";
import 'question.dart';
import 'quiz.dart';
import 'dart:io';

void main() async {
  List<Quiz> quizList = initializeQuizzes();
  List<Participant> participantList = await Participant.loadAllData();

  print("Welcome to the quiz app!");
  try {
    while (true) {
      String input = displayMainMenu();
      if (input == "Q") break;

      switch (input) {
        case "P":
          handleParticipantMenu(participantList, quizList);
          break;
        default:
          print("Invalid input. Please try again.");
      }
    }
  } catch (e) {
    print("Error: $e");
    
  }
  

  saveParticipantData(participantList);
}

List<Quiz> initializeQuizzes() {
  Quiz quiz1 = Quiz(id: 1, name: "Capital City Quiz");
  quiz1.addQuestion([
    Question(1, "What is the capital of Indonesia?", ["Bandung", "Bali", "Jakarta", "Surabaya"], [3]),
    Question(2, "What is the capital of Japan?", ["Tokyo", "Kyoto", "Osaka", "Hokkaido"], [1]),
    Question(3, "What is the capital of South Korea?", ["Busan", "Seoul", "Incheon", "Jeju"], [2]),
  ]);

  Quiz quiz2 = Quiz(id: 2, name: "Math Quiz");
  quiz2.addQuestion([
    Question.multiple(1, "Which of the following are gases found in the Earth's atmosphere?", ["Nitrogen", "Oxygen", "Helium", "Carbon Dioxide", "Mercury"], [1, 2, 4]),
    Question.multiple(2, "Which of the following are prime numbers?", ["1", "2", "3", "4", "5"], [1, 2, 3, 5]),
    Question.multiple(3, "Which of the following are even numbers?", ["1", "2", "3", "4", "5"], [2, 4]),
  ]);

  return [quiz1, quiz2];
}

String displayMainMenu() {
  print("\nMain Menu:");
  print("Type P to participate in a quiz");
  print("Type Q to quit the app");
  stdout.write("Enter your choice: ");
  return stdin.readLineSync()!.toUpperCase();
}

void handleParticipantMenu(List<Participant> participantList, List<Quiz> quizList) {
  stdout.write("Enter your name: ");
  String name = stdin.readLineSync()!;
  Participant participant = getOrCreateParticipant(participantList, name);

  while (true) {
    String input = displayParticipantMenu();
    if (input == "Q") break;

    switch (input) {
      case "S":
        startQuiz(participant, quizList);
        break;
      case "D":
        displayParticipantInfo(participant);
        break;
      case "A":
        displayAllParticipants(participantList);
        break;
      default:
        print("Invalid input. Please try again.");
    }
  }
}

String displayParticipantMenu() {
  print("\nParticipant Menu:");
  print("Type S to start a quiz");
  print("Type D to display your information");
  print("Type A to display all participants' information");
  print("Type Q to go back to main menu");
  stdout.write("Enter your choice: ");
  return stdin.readLineSync()!.toUpperCase();
}

Participant getOrCreateParticipant(List<Participant> participantList, String name) {
  for (var participant in participantList) {
    if (participant.name == name) {
      print("\nWelcome back, $name!");
      return participant;
    }
  }
  Participant newParticipant = Participant(name: name, completedQuiz: [], score: 0);
  participantList.add(newParticipant);
  print("\nWelcome, $name!");
  return newParticipant;
}

void startQuiz(Participant participant, List<Quiz> quizList) {
  print("\nChoose a quiz:");
  for (var i = 0; i < quizList.length; i++) {
    print("${i + 1}. ${quizList[i].name}");
  }

  stdout.write("Enter your choice: ");
  int quizChoice = int.parse(stdin.readLineSync()!);
  if (quizChoice < 1 || quizChoice > quizList.length) {
    print("Invalid quiz choice. Returning to menu.");
    return;
  }

  Quiz chosenQuiz = quizList[quizChoice - 1];
  if (participant.completedQuiz.contains(chosenQuiz.id)) {
    print("\nYou have already completed this quiz!\n");
    return;
  }

  for (var question in chosenQuiz.questionlist) {
    print("Question: ${question.title} (${question.type})");
    for (int j = 0; j < question.answer.length; j++) {
      print("${j + 1}. ${question.answer[j]}");
    }

    stdout.write("Enter your answer(s) separated by commas: ");
    List<int> choiceInputs = stdin.readLineSync()!.split(",").map((e) => int.parse(e)).toList();

    if (question.type == QuestionType.SingleChoice) {
      participant.answerSingle(chosenQuiz, chosenQuiz.questionlist.indexOf(question), choiceInputs);
    } else {
      participant.answerMultiple(chosenQuiz, chosenQuiz.questionlist.indexOf(question), choiceInputs);
    }
  }

  participant.addCompletedQuiz(chosenQuiz.id);
}

void displayParticipantInfo(Participant participant) {
  print("\nParticipant Information:");
  print(participant);
}

void displayAllParticipants(List<Participant> participantList) {
  print("\nAll Participants:");
  for (var participant in participantList) {
    print(participant);
  }
}

void saveParticipantData(List<Participant> participantList) {
  for (int i = 0; i < participantList.length; i++) {
    participantList[i].storeData(i + 1);
  }
}
