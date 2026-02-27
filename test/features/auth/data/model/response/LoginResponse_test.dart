import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';

void main() {
  const tMessage = 'Success';
  const tToken = 'token123';
  final tLoginResponse = LoginResponse(message: tMessage, token: tToken);

  group('LoginResponse', () {
    test('should be a subclass of LoginResponse entity', () async {
      // assert
      expect(tLoginResponse, isA<LoginResponse>());
    });

    test('fromJson should return a valid model', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "message": tMessage,
        "token": tToken,
      };

      // act
      final result = LoginResponse.fromJson(jsonMap);

      // assert
      expect(result.message, tMessage);
      expect(result.token, tToken);
    });

    test('toJson should return a JSON map containing proper data', () async {
      // act
      final result = tLoginResponse.toJson();

      // assert
      final expectedMap = {"message": tMessage, "token": tToken};
      expect(result, expectedMap);
    });
  });
}
