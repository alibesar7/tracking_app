import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/core/utils/validators_helper.dart';
import 'package:tracking_app/app/core/values/user_error_mesagges.dart';

void main() {
  group('Validators Tests', () {
    group('validateEmail', () {
      test('should return error if email is empty', () {
        expect(Validators.validateEmail(''), UserErrorMessages.emailRequired);
        expect(Validators.validateEmail(null), UserErrorMessages.emailRequired);
      });

      test('should return error if email format is invalid', () {
        expect(
          Validators.validateEmail('test'),
          UserErrorMessages.invalidEmail,
        );
        expect(
          Validators.validateEmail('test@'),
          UserErrorMessages.invalidEmail,
        );
        expect(
          Validators.validateEmail('test@domain'),
          UserErrorMessages.invalidEmail,
        );
      });

      test('should return null if email is valid', () {
        expect(Validators.validateEmail('test@example.com'), null);
      });
    });

    group('validatePassword', () {
      test('should return error if password is empty', () {
        expect(
          Validators.validatePassword(''),
          UserErrorMessages.passwordRequired,
        );
      });

      test('should return error if password < 6 characters', () {
        expect(
          Validators.validatePassword('Ab1'),
          UserErrorMessages.least6Characters,
        );
      });

      test('should return error if no capital letter', () {
        expect(
          Validators.validatePassword('abc12345'),
          UserErrorMessages.passwordWithCapital,
        );
      });

      test('should return error if no number', () {
        expect(
          Validators.validatePassword('Abcdefgh'),
          UserErrorMessages.passwordWithNumber,
        );
      });

      test('should return null if password is valid', () {
        expect(Validators.validatePassword('Password123'), null);
      });
    });

    group('validateRePassword', () {
      test('should return error if confirm password is empty', () {
        expect(
          Validators.validateRePassword('', 'Password123'),
          UserErrorMessages.confirmPassword,
        );
      });

      test('should return error if passwords do not match', () {
        expect(
          Validators.validateRePassword('123', '456'),
          UserErrorMessages.passwordDontMatch,
        );
      });

      test('should return null if passwords match', () {
        expect(Validators.validateRePassword('Pass123', 'Pass123'), null);
      });
    });

    group('validatePhone', () {
      test('should return error if phone is empty', () {
        expect(Validators.validatePhone(''), UserErrorMessages.phoneRequired);
      });

      test(
        'should return error if phone format is invalid (Egyptian format)',
        () {
          expect(
            Validators.validatePhone('12345678901'),
            UserErrorMessages.invalidNumber,
          ); // No 01 at start
          expect(
            Validators.validatePhone('0101234567'),
            UserErrorMessages.invalidNumber,
          ); // Too short
        },
      );

      test('should return null if phone is valid', () {
        expect(Validators.validatePhone('01012345678'), null);
        expect(Validators.validatePhone('01112345678'), null);
      });
    });

    group('validateName / RecipientName / Address', () {
      test('validateName should catch special characters and length', () {
        expect(
          Validators.validateName('ab'),
          UserErrorMessages.least3Characters,
        );
        expect(Validators.validateName('John@'), UserErrorMessages.invalidName);
        expect(Validators.validateName('John Doe'), null);
      });

      test('validateRecipientName should return specific error messages', () {
        expect(
          Validators.validateRecipientName(''),
          UserErrorMessages.requiredRecipientName,
        );
        expect(
          Validators.validateRecipientName('Al!'),
          UserErrorMessages.invalidRecipientName,
        );
      });

      test('validateAddress should return specific error messages', () {
        expect(
          Validators.validateAddress(''),
          UserErrorMessages.requiredAddress,
        );
        expect(
          Validators.validateAddress('Cairo#5'),
          UserErrorMessages.invalidAddress,
        );
        expect(Validators.validateAddress('Maadi, Cairo'), null);
      });
    });
  });
}
