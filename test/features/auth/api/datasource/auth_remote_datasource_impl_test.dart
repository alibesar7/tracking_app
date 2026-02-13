import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/api/datasource/auth_remote_datasource_impl.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';

import 'auth_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  final tLoginRequest = LoginRequest(
    email: 'test@example.com',
    password: 'password123',
  );
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  setUpAll(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('AuthRemoteDataSourceImpl.login', () {
    test('should return SuccessApiResult when login is successful', () async {
      // Arrange
      when(mockApiClient.login(any)).thenAnswer((_) async => tLoginResponse);

      // Act
      final result = await dataSource.login(tLoginRequest);

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
        final result = await dataSource.login(tLoginRequest);

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
        final result = await dataSource.login(tLoginRequest);

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
        final result = await dataSource.login(tLoginRequest);

        // Assert
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect(
          (result as ErrorApiResult<LoginResponse>).error,
          tExceptionMessage,
        );
      },
    );
  });

  group("AuthRemoteDatasourceImpl.changePassword()", () {
    test('should return ApiSuccess when change password succeeds', () async {
      final fakeDto = ChangePasswordDto(
        message: 'Success',
        token: 'fake_token',
        error: 'error',
      );
      final fakeResponse = HttpResponse(
        fakeDto,
        Response(
          requestOptions: RequestOptions(path: '/drivers/change-password'),
          statusCode: 200,
        ),
      );
      when(
        mockApiClient.changePassword(any),
      ).thenAnswer((_) async => fakeResponse);

      final result =
          await dataSource.changePassword(
                password: 'Mm@123456',
                newPassword: "Mmmmmm@1",
              )
              as SuccessApiResult<ChangePasswordDto>;

      expect(result, isA<SuccessApiResult<ChangePasswordDto>>());
      expect(result.data.token, fakeDto.token);
      expect(result.data.message, fakeDto.message);
      verify(mockApiClient.changePassword(any)).called(1);
    });

    test(
      'should return ApiFailure when change password throws exception',
      () async {
        when(
          mockApiClient.changePassword(any),
        ).thenThrow(Exception('Network error'));

        final result =
            await dataSource.changePassword(
                  password: 'Mm@123456',
                  newPassword: "Mmmmmm@1",
                )
                as ErrorApiResult<ChangePasswordDto>;

        expect(result, isA<ErrorApiResult<ChangePasswordDto>>());
        expect(result.error.toString(), contains("Network error"));
        verify(mockApiClient.changePassword(any)).called(1);
      },
    );
  });
}
