// EVENTS
import '../../classes/objects/question_object.dart';
import '../../classes/objects/leaderboard_item.dart';

abstract class QuizEvents {
  const QuizEvents();
}

class CheckGameStartedEvent extends QuizEvents {
  const CheckGameStartedEvent();
}

class GetQuestionEvent extends QuizEvents {
  const GetQuestionEvent();
}

class SubmitAnswerEvent extends QuizEvents {
  final int answerId;
  final int questionId;
  const SubmitAnswerEvent({required this.answerId, required this.questionId});
}

class GetLeaderboardEvent extends QuizEvents {
  const GetLeaderboardEvent();
}

// STATES
abstract class QuizState {
  const QuizState();
}

class JoinedWaitingState extends QuizState {

  const JoinedWaitingState();
}

class GameCompletedState extends QuizState {
  final String quizSessionId;
  final List<LeaderboardItem>? leaderboard;
  final int? currentPlayerRank;

  const GameCompletedState({
    required this.quizSessionId,
    this.leaderboard,
    this.currentPlayerRank,
  });
}

class WaitingForNextQuestionState extends QuizState {
  final String? title;

  const WaitingForNextQuestionState({this.title});
}

class ShowQuestionState extends QuizState {
  final QuestionObject question;

  const ShowQuestionState({required this.question});
}