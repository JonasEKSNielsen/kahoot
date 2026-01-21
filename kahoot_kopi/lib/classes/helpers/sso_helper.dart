
class GoogleConfig {
  // Stjålet fra mr miyagi
  static const String webClientId = '651368027146-3afigsduknudq3b8vpm1gvja3dq3qabc.apps.googleusercontent.com';
}

/// GitHub OAuth konfiguration
class GitHubConfig {

  // Stjålet fra mr miyagi
  static const String clientId = 'Ov23liuASB3UvtR9nAFw';
  static const String authorizationUrl = 'https://github.com/login/oauth/authorize';
  static const List<String> scopes = ['user:email'];
  
  static String getCallbackUrl(String baseUrl) {
    return '$baseUrl/api/auth/github/callback';
  }
}