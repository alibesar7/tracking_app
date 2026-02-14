import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

class ChangePasswordStates {
  final Resource<ChangePasswordModel>? data;
  final bool? isFormValid;
  final bool? currentPassword;
  final bool? newPassword;
  final bool? confirmPassword;

  const ChangePasswordStates({
    this.data,
    this.isFormValid,
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  ChangePasswordStates copyWith({
    Resource<ChangePasswordModel>? data,
    bool? isFormValid,
    bool? currentPassword,
    bool? newPassword,
    bool? confirmPassword,
  }) {
    return ChangePasswordStates(
      data: data ?? this.data,
      isFormValid: isFormValid ?? this.isFormValid,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
