import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/validation/app_validation.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    EasyLocalization.logger.enableLevels = [];
  });

  group('Validators Unit Tests', () {
    group('firstNameValidator', () {
      test('should return required error for null or empty', () {
        expect(
          Validators.firstNameValidator(null),
          LocaleKeys.firstNameRequired.tr(),
        );
        expect(
          Validators.firstNameValidator(''),
          LocaleKeys.firstNameRequired.tr(),
        );
      });

      test(
        'should return invalid error for names < 3 or > 50 or with numbers',
        () {
          expect(
            Validators.firstNameValidator('Ab'),
            LocaleKeys.nameInvalid.tr(),
          );
          expect(
            Validators.firstNameValidator('Ab12'),
            LocaleKeys.nameInvalid.tr(),
          );
        },
      );

      test('should return null for valid first name', () {
        expect(Validators.firstNameValidator('Ahmed'), null);
      });
    });

    group('phoneValidator', () {
      test('should return required error for empty phone', () {
        expect(Validators.phoneValidator(''), LocaleKeys.phoneRequired.tr());
      });

      test('should return invalid for non-Egyptian format or wrong length', () {
        // Regex بيطلب يبدأ بـ +201 وبعدها [0-2, 5] وبعدها 8 أرقام
        expect(
          Validators.phoneValidator('01012345678'),
          LocaleKeys.phoneInvalid.tr(),
        ); // ناقص الـ +20
        expect(
          Validators.phoneValidator('+201312345678'),
          LocaleKeys.phoneInvalid.tr(),
        ); // رقم 3 مش موجود في الـ range
      });

      test('should return null for valid Egyptian phone (+2010...)', () {
        expect(Validators.phoneValidator('+201012345678'), null);
      });
    });

    group('passwordValidator', () {
      test(
        'should validate length, capital, small, number, and special char',
        () {
          expect(
            Validators.passwordValidator(''),
            LocaleKeys.passwordRequired.tr(),
          );
          expect(
            Validators.passwordValidator('123ab'),
            LocaleKeys.passwordLengthInvalid.tr(),
          );
          expect(
            Validators.passwordValidator('abcdef123!'),
            LocaleKeys.passwordUpperLetterInvalid.tr(),
          );
          expect(
            Validators.passwordValidator('ABCDEF123!'),
            LocaleKeys.passwordLowerLetterInvalid.tr(),
          );
          expect(
            Validators.passwordValidator('Abcdefgh!'),
            LocaleKeys.passwordNumbersInvalid.tr(),
          );
          expect(
            Validators.passwordValidator('Abcdefgh1'),
            LocaleKeys.passwordSpecialCharInvalid.tr(),
          );
        },
      );

      test('should return null for strong password', () {
        expect(Validators.passwordValidator('Strong123!'), null);
      });
    });

    group('newPasswordValidator', () {
      test('should return error if same as current password', () {
        const currentPass = 'OldPass123!';
        expect(
          Validators.newPasswordValidator(currentPass, currentPass),
          LocaleKeys.cannotBeSame.tr(),
        );
      });
    });

    group('confirmPasswordValidator', () {
      test('should return error if passwords do not match', () {
        expect(
          Validators.confirmPasswordValidator('Pass1', 'Pass2'),
          LocaleKeys.passwordsDoNotMatch.tr(),
        );
      });
    });

    group('emailValidator', () {
      test('should return invalid for wrong email formats', () {
        expect(
          Validators.emailValidator('test@'),
          LocaleKeys.emailInvalid.tr(),
        );
        expect(
          Validators.emailValidator('test@domain'),
          LocaleKeys.emailInvalid.tr(),
        );
      });

      test('should return null for valid email', () {
        expect(Validators.emailValidator('user@example.com'), null);
      });
    });

    group('genderValidator', () {
      test('should return error if gender is not selected', () {
        expect(
          Validators.genderValidator(null),
          LocaleKeys.genderRequired.tr(),
        );
        expect(Validators.genderValidator(''), LocaleKeys.genderRequired.tr());
      });
    });
  });
}
