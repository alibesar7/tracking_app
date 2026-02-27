import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/usecase/forgetpassword_usecase.dart';

part 'forget_pass_state.dart';
part 'forget_pass_intents.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthStorage _authStorage;
  final ForgetPasswordUsecase _ForgetPasswordUsecase;

  ForgetPasswordCubit(this._ForgetPasswordUsecase, this._authStorage)
    : super(ForgetPasswordState.initial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void doIntent(ForgetPasswordIntents intent) {
    switch (intent) {
      case FormChangedIntent():
        _validateForm();
        break;
      case SubmitForgetPasswordIntent():
        _submitForgetPassword();
        break;
    }
  }

  void _validateForm() {
    final isEmailFilled = emailController.text.trim().isNotEmpty;
    emit(state.copyWith(isFormValid: isEmailFilled));
  }

  Future<void> _submitForgetPassword() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    emit(state.copyWith(resource: Resource.loading()));

    final result = await _ForgetPasswordUsecase(emailController.text.trim());

    if (result is SuccessApiResult<ForgetPasswordEntitiy>) {
      emit(state.copyWith(resource: Resource.success(result.data)));
    } else if (result is ErrorApiResult<ForgetPasswordEntitiy>) {
      emit(state.copyWith(resource: Resource.error(result.error)));
    } else {
      emit(state.copyWith(resource: Resource.error('Unexpected error')));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
