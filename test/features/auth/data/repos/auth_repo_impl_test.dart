import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late AuthRepoImp repo;

  setUpAll(() {
    mockDataSource = MockAuthRemoteDataSource();
    repo = AuthRepoImp(mockDataSource);
    provideDummy<ApiResult<LoginResponse>>(
      SuccessApiResult(
        data: LoginResponse(token: 'dummy', message: 'dummy'),
      ),
    );
    provideDummy<ApiResult<ChangePasswordDto>>(
      SuccessApiResult<ChangePasswordDto>(data: ChangePasswordDto()),
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  group('AuthRepoImpl', () {
    test(
      'should return SuccessApiResult when remote data source call is successful',
      () async {
        // Arrange
        when(
          mockDataSource.login(any),
        ).thenAnswer((_) async => SuccessApiResult(data: tLoginResponse));

        // Act
        final result = await repo.login(tEmail, tPassword);

        // Assert
        expect(result, isA<SuccessApiResult<LoginResponse>>());
        expect(
          (result as SuccessApiResult<LoginResponse>).data,
          tLoginResponse,
        );
        verify(mockDataSource.login(any)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return ErrorApiResult when remote data source call fails',
      () async {
        // Arrange
        const tErrorMessage = 'An error occurred';
        when(
          mockDataSource.login(any),
        ).thenAnswer((_) async => ErrorApiResult(error: tErrorMessage));

        // Act
        final result = await repo.login(tEmail, tPassword);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);
        verify(mockDataSource.login(any)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });

  group("AuthRepoImpl.changePassword()", () {
    test(
      'should return ApiSuccess when changePassword datasource succeeds',
      () async {
        final fakeDto = ChangePasswordDto(
          message: 'Success',
          token: 'fake_token',
          error: null,
        );

        when(
          mockDataSource.changePassword(
            token: ('fake_token'),
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async => SuccessApiResult<ChangePasswordDto>(data: fakeDto),
        );

        final result =
            await repo.changePassword(
                  token: 'fake_token',
                  password: 'Mm@123456',
                  newPassword: 'Mmmm@123',
                )
                as SuccessApiResult<ChangePasswordModel>;

        expect(result, isA<SuccessApiResult<ChangePasswordModel>>());
        expect(result.data.token, fakeDto.token);
        expect(result.data.message, fakeDto.message);
        verify(
          mockDataSource.changePassword(
            token: ('fake_token'),
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).called(1);
      },
    );

    test(
      'should return ApiFailure when changePassword datasource throws exception',
      () async {
        when(
          mockDataSource.changePassword(
            token: ('fake_token'),
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorApiResult<ChangePasswordDto>(error: 'Network error'),
        );

        final result =
            await repo.changePassword(
                  token: 'fake_token',
                  password: 'Mm@123456',
                  newPassword: 'Mmmm@123',
                )
                as ErrorApiResult<ChangePasswordModel>;

        expect(result, isA<ErrorApiResult<ChangePasswordModel>>());
        expect(result.error.toString(), contains("Network error"));
        verify(
          mockDataSource.changePassword(
            token: ('fake_token'),
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).called(1);
      },
    );
  });
}
