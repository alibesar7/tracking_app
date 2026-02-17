import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_states.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/network/api_result.dart';
import '../../../domain/usecase/change_password_usecase.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  final ChangePasswordUsecase _changePasswordUseCase;
  final AuthStorage _authStorage;

  ChangePasswordCubit(this._changePasswordUseCase, this._authStorage)
    : super(ChangePasswordStates());

  final formKey = GlobalKey<FormState>();
  String currentPass = '';
  String newPass = '';
  String confirmPass = '';

  void doIntent(ChangePasswordIntent intent) {
    switch (intent) {
      case CurrentPasswordIntent():
        _currentPassword(intent.currentPass.toString());
      case NewPasswordIntent():
        _newPassword(intent.newPass.toString());
      case ConfirmPasswordIntent():
        _confirmPassword(intent.confirmPass.toString());
      case SubmitChangePasswordIntent():
        _submitChangePassword();
      case FormValidIntent():
        _formValid();
    }
  }

  void _formValid() {
    final isValid = formKey.currentState?.validate() ?? false;
    emit(state.copyWith(isFormValid: isValid));
  }

  void _currentPassword(String value) {
    currentPass = value;
    emit(state.copyWith(currentPassword: true, data: null));
  }

  void _newPassword(String value) {
    newPass = value;
    emit(state.copyWith(newPassword: true, data: null));
  }

  void _confirmPassword(String value) {
    confirmPass = value;
    emit(state.copyWith(confirmPassword: true, data: null));
  }

  Future<void> _submitChangePassword() async {
    emit(state.copyWith(data: Resource.loading()));
    final token = await _authStorage.getToken();

    if (token == null || token.isEmpty) {
      emit(state.copyWith(data: Resource.error("Token not found")));
      return;
    }

    ApiResult<ChangePasswordModel> response = await _changePasswordUseCase.call(
      token: 'Bearer $token',
      password: currentPass,
      newPassword: newPass,
    );

    switch (response) {
      case SuccessApiResult<ChangePasswordModel>():
        emit(state.copyWith(data: Resource.success(response.data)));

      case ErrorApiResult<ChangePasswordModel>():
        emit(state.copyWith(data: Resource.error(response.error)));
    }
  }
}
