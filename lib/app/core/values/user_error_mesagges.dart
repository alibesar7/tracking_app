import 'package:easy_localization/easy_localization.dart';
import '../../../generated/locale_keys.g.dart';

class UserErrorMessages {
  // Server Errors //////////////////////////////////////////////////////////////////////

  static String get connectionTimeout => LocaleKeys.connectionTimeout.tr();

  static String get noInternet => LocaleKeys.noInternet.tr();

  static String get unauthorized => LocaleKeys.unauthorized.tr();

  static String get serverError => LocaleKeys.serverError.tr();

  static String get unknownError => LocaleKeys.unknownError.tr();

  // Validator Errors ////////////////////////////////////////////////////////////////////

  static String get invalidEmail => LocaleKeys.emailInvalid.tr();

  static String get weakPassword => LocaleKeys.weakPassword.tr();

  static String get emailRequired => LocaleKeys.emailRequired.tr();

  static String get passwordRequired => LocaleKeys.passwordRequired.tr();

  static String get passwordWithCapital => LocaleKeys.passwordWithCapital.tr();

  static String get passwordWithNumber => LocaleKeys.passwordWithNumber.tr();

  static String get passwordDontMatch => LocaleKeys.passwordDontMatch.tr();

  static String get confirmPassword => LocaleKeys.confirmPassword.tr();

  static String get phoneRequired => LocaleKeys.phoneRequired.tr();

  static String get invalidNumber => LocaleKeys.invalidNumber.tr();

  static String get required => LocaleKeys.required.tr();

  static String get least3Characters => LocaleKeys.least3Characters.tr();

  static String get least6Characters => LocaleKeys.least6Characters.tr();

  static String get invalidName => LocaleKeys.invalidName.tr();

  static String get invalidRecipientName =>
      LocaleKeys.invalidRecipientName.tr();

  static String get invalidAddress => LocaleKeys.invalidAddress.tr();

  static String get requiredRecipientName =>
      LocaleKeys.invalidRecipientName.tr();

  static String get requiredAddress => LocaleKeys.invalidAddress.tr();
  static String get requiredCity => LocaleKeys.requiredCity.tr();

  static String get requiredArea => LocaleKeys.requiredArea.tr();
}
