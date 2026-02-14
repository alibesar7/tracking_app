part of 'reset_password_cubit.dart';

class ResetPasswordState {
  final Resource<ResetPasswordEntity> resource;
  final bool isFormValid;
  final bool togglePasswordVisibility;
  final String email;

  const ResetPasswordState({
    required this.resource,
    required this.isFormValid,
    required this.togglePasswordVisibility,
    required this.email,
  });

  factory ResetPasswordState.initial({String email = ''}) => ResetPasswordState(
    resource: Resource.initial(),
    isFormValid: false,
    togglePasswordVisibility: false,
    email: email,
  );

  ResetPasswordState copyWith({
    Resource<ResetPasswordEntity>? resource,
    bool? isFormValid,
    bool? togglePasswordVisibility,
    String? email,
  }) {
    return ResetPasswordState(
      resource: resource ?? this.resource,
      isFormValid: isFormValid ?? this.isFormValid,
      togglePasswordVisibility:
          togglePasswordVisibility ?? this.togglePasswordVisibility,
      email: email ?? this.email,
    );
  }
}
