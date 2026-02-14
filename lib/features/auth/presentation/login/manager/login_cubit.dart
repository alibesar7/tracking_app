import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_intent.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_states.dart';
import 'package:tracking_app/app/core/network/api_result.dart';

import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  final LoginUseCase _loginUseCase;
  final AuthStorage _authStorage;

  LoginCubit(this._loginUseCase, this._authStorage) : super(LoginStates());

  Future<void> doAction(LoginIntent intent) async {
    switch (intent) {
      case PerformLogin(
        email: final email,
        password: final password,
        rememberMe: final rememberMe,
      ):
        await _performLogin(email, password, rememberMe);
      case ToggleRememberMe(value: final value):
        _toggleRememberMe(value);
    }
  }

  Future<void> _performLogin(
    String email,
    String password,
    bool rememberMe,
  ) async {
    emit(state.copyWith(loginResource: Resource.loading()));
    final result = await _loginUseCase(email, password);

    switch (result) {
      case SuccessApiResult<LoginResponse>(data: final data):
        if (data.token != null) {
          await _authStorage.saveToken(data.token!);
        }
        await _authStorage.setRememberMe(rememberMe);
        emit(state.copyWith(loginResource: Resource.success(data)));
      case ErrorApiResult<LoginResponse>(error: final error):
        emit(state.copyWith(loginResource: Resource.error(error)));
    }
  }

  void _toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }
}
