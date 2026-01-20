import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'dart:async';
import '../../classes/helpers/api.dart';
import '../../classes/helpers/general_helper.dart';
import '../../classes/objects/path.dart';
import '../../classes/objects/question_object.dart';
import '../../classes/objects/submit_answer_dto.dart';
import '../../classes/objects/leaderboard_item.dart';
import '../../main.dart';
import 'quiz_events_states.dart';


class QuizBloc extends Bloc<QuizEvents, QuizState> {
  Timer? _gameCheckTimer;
  Timer? _getQuestionTimer;
  int? _currentQuestionId = -1;
  DateTime answerTime = DateTime.now();
  bool _isShowingDialog = false;
  bool _isSubmittingAnswer = false;

  QuizBloc({required this.pin, required this.nickname, required this.quizSessionId, required this.participantId})
      : super(const JoinedWaitingState()) {
        on<CheckGameStartedEvent>(_onCheckGameStarted);
        on<GetQuestionEvent>(_onGetQuestion);
        on<SubmitAnswerEvent>(_onSubmitAnswer);
        on<GetLeaderboardEvent>(_onGetLeaderboard);

    _startGameCheckTimer();
  }

  final String pin;
  final String nickname;
  final String quizSessionId;
  final int participantId;

  @override
  Future<void> close() {
    _gameCheckTimer?.cancel();
    _getQuestionTimer?.cancel();
    return super.close();
  }

  Future<void> _onCheckGameStarted(CheckGameStartedEvent event, Emitter<QuizState> emit) async {
    final currentState = state;
    if (currentState is JoinedWaitingState) {
      try {
        Response response = await API.getRequestWithId(ApiPath.quizSessionPin, pin);

        if (response.statusCode == 200) {
          var jsonRes = json.decode(response.body);
          if (jsonRes['status'] == 'InProgress') {
            _startGetQuestionTimer();
            emit(WaitingForNextQuestionState());
          }
        }
      } catch (_) {}
    }
  }

  void _startGameCheckTimer() {
    _gameCheckTimer?.cancel();
    _gameCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isSubmittingAnswer) { 
        add(const CheckGameStartedEvent());
      }
    });
  }

  Future<void> _onGetQuestion(GetQuestionEvent event, Emitter<QuizState> emit) async { 
    final currentState = state;
    if (currentState is WaitingForNextQuestionState || currentState is ShowQuestionState) {
      try {
        Response response = await API.getCurrentQuestion(quizSessionId);

        if (response.statusCode == 200) {
          QuestionObject? question = QuestionObject.getQuestionObjectFromJson(response.body);

          if (question != null && _currentQuestionId != question.id) {
            _currentQuestionId = question.id;
            answerTime = DateTime.now();
            _isSubmittingAnswer = false;

            if (_isShowingDialog) {
              // Close dialog
              Navigator.of(globalNavigatorKey.currentContext!).pop();
            }

            emit(ShowQuestionState(question: question));
          }
        } else if (response.body.contains('Nuværende status: Completed')) {
          _gameCheckTimer?.cancel();
          _getQuestionTimer?.cancel();
          if(_isShowingDialog) {
            Navigator.of(globalNavigatorKey.currentContext!).pop();
          }
          add(const GetLeaderboardEvent());
        }
      } catch (_) {}
    }
  }

  Future<void> _onSubmitAnswer(SubmitAnswerEvent event, Emitter<QuizState> emit) async {
    try {
      GeneralHelper.showLoadingDialog('Submitting answer...');
      _isSubmittingAnswer = true;
      _isShowingDialog = true;
      await API.postRequest(
        ApiPath.participantSubmitAnswer, 
        SubmitAnswerDto(
          answerId: event.answerId, 
          participantId: participantId, 
          questionId: event.questionId, 
          responseTimeMs: DateTime.now().difference(answerTime).inMilliseconds,
        ).toJson(),
      );
    } catch (_) {}
  }

  void _startGetQuestionTimer() {
    _gameCheckTimer?.cancel();
    _getQuestionTimer?.cancel();
    _getQuestionTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      add(const GetQuestionEvent());
    });
  }

  Future<void> _onGetLeaderboard(GetLeaderboardEvent event, Emitter<QuizState> emit) async {
    try {
      Response response = await API.getRequestWithId(ApiPath.participantLeaderboard, quizSessionId);

      if (response.statusCode == 200) {
        List<LeaderboardItem> leaderboard = LeaderboardItem.fromJsonList(json.decode(response.body));
        
        // Find current rank
        int? currentPlayerRank;
        for (int i = 0; i < leaderboard.length; i++) {
          if (leaderboard[i].participantId == participantId) {
            currentPlayerRank = leaderboard[i].rank;
            break;
          }
        }

        emit(GameCompletedState(
          quizSessionId: quizSessionId,
          leaderboard: leaderboard,
          currentPlayerRank: currentPlayerRank,
        ));
      }
    } catch (_) {}
  }
}