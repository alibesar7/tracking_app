import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/usecase/resertpassword_usecase.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/reset_password_intents.dart';
import '../../../../../app/config/base_state/base_state.dart';
import '../../../../../app/core/network/api_result.dart';
import '../../../../../app/core/utils/validators_helper.dart';


part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUsecase _resetPasswordUseCase;
  final String email;

  ResetPasswordCubit(@factoryParam this.email, this._resetPasswordUseCase)
    : super(ResetPasswordState.initial(email: email));

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();

  void doIntent(ChangePasswordIntent intent) {
    switch (intent) {
      case FormChangedIntent():
        _validateForm();
        break;
      case TogglePasswordVisibilityIntent():
        _togglePasswordVisibility();
        break;
      case SubmitChangePasswordIntent():
        _submitResetPassword();
        break;
    }
  }

  void _validateForm() {
    final isValid =
        newPasswordController.text.trim().isNotEmpty &&
        Validators.validatePassword(newPasswordController.text.trim()) == null;

    emit(state.copyWith(isFormValid: isValid));
  }

  void _togglePasswordVisibility() {
    emit(
      state.copyWith(togglePasswordVisibility: !state.togglePasswordVisibility),
    );
  }

  Future<void> _submitResetPassword() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(resource: Resource.loading()));

    final dto = ResetPasswordRequest(
      email: email, // Use the stored email
      newPassword: newPasswordController.text.trim(),
    );

    final result = await _resetPasswordUseCase(dto);

    if (result is SuccessApiResult<ResetPasswordEntity>) {
      emit(state.copyWith(resource: Resource.success(result.data)));
    } else if (result is ErrorApiResult<ResetPasswordEntity>) {
      emit(state.copyWith(resource: Resource.error(result.error)));
    } else {
      emit(state.copyWith(resource: Resource.error('Unexpected error')));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    newPasswordController.dispose();
    return super.close();
  }
}
