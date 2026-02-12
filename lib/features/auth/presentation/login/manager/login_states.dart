import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';

class LoginStates {
  final Resource<LoginResponse> loginResource;
  final bool rememberMe;

  LoginStates({Resource<LoginResponse>? loginResource, this.rememberMe = false})
    : loginResource = loginResource ?? Resource.initial();

  LoginStates copyWith({
    Resource<LoginResponse>? loginResource,
    bool? rememberMe,
    String? validationError,
  }) {
    return LoginStates(
      loginResource: loginResource ?? this.loginResource,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
