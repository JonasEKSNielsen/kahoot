import 'dart:convert';
import 'answer_object.dart';

class QuestionObject {
  int? id, timeLimitseconds, points, orderIndex;
  String? text;
  List<AnswerObject?> answers = [];

  QuestionObject({
    required this.id,
    required this.text,
    required this.timeLimitseconds,
    required this.points,
    required this.orderIndex,
    this.answers = const [],
  });

  static QuestionObject? getQuestionObjectFromJson(String response) {
    try {      
      final result = jsonDecode(response);
      if (result != null) {
        if (result is List && result.isNotEmpty) {
          for (var element in result) {
            QuestionObject? newQuestionObject = getQuestionObjectFromJsonMap(element);
            if (newQuestionObject != null) {
              return newQuestionObject;
            }
          }
        } else if (result is Map<String, dynamic>) {
          QuestionObject? newQuestionObject = getQuestionObjectFromJsonMap(result);
          if (newQuestionObject != null) {
            return newQuestionObject;
          } else {
            return null;
          }
        }
      }
    } catch (_) {}

    return null;
  }

  static QuestionObject? getQuestionObjectFromJsonMap(Map<String, dynamic> response) {
    try {
      QuestionObject questionObject = QuestionObject(
        id: response['id'],
        text: response['text'],
        timeLimitseconds: response['timeLimitSeconds'],
        points: response['points'],
        orderIndex: response['orderIndex'],
        answers: [],
      );

      var answersJson = response['answers'];
      if (answersJson != null && answersJson is List && answersJson.isNotEmpty) {
        for (var answerElement in answersJson) {
          AnswerObject? answer = AnswerObject.getAnswerFromJsonMap(answerElement);
          if (answer != null) {
            questionObject.answers.add(answer);
          }
        }
      }

      return questionObject;

    } catch (_) {}

    return null;
  }
}