abstract class LoginEvents {
  const LoginEvents();
}

class LoadMunicipalities extends LoginEvents {
  const LoadMunicipalities();
}

class UpdateLogin extends LoginEvents {
  const UpdateLogin();
}

class JoinGameEvent extends LoginEvents {
  final response;
  const JoinGameEvent({required this.response});
}