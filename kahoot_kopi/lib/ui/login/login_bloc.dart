import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kahoot_kopi/ui/login/login_events_states.dart';

// STATE

class LoginState {
  bool hasValidMunicipalityID;
  bool isLicensePlatePlant;

  LoginState({
    required this.hasValidMunicipalityID,
    required this.isLicensePlatePlant
  });

  LoginState copyWith({
    bool? isLicensePlatePlant,
    bool? hasValidMunicipalityID
  }) {
    return LoginState(
      isLicensePlatePlant: isLicensePlatePlant ?? this.isLicensePlatePlant,
      hasValidMunicipalityID: hasValidMunicipalityID ?? this.hasValidMunicipalityID
    );
  }
}

class UpdateLoginState extends LoginState {
  UpdateLoginState({
    required super.isLicensePlatePlant,
    required super.hasValidMunicipalityID
  });
}

// BLOC

class LoginBloc extends Bloc<LoginEvents, LoginState> {

  late BuildContext _buildContext;

  LoginBloc({required BuildContext buildContext})
      : super(LoginState(
      hasValidMunicipalityID: false,
      isLicensePlatePlant: false
  )) {
    _buildContext = buildContext;
    on<LoginEvents>(_onEvent);
  }

  void _onEvent(LoginEvents event, Emitter<LoginState> emit) async {

      emit(state.copyWith(
        // Update state properties here if needed
      ));
    }
  }