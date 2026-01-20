// EVENTS
abstract class PinEvents {
  const PinEvents();
}

class CheckPinEvent extends PinEvents {
  final String pin;
  const CheckPinEvent({required this.pin});
}

class EnterNicknameEvent extends PinEvents {
  final String nickname;
  const EnterNicknameEvent({required this.nickname});
}

class DropdownSelected extends PinEvents {
  final String selected;
  const DropdownSelected({required this.selected});
}


// STATES
abstract class PinState {
  const PinState();
}

class EnterPinState extends PinState {
  final bool isLoading;
  final String? errorMessage;
  
  const EnterPinState({
    this.isLoading = false,
    this.errorMessage,
  });
}

class EnterNicknameState extends PinState {
  final String pin;
  
  const EnterNicknameState({required this.pin});
}

class BeginGameState extends PinState {
  final String pin;
  final String nickname;
  final String quizSessionId;
  
  const BeginGameState({
    required this.pin,
    required this.nickname,
    required this.quizSessionId,
  });
}