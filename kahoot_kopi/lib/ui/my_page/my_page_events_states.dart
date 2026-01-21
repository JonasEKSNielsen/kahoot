import '../../classes/objects/oauth_response.dart';

// EVENTS
abstract class MyPageEvents {
  const MyPageEvents();
}

class LoginEvent extends MyPageEvents {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
}

class GithubLoginEvent extends MyPageEvents {
  const GithubLoginEvent();
}

class GoogleLoginEvent extends MyPageEvents {
  const GoogleLoginEvent();
}

class SignOutEvent extends MyPageEvents {
  const SignOutEvent();
}

class LoginSuccessEvent extends MyPageEvents {
  final OAuthResponse oauthResponse;
  const LoginSuccessEvent({required this.oauthResponse});
}

// STATES
abstract class MyPageState {
  const MyPageState();
}

class NotLoginState extends MyPageState {
  
  const NotLoginState();
}

class GoogleLoginLoadingState extends MyPageState {
  const GoogleLoginLoadingState();
}

class LoginSuccessState extends MyPageState {
  final String email;
  final String name;
  final OAuthResponse oauthResponse;
  
  const LoginSuccessState({
    required this.email,
    required this.name,
    required this.oauthResponse,
  });
}

class LoginErrorState extends MyPageState {
  final String message;
  
  const LoginErrorState({required this.message});
}

