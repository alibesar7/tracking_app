import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';

void main() {
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginRequest = LoginRequest(email: tEmail, password: tPassword);

  group('LoginRequest', () {
    test('should be a subclass of LoginRequest entity', () async {
      // assert
      expect(tLoginRequest, isA<LoginRequest>());
    });

    test('fromJson should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "email": tEmail,
        "password": tPassword,
      };

      // act
      final result = LoginRequest.fromJson(jsonMap);

      // assert
      expect(result.email, tEmail);
      expect(result.password, tPassword);
    });

    test('toJson should return a JSON map containing proper data', () async {
      // act
      final result = tLoginRequest.toJson();

      // assert
      final expectedMap = {"email": tEmail, "password": tPassword};
      expect(result, expectedMap);
    });
  });
}
