import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/api/datasource/auth_remote_datasource_impl.dart';
import 'package:tracking_app/features/auth/data/model/request/LoginRequest.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/models/request/forget_password_request.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/request/verifyreset_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';

import 'auth_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late AuthRemoteDataSourceImpl
  dataSource; // initialize for login/change password tests

  setUpAll(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockApiClient);
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  final forgetPasswordRequest = ForgetPasswordRequest(
    email: "test@example.com",
  );

  group("AuthRemoteDatasourceImpl.forgetPassword()", () {
    test(
      "returns SuccessApiResult when apiClient returns valid response",
      () async {
        final expectedResponse = ForgetpasswordResponse(
          message: "Password reset code sent to email",
        );
        final dioResponse = Response<ForgetpasswordResponse>(
          requestOptions: RequestOptions(path: '/forget-password'),
          data: expectedResponse,
          statusCode: 200,
        );
        final fakeHttpResponse = HttpResponse<ForgetpasswordResponse>(
          dioResponse.data!,
          dioResponse,
        );

        when(
          mockApiClient.forgetPassword(any),
        ).thenAnswer((_) async => fakeHttpResponse);

        final result = await authRemoteDataSourceImpl.forgetPassword(
          forgetPasswordRequest,
        );

        expect(result, isA<SuccessApiResult<ForgetpasswordResponse>>());
        final successResult =
            result as SuccessApiResult<ForgetpasswordResponse>;
        expect(successResult.data.message, "Password reset code sent to email");
        verify(mockApiClient.forgetPassword(any)).called(1);
      },
    );

    test("returns ErrorApiResult when apiClient throws Exception", () async {
      when(
        mockApiClient.forgetPassword(any),
      ).thenThrow(Exception("Network Error"));

      final result = await authRemoteDataSourceImpl.forgetPassword(
        forgetPasswordRequest,
      );

      expect(result, isA<ErrorApiResult>());
      final errorResult = result as ErrorApiResult;
      expect(errorResult.error, contains("Network Error"));
      verify(mockApiClient.forgetPassword(any)).called(1);
    });
  });

  group("AuthRemoteDatasourceImpl.resetPassword()", () {
    final resetPasswordRequest = ResetPasswordRequest(
      email: "test@example.com",
      newPassword: "12345678",
    );

    test(
      "returns SuccessApiResult when apiClient returns valid response",
      () async {
        final expectedResponse = ResetpasswordResponse(
          message: "Password reset successfully",
        );
        final dioResponse = Response<ResetpasswordResponse>(
          requestOptions: RequestOptions(path: '/reset-password'),
          data: expectedResponse,
          statusCode: 200,
        );
        final fakeHttpResponse = HttpResponse<ResetpasswordResponse>(
          dioResponse.data!,
          dioResponse,
        );

        when(
          mockApiClient.resetPassword(any),
        ).thenAnswer((_) async => fakeHttpResponse);

        final result = await authRemoteDataSourceImpl.resetPassword(
          resetPasswordRequest,
        );

        expect(result, isA<SuccessApiResult<ResetpasswordResponse>>());
        final successResult = result as SuccessApiResult<ResetpasswordResponse>;
        expect(successResult.data.message, "Password reset successfully");
        verify(mockApiClient.resetPassword(any)).called(1);
      },
    );

    test("returns ErrorApiResult when apiClient throws Exception", () async {
      when(
        mockApiClient.resetPassword(any),
      ).thenThrow(Exception("Reset failed"));

      final result = await authRemoteDataSourceImpl.resetPassword(
        resetPasswordRequest,
      );

      expect(result, isA<ErrorApiResult>());
      final errorResult = result as ErrorApiResult;
      expect(errorResult.error, contains("Reset failed"));
      verify(mockApiClient.resetPassword(any)).called(1);
    });
  });

  group("AuthRemoteDatasourceImpl.verifyResetCode()", () {
    final verifyResetCodeRequest = VerifyResetRequest(resetCode: "1234");

    test(
      "returns SuccessApiResult when apiClient returns valid response",
      () async {
        final expectedResponse = VerifyresetResponse(
          status: "Code verified successfully",
        );
        final dioResponse = Response<VerifyresetResponse>(
          requestOptions: RequestOptions(path: '/verify-reset-code'),
          data: expectedResponse,
          statusCode: 200,
        );
        final fakeHttpResponse = HttpResponse<VerifyresetResponse>(
          dioResponse.data!,
          dioResponse,
        );

        when(
          mockApiClient.verifyResetCode(any),
        ).thenAnswer((_) async => fakeHttpResponse);

        final result = await authRemoteDataSourceImpl.verifyResetCode(
          verifyResetCodeRequest,
        );

        expect(result, isA<SuccessApiResult<VerifyresetResponse>>());
        final successResult = result as SuccessApiResult<VerifyresetResponse>;
        expect(successResult.data.status, "Code verified successfully");
        verify(mockApiClient.verifyResetCode(any)).called(1);
      },
    );

    test("returns ErrorApiResult when apiClient throws Exception", () async {
      when(
        mockApiClient.verifyResetCode(any),
      ).thenThrow(Exception("Invalid code"));

      final result = await authRemoteDataSourceImpl.verifyResetCode(
        verifyResetCodeRequest,
      );

      expect(result, isA<ErrorApiResult>());
      final errorResult = result as ErrorApiResult;
      expect(errorResult.error, contains("Invalid code"));
      verify(mockApiClient.verifyResetCode(any)).called(1);
    });
  });

  // ---------- login ----------
  final tLoginRequest = LoginRequest(
    email: 'test@example.com',
    password: 'password123',
  );
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  group('AuthRemoteDataSourceImpl.login', () {
    test('should return SuccessApiResult when login is successful', () async {
      when(mockApiClient.login(any)).thenAnswer((_) async => tLoginResponse);
      final result = await dataSource.login(tLoginRequest);
      expect(result, isA<SuccessApiResult<LoginResponse>>());
      expect((result as SuccessApiResult<LoginResponse>).data, tLoginResponse);
      verify(mockApiClient.login(tLoginRequest)).called(1);
    });

    test(
      'should return ErrorApiResult with "wrongEmailOrPassword" on 401 error',
      () async {
        when(mockApiClient.login(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 401,
            ),
          ),
        );
        final result = await dataSource.login(tLoginRequest);
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
        final result = await dataSource.login(tLoginRequest);
        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);
      },
    );

    test(
      'should return ErrorApiResult with exception message on unknown error',
      () async {
        const tExceptionMessage = 'Exception: Unknown error';
        when(mockApiClient.login(any)).thenThrow(Exception('Unknown error'));
        final result = await dataSource.login(tLoginRequest);
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
