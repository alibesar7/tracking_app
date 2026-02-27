sealed class LoginIntent {}

class PerformLogin extends LoginIntent {
  final String email;
  final String password;
  final bool rememberMe;

  PerformLogin({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

class ToggleRememberMe extends LoginIntent {
  final bool value;
  ToggleRememberMe(this.value);
}
