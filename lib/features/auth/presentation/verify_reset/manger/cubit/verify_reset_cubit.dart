import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';
import 'package:tracking_app/features/auth/domain/usecase/forgetpassword_usecase.dart';
import 'package:tracking_app/features/auth/domain/usecase/verifyreaset_usecase.dart';
import '../../../../../../app/config/base_state/base_state.dart';
import '../../../../../../app/core/network/api_result.dart';

part 'verify_reset_state.dart';
part 'verify_reset_intent.dart';

@injectable
class VerifyResetCodeCubit extends Cubit<VerifyResetCodeState> {
  final VerifyResetCodeUsecase _verifyUseCase;
  final ForgetPasswordUsecase _resendUseCase;
  final String email;
  Timer? _cooldownTimer;

  VerifyResetCodeCubit(
    this._verifyUseCase,
    this._resendUseCase,
    @factoryParam this.email,
  ) : super(VerifyResetCodeState.initial()) {
    _startCooldown(30);
  }

  void doIntent(VerifyResetCodeIntents intent) {
    switch (intent.runtimeType) {
      case FormChangedIntent:
        _validateForm((intent as FormChangedIntent).code);
        break;
      case SubmitVerifyCodeIntent:
        _submitCode();
        break;
      case ResendCodeIntent:
        _resendCode();
        break;
    }
  }

  void _validateForm(String code) {
    emit(state.copyWith(code: code, isFormValid: code.length == 6));
  }

  Future<void> _submitCode() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(resource: Resource.loading()));

    final result = await _verifyUseCase(state.code);

    if (result is SuccessApiResult<VerifyResetCodeEntity>) {
      emit(state.copyWith(resource: Resource.success(result.data)));
    } else if (result is ErrorApiResult<VerifyResetCodeEntity>) {
      emit(state.copyWith(resource: Resource.error(result.error)));
    } else {
      emit(state.copyWith(resource: Resource.error("Unexpected error")));
    }
  }

  Future<void> _resendCode() async {
    if (!state.canResend) return;
    _startCooldown(30);
    emit(state.copyWith(resource: Resource.loading(), canResend: false));

    final result = await _resendUseCase(email);

    if (result is SuccessApiResult<ForgetPasswordEntitiy>) {
      emit(state.copyWith(resource: Resource.success(result.data)));
    } else if (result is ErrorApiResult<ForgetPasswordEntitiy>) {
      emit(state.copyWith(resource: Resource.error(result.error)));
    } else {
      emit(state.copyWith(resource: Resource.error("Unexpected error")));
    }
  }

  void _startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    emit(state.copyWith(resendCountdown: seconds, canResend: false));

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendCountdown - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(resendCountdown: 0, canResend: true));
      } else {
        emit(state.copyWith(resendCountdown: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
