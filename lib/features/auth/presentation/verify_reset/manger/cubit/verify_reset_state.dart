part of 'verify_reset_cubit.dart';

class VerifyResetCodeState {
  final Resource<dynamic> resource;
  final bool isFormValid;
  final String code;
  final int resendCountdown;
  final bool canResend;

  const VerifyResetCodeState({
    required this.resource,
    required this.isFormValid,
    required this.code,
    required this.resendCountdown,
    required this.canResend,
  });

  factory VerifyResetCodeState.initial() => VerifyResetCodeState(
    resource: Resource.initial(),
    isFormValid: false,
    code: '',
    resendCountdown: 0,
    canResend: true,
  );

  VerifyResetCodeState copyWith({
    Resource<dynamic>? resource,
    bool? isFormValid,
    String? code,
    int? resendCountdown,
    bool? canResend,
  }) {
    return VerifyResetCodeState(
      resource: resource ?? this.resource,
      isFormValid: isFormValid ?? this.isFormValid,
      code: code ?? this.code,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      canResend: canResend ?? this.canResend,
    );
  }
}
