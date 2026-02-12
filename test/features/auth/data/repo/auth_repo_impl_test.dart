import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late AuthRepoImp authRepo;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUpAll(() {
    provideDummy<ApiResult<LoginResponse>>(
      SuccessApiResult(
        data: LoginResponse(token: 'dummy', message: 'dummy'),
      ),
    );
  });

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepo = AuthRepoImp(mockAuthRemoteDataSource);
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
          mockAuthRemoteDataSource.login(any),
        ).thenAnswer((_) async => SuccessApiResult(data: tLoginResponse));

        // Act
        final result = await authRepo.login(tEmail, tPassword);

        // Assert
        expect(result, isA<SuccessApiResult<LoginResponse>>());
        expect(
          (result as SuccessApiResult<LoginResponse>).data,
          tLoginResponse,
        );
        verify(mockAuthRemoteDataSource.login(any)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );

    test(
      'should return ErrorApiResult when remote data source call fails',
      () async {
        // Arrange
        const tErrorMessage = 'An error occurred';
        when(
          mockAuthRemoteDataSource.login(any),
        ).thenAnswer((_) async => ErrorApiResult(error: tErrorMessage));

        // Act
        final result = await authRepo.login(tEmail, tPassword);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);
        verify(mockAuthRemoteDataSource.login(any)).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });
}
