part of 'forget_pass_cubit.dart';

class ForgetPasswordState extends Equatable {
  final Resource<ForgetPasswordEntitiy> resource;
  final bool isFormValid;

  const ForgetPasswordState({
    required this.resource,
    required this.isFormValid,
  });

  factory ForgetPasswordState.initial() =>
      ForgetPasswordState(resource: Resource.initial(), isFormValid: false);

  ForgetPasswordState copyWith({
    Resource<ForgetPasswordEntitiy>? resource,
    bool? isFormValid,
  }) {
    return ForgetPasswordState(
      resource: resource ?? this.resource,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [resource, isFormValid];
}
