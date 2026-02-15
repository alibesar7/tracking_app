import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/forgetpassword_usecase.dart';

import 'forgetpassword_usecase_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockRepo;
  late ForgetPasswordUsecase usecase;

  setUpAll(() {
    provideDummy<ApiResult<ForgetPasswordEntitiy>>(
      SuccessApiResult<ForgetPasswordEntitiy>(
        data: ForgetPasswordEntitiy(message: '', info: ''),
      ),
    );
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    usecase = ForgetPasswordUsecase(mockRepo);
  });

  group("ForgetPasswordUsecase", () {
    const email = "test@mail.com";

    test("returns SuccessApiResult when repo succeeds", () async {
      final entity =
          ForgetPasswordEntitiy(message: "Email sent", info: "Check inbox");

      when(mockRepo.forgetPassword(email)).thenAnswer(
        (_) async => SuccessApiResult<ForgetPasswordEntitiy>(data: entity),
      );

      final result = await usecase.call(email);

      expect(result, isA<SuccessApiResult<ForgetPasswordEntitiy>>());
      expect((result as SuccessApiResult).data.message, "Email sent");

      verify(mockRepo.forgetPassword(email)).called(1);
    });

    test("returns ErrorApiResult when repo fails", () async {
      when(mockRepo.forgetPassword(email)).thenAnswer(
        (_) async =>
            ErrorApiResult<ForgetPasswordEntitiy>(error: "Network error"),
      );

      final result = await usecase.call(email);

      expect(result, isA<ErrorApiResult<ForgetPasswordEntitiy>>());
      expect((result as ErrorApiResult).error, "Network error");

      verify(mockRepo.forgetPassword(email)).called(1);
    });
  });
}
