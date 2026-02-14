import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class Validators {
  static bool notEmpty(String? text) => text != null && text.trim().isNotEmpty;

  static String? firstNameValidator(String? val) {
    RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]{3,50}$');
    if (val == null || val.isEmpty) {
      return LocaleKeys.firstNameRequired.tr();
    } else if (!nameRegExp.hasMatch(val)) {
      return LocaleKeys.nameInvalid.tr();
    } else {
      return null;
    }
  }

  static String? lastNameValidator(String? val) {
    RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]{3,50}$');
    if (val == null || val.isEmpty) {
      return LocaleKeys.lastNameRequired.tr();
    } else if (!nameRegExp.hasMatch(val)) {
      return LocaleKeys.nameInvalid.tr();
    } else {
      return null;
    }
  }

  static String? phoneValidator(String? val) {
    RegExp phoneRegExp = RegExp(r'^\+201[0-2,5][0-9]{8}$');
    if (val == null || val.isEmpty) {
      return LocaleKeys.phoneRequired.tr();
    } else if (!phoneRegExp.hasMatch(val)) {
      return LocaleKeys.phoneInvalid.tr();
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? val) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.passwordRequired.tr();
    } else if (val.length < 6) {
      return LocaleKeys.passwordLengthInvalid.tr();
    } else if (!val.contains(RegExp(r'[A-Z]'))) {
      return LocaleKeys.passwordUpperLetterInvalid.tr();
    } else if (!val.contains(RegExp(r'[a-z]'))) {
      return LocaleKeys.passwordLowerLetterInvalid.tr();
    } else if (!val.contains(RegExp(r'[0-9]'))) {
      return LocaleKeys.passwordNumbersInvalid.tr();
    } else if (!val.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
      return LocaleKeys.passwordSpecialCharInvalid.tr();
    }
    return null;
  }

  static String? confirmPasswordValidator(String? val, String? pass) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.confirmPasswordRequired.tr();
    } else if (val != pass) {
      return LocaleKeys.passwordsDoNotMatch.tr();
    }
    return null;
  }

  static String? emailValidator(String? val) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (val == null || val.isEmpty) {
      return LocaleKeys.emailRequired.tr();
    } else if (!emailRegExp.hasMatch(val)) {
      return LocaleKeys.emailInvalid.tr();
    } else {
      return null;
    }
  }

  static String? genderValidator(String? val) {
    if (val == null || val.isEmpty) {
      return LocaleKeys.genderRequired.tr();
    } else {
      return null;
    }
  }
}
