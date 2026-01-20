import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../my_page/my_page.dart';
import 'pin_page_events_states.dart';
import 'dart:async';
import 'dart:convert';
import '../../classes/helpers/api.dart';
import '../../classes/objects/join_session_dto.dart';
import '../../classes/objects/path.dart';
import '../../main.dart';
import '../quiz/quiz_page.dart';

class PinBloc extends Bloc<PinEvents, PinState> {
  Timer? _gameCheckTimer;

  PinBloc()
      : super(const EnterPinState()) {
    on<CheckPinEvent>(_onCheckPin);
    on<EnterNicknameEvent>(_onEnterNickname);
    on<DropdownSelected>(_onDropdownSelected);
  }

  Future<void> _onCheckPin(CheckPinEvent event, Emitter<PinState> emit) async {
    if (event.pin.isEmpty) {
      emit(const EnterPinState());
      return;
    }

    emit(const EnterPinState(isLoading: true));

    try {
      final response = await API.getRequestWithId(ApiPath.quizSessionPin, event.pin);
      
      if (response.statusCode == 200) {
        if (response.body.contains('"status":"Waiting"')) {
          emit(EnterNicknameState(pin: event.pin));
        } else {
          // GAME NOT AVALIABLE
          emit(EnterPinState(errorMessage: 'Game has already started or is not available'));
        }
      } else {
        // INVALID PIN
        emit(EnterPinState(errorMessage: 'Invalid game pin. Please try again'));
      }
    } catch (e) {
      // CONNECTION ISSUE
      emit(EnterPinState(errorMessage: 'Error checking pin: $e'));
    }
  }

  Future<void> _onEnterNickname(EnterNicknameEvent event, Emitter<PinState> emit) async {
    final currentState = state;
    if (currentState is EnterNicknameState) {
      Response response = await API.postRequest(
        ApiPath.quizSessionJoin,
        JoinSessionDto(
          pin: currentState.pin, 
          nickname: event.nickname,
        ).toJson(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonRes = json.decode(response.body);

        Navigator.pushAndRemoveUntil(
          globalNavigatorKey.currentContext!, 
          MaterialPageRoute(builder: (context) => QuizPage(
            pin: currentState.pin,
            nickname: event.nickname,
            quizSessionId: '${jsonRes['quizSessionId']}',
            participantId: jsonRes['id'],
          )),
          (route) => false,
        );
      }
    }
  }

  Future<void> _onDropdownSelected(DropdownSelected event, Emitter<PinState> emit) async {
    switch (event.selected) {
      case 'mypage':
        Navigator.push(globalNavigatorKey.currentContext!, MaterialPageRoute(builder: (context) => MyPage()));
        break;
    }
  }

  @override
  Future<void> close() {
    _gameCheckTimer?.cancel();
    return super.close();
  }
}