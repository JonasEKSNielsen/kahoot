

enum ApiPath {
  auth,
  participant,
  quiz,
  quizSession,
}

extension PathExtension on ApiPath {
  String get value {
    String name;
    switch (this) {
      case ApiPath.auth:
        name = 'auth';
      case ApiPath.participant:
        name = 'Participant';
      case ApiPath.quiz:
        name = 'Quiz';
      case ApiPath.quizSession:
        name = 'QuizSession';
    }
    return name;
  }
}