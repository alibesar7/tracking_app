import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/resertpassword_usecase.dart';

import 'forgetpassword_usecase_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockRepo;
  late ResetPasswordUsecase usecase;

  setUpAll(() {
    provideDummy<ApiResult<ResetPasswordEntity>>(
      SuccessApiResult<ResetPasswordEntity>(
        data: ResetPasswordEntity(token: '', message: ''),
      ),
    );
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    usecase = ResetPasswordUsecase(mockRepo);
  });

  group("ResetPasswordUsecase", () {
    final request = ResetPasswordRequest(
      email: "test@mail.com",
      newPassword: "12345678",
    );

    test("returns SuccessApiResult when repo succeeds", () async {
      final entity = ResetPasswordEntity(
        token: "abc123",
        message: "Password reset",
      );

      when(mockRepo.resetPassword(request)).thenAnswer(
        (_) async => SuccessApiResult<ResetPasswordEntity>(data: entity),
      );

      final result = await usecase.call(request);

      expect(result, isA<SuccessApiResult<ResetPasswordEntity>>());
      expect((result as SuccessApiResult).data.token, "abc123");

      verify(mockRepo.resetPassword(request)).called(1);
    });

    test("returns ErrorApiResult when repo fails", () async {
      when(mockRepo.resetPassword(request)).thenAnswer(
        (_) async => ErrorApiResult<ResetPasswordEntity>(error: "Server error"),
      );

      final result = await usecase.call(request);

      expect(result, isA<ErrorApiResult<ResetPasswordEntity>>());
      expect((result as ErrorApiResult).error, "Server error");

      verify(mockRepo.resetPassword(request)).called(1);
    });
  });
}
