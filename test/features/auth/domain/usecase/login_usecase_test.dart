import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepo])
void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepo mockAuthRepo;

  setUpAll(() {
    provideDummy<ApiResult<LoginResponse>>(
      SuccessApiResult(
        data: LoginResponse(token: 'dummy', message: 'dummy'),
      ),
    );
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(mockAuthRepo);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  group('LoginUseCase', () {
    test(
      'should return SuccessApiResult when repo call is successful',
      () async {
        // Arrange
        when(
          mockAuthRepo.login(tEmail, tPassword),
        ).thenAnswer((_) async => SuccessApiResult(data: tLoginResponse));

        // Act
        final result = await loginUseCase(tEmail, tPassword);

        // Assert
        expect(result, isA<SuccessApiResult<LoginResponse>>());
        expect(
          (result as SuccessApiResult<LoginResponse>).data,
          tLoginResponse,
        );
        verify(mockAuthRepo.login(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(mockAuthRepo);
      },
    );

    test('should return ErrorApiResult when repo call fails', () async {
      // Arrange
      const tErrorMessage = 'An error occurred';
      when(
        mockAuthRepo.login(tEmail, tPassword),
      ).thenAnswer((_) async => ErrorApiResult(error: tErrorMessage));

      // Act
      final result = await loginUseCase(tEmail, tPassword);

      // Assert
      expect(result, isA<ErrorApiResult<LoginResponse>>());
      expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);
      verify(mockAuthRepo.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    });
  });
}
