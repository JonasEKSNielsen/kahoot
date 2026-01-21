import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import '../../classes/helpers/api.dart';
import '../../classes/objects/oauth_response.dart';
import '../../classes/objects/path.dart';
import 'my_page_events_states.dart';
import '../../classes/helpers/sso_helper.dart';

class MyPageBloc extends Bloc<MyPageEvents, MyPageState> {
  final _secureStorage = const FlutterSecureStorage();
  late final GoogleSignIn _googleSignIn;
  
  static const List<String> scopes = <String>[
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  MyPageBloc({
    GoogleSignIn? googleSignIn,
  }) : super(const NotLoginState()) {
    on<LoginEvent>(_onLogin);
    on<GithubLoginEvent>(_onGithubLogin);
    on<GoogleLoginEvent>(_onGoogleLogin);
    on<SignOutEvent>(_onSignOut);
    on<LoginSuccessEvent>(_onLoginSuccess);

    _googleSignIn = googleSignIn ??
        GoogleSignIn(
          scopes: scopes,
          clientId: GoogleConfig.webClientId,
        );
    
    // Check if user is logged in
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final storedResponse = await _secureStorage.read(key: 'oauth_response');
      if (storedResponse != null) {
        final jsonResponse = jsonDecode(storedResponse) as Map<String, dynamic>;
        final oauthResponse = OAuthResponse.fromJson(jsonResponse);
        
        // Check if token is valid
        if (oauthResponse.expires.isAfter(DateTime.now())) {
          add(LoginSuccessEvent(oauthResponse: oauthResponse));
        } else {
          // Token expired, clear storage
          await _clearSecureStorage();
        }
      }
    } catch (_) {}
  }

  Future<void> _onLogin(LoginEvent event, Emitter<MyPageState> emit) async {
    try {      
      emit(GoogleLoginLoadingState());
      debugPrint('Login ${event.email} ${event.password}');
      
      emit(const NotLoginState());
    } catch (e) {
      emit(LoginErrorState(message: 'Login failed: $e'));
    }
  }
  
  Future<void> _onGithubLogin(GithubLoginEvent event, Emitter<MyPageState> emit) async {
    try {
      emit(GoogleLoginLoadingState());
            
      debugPrint('Github Login');
      
      emit(const NotLoginState());
    } catch (e) {
      emit(LoginErrorState(message: 'GitHub login failed: $e'));
    }
  }

  Future<void> _onGoogleLogin(GoogleLoginEvent event, Emitter<MyPageState> emit) async {
    try {
      emit(GoogleLoginLoadingState());
      
      final user = await _googleSignIn.signIn();
      
      if (user == null) {
        emit(LoginErrorState(message: 'Google login cancelled'));
        return;
      }

      // Send token to backend and store
      await _sendAuthTokenToBackend(user, emit);
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      emit(LoginErrorState(message: 'Google login failed: $e'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<MyPageState> emit) async {
    try {
      await _clearSecureStorage();
      await _googleSignIn.signOut();
      emit(const NotLoginState());
    } catch (e) {
      emit(LoginErrorState(message: 'ERROR: $e'));
    }
  }

  Future<void> _onLoginSuccess(LoginSuccessEvent event, Emitter<MyPageState> emit) async {
    emit(LoginSuccessState(
      email: event.oauthResponse.user.email,
      name: event.oauthResponse.user.username,
      oauthResponse: event.oauthResponse,
    ));
  }

  Future<void> _sendAuthTokenToBackend(GoogleSignInAccount user, Emitter<MyPageState> emit) async {
    try {
      final authentication = await user.authentication;
      
      // Send access token to api
      final oauthResponse = await _authenticate(
        provider: 'Google',
        accessToken: authentication.accessToken ?? '',
      );
      
      // Save to secure storage
      await _secureStorage.write(
        key: 'auth_token',
        value: oauthResponse.token,
      );
      await _secureStorage.write(
        key: 'refresh_token',
        value: oauthResponse.refreshToken,
      );
      await _secureStorage.write(
        key: 'user_email',
        value: oauthResponse.user.email,
      );
      await _secureStorage.write(
        key: 'user_id',
        value: oauthResponse.user.id.toString(),
      );
      
      emit(LoginSuccessState(
        email: oauthResponse.user.email,
        name: oauthResponse.user.username,
        oauthResponse: oauthResponse,
      ));
    } catch (e) {
      emit(LoginErrorState(message: 'Error: $e'));
    }
  }

  Future<void> _clearSecureStorage() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'refresh_token');
      await _secureStorage.delete(key: 'user_email');
      await _secureStorage.delete(key: 'user_id');
    } catch (e) {
      debugPrint('Error clearing secure storage: $e');
    }
  }

  Future<OAuthResponse> _authenticate({
    required String provider,
    required String accessToken,
  }) async {
    try {
      final response = await API.postRequest(ApiPath.authOAuthLogin, {
        'provider': provider,
        'accessToken': accessToken,
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return OAuthResponse.fromJson(jsonResponse);
      } else {
        throw Exception('OAuth authentication failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('OAuth authentication error: $e');
    }
  }
}