import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/api/datasource/auth_remote_datasource_impl.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';

import 'auth_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSource;
  late MockApiClient mockApiClient;
  final tLoginRequest = LoginRequest(
    email: 'test@example.com',
    password: 'password123',
  );
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('AuthRemoteDataSourceImpl', () {
    test('should return SuccessApiResult when login is successful', () async {
      // Arrange
      when(mockApiClient.login(any)).thenAnswer((_) async => tLoginResponse);

      // Act
      final result = await authRemoteDataSource.login(tLoginRequest);

      // Assert
      expect(result, isA<SuccessApiResult<LoginResponse>>());
      expect((result as SuccessApiResult<LoginResponse>).data, tLoginResponse);
      verify(mockApiClient.login(tLoginRequest)).called(1);
    });

    test(
      'should return ErrorApiResult with "wrongEmailOrPassword" on 401 error',
      () async {
        // Arrange
        when(mockApiClient.login(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
            ),
          ),
        );

        // Act
        final result = await authRemoteDataSource.login(tLoginRequest);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect(
          (result as ErrorApiResult<LoginResponse>).error,
          'wrongEmailOrPassword',
        );
      },
    );

    test(
      'should return ErrorApiResult with message from response on other DioErrors',
      () async {
        // Arrange
        const tErrorMessage = 'Some other error';
        when(mockApiClient.login(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
              data: {'message': tErrorMessage},
            ),
          ),
        );

        // Act
        final result = await authRemoteDataSource.login(tLoginRequest);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);
      },
    );

    test(
      'should return ErrorApiResult with exception message on unknown error',
      () async {
        // Arrange
        const tExceptionMessage = 'Exception: Unknown error';
        when(mockApiClient.login(any)).thenThrow(Exception('Unknown error'));

        // Act
        final result = await authRemoteDataSource.login(tLoginRequest);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect(
          (result as ErrorApiResult<LoginResponse>).error,
          tExceptionMessage,
        );
      },
    );
  });
}
