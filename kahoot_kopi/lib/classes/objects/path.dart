

enum ApiPath {
  auth,
  participant,
  participantSubmitAnswer,
  participantLeaderboard,
  quiz,
  quizSession,
  quizSessionJoin,
  quizSessionPin,
  authOAuthLogin,
}

extension PathExtension on ApiPath {
  String get value {
    String name;
    switch (this) {
      case ApiPath.auth:
        name = 'auth';
      case ApiPath.participant:
        name = 'Participant';
      case ApiPath.participantSubmitAnswer:
        name = 'Participant/submit-answer';
      case ApiPath.participantLeaderboard:
        name = 'Participant/leaderboard';
      case ApiPath.quiz:
        name = 'Quiz';
      case ApiPath.quizSession:
        name = 'QuizSession';
      case ApiPath.quizSessionJoin:
        name = 'QuizSession/join';
      case ApiPath.quizSessionPin:
        name = 'QuizSession/pin';
      case ApiPath.authOAuthLogin:
        name = 'auth/oauth-login';
    }
    return name;
  }
}