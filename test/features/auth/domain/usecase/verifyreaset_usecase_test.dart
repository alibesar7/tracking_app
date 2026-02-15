import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/verifyreaset_usecase.dart';

import 'forgetpassword_usecase_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockRepo;
  late VerifyResetCodeUsecase usecase;

  setUpAll(() {
    provideDummy<ApiResult<VerifyResetCodeEntity>>(
      SuccessApiResult<VerifyResetCodeEntity>(
        data: VerifyResetCodeEntity(status: ''),
      ),
    );
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    usecase = VerifyResetCodeUsecase(mockRepo);
  });

  group("VerifyResetCodeUsecase", () {
    const code = "123456";

    test("returns SuccessApiResult when repo succeeds", () async {
      final entity = VerifyResetCodeEntity(status: "verified");

      when(mockRepo.verifyResetCode(code)).thenAnswer(
        (_) async => SuccessApiResult<VerifyResetCodeEntity>(data: entity),
      );

      final result = await usecase.call(code);

      expect(result, isA<SuccessApiResult<VerifyResetCodeEntity>>());
      expect((result as SuccessApiResult).data.status, "verified");

      verify(mockRepo.verifyResetCode(code)).called(1);
    });

    test("returns ErrorApiResult when repo fails", () async {
      when(mockRepo.verifyResetCode(code)).thenAnswer(
        (_) async =>
            ErrorApiResult<VerifyResetCodeEntity>(error: "Invalid code"),
      );

      final result = await usecase.call(code);

      expect(result, isA<ErrorApiResult<VerifyResetCodeEntity>>());
      expect((result as ErrorApiResult).error, "Invalid code");

      verify(mockRepo.verifyResetCode(code)).called(1);
    });
  });
}
