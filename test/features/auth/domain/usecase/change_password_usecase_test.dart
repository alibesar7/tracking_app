import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/change_password_usecase.dart';

import 'change_password_usecase_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockRepo;
  late ChangePasswordUsecase useCase;

  setUpAll(() {
    mockRepo = MockAuthRepo();
    useCase = ChangePasswordUsecase(mockRepo);
    provideDummy<ApiResult<ChangePasswordModel>>(
      SuccessApiResult<ChangePasswordModel>(data: ChangePasswordModel()),
    );
  });

  group("ChangePasswordUseCase", () {
    final fakeData = ChangePasswordModel(
      message: 'Success',
      token: 'fake_token',
      error: null,
    );
    test("returns SuccessApiResult when repos returns success", () async {
      when(
        mockRepo.changePassword(
          token: ('fake_token'),
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => SuccessApiResult<ChangePasswordModel>(data: fakeData),
      );

      final result =
          await useCase.call(
                token: 'fake_token',
                password: 'Test@123',
                newPassword: 'Test@1234',
              )
              as SuccessApiResult<ChangePasswordModel>;

      expect(result, isA<SuccessApiResult<ChangePasswordModel>>());
      expect(result.data.token, fakeData.token);
      expect(result.data.message, fakeData.message);
      verify(
        mockRepo.changePassword(
          token: 'fake_token',
          password: 'Test@123',
          newPassword: 'Test@1234',
        ),
      ).called(1);
    });

    test("returns ErrorApiResult when repos returns error", () async {
      when(
        mockRepo.changePassword(
          token: ('fake_token'),
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => ErrorApiResult<ChangePasswordModel>(
          error: 'change password failed',
        ),
      );

      final result =
          await useCase.call(
                token: 'fake_token',
                password: 'Test@123',
                newPassword: 'Test@1234',
              )
              as ErrorApiResult<ChangePasswordModel>;

      expect(result, isA<ErrorApiResult<ChangePasswordModel>>());
      expect(result.error, 'change password failed');
      verify(
        mockRepo.changePassword(
          token: 'fake_token',
          password: 'Test@123',
          newPassword: 'Test@1234',
        ),
      ).called(1);
    });
  });
}
