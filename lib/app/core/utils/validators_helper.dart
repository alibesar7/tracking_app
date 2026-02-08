import '../values/user_error_mesagges.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return UserErrorMessages.emailRequired;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return UserErrorMessages.invalidEmail;
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return UserErrorMessages.passwordRequired;
    if (value.length < 6) return UserErrorMessages.least6Characters;
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return UserErrorMessages.passwordWithCapital;
    if (!RegExp(r'[0-9]').hasMatch(value))
      return UserErrorMessages.passwordWithNumber;
    return null;
  }

  static String? validateRePassword(String? value, String password) {
    if (value == null || value.isEmpty)
      return UserErrorMessages.confirmPassword;
    if (value != password) return UserErrorMessages.passwordDontMatch;
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return UserErrorMessages.phoneRequired;
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(value))
      return UserErrorMessages.invalidNumber;
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return UserErrorMessages.required;
    }
    if (value.length < 3) {
      return UserErrorMessages.least3Characters;
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)) {
      return UserErrorMessages.invalidName;
    }
    return null;
  }

  static String? validateRecipientName(String? value) {
    if (value == null || value.isEmpty) {
      return UserErrorMessages.requiredRecipientName;
    }
    if (value.length < 3) {
      return UserErrorMessages.least3Characters;
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)) {
      return UserErrorMessages.invalidRecipientName;
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return UserErrorMessages.requiredAddress;
    }
    if (value.length < 3) {
      return UserErrorMessages.least3Characters;
    }
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(value)) {
      return UserErrorMessages.invalidAddress;
    }
    return null;
  }
}
