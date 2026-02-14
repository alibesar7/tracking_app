import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/api/datasource/auth_remote_datasource_impl.dart';
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
  late AuthRemoteDatasourceImpl authRemoteDataSourceImpl;

  setUpAll(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDatasourceImpl(mockApiClient);
  });

  final forgetPasswordRequest = ForgetPasswordRequest(
    email: "test@example.com",
  );

  group("AuthRemoteDatasourceImpl.forgetPassword()", () {

    test(
      "returns SuccessApiResult when apiClient returns valid response",
      () async {
        // ARRANGE
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

        when(mockApiClient.forgetPassword(any))
            .thenAnswer((_) async => fakeHttpResponse);

        // ACT
        final result = await authRemoteDataSourceImpl
            .forgetPassword(forgetPasswordRequest);

        // ASSERT
        expect(result, isA<SuccessApiResult<ForgetpasswordResponse>>());

        final successResult =
            result as SuccessApiResult<ForgetpasswordResponse>;

        expect(successResult.data.message,
            "Password reset code sent to email");

        verify(mockApiClient.forgetPassword(any)).called(1);
      },
    );

    test(
      "returns ErrorApiResult when apiClient throws Exception",
      () async {
        // ARRANGE
        when(mockApiClient.forgetPassword(any))
            .thenThrow(Exception("Network Error"));

        // ACT
        final result = await authRemoteDataSourceImpl
            .forgetPassword(forgetPasswordRequest);

        // ASSERT
        expect(result, isA<ErrorApiResult>());

        final errorResult = result as ErrorApiResult;
        expect(errorResult.error,
            contains("Network Error"));

        verify(mockApiClient.forgetPassword(any)).called(1);
      },
    );

group("AuthRemoteDatasourceImpl.resetPassword()", () {

  final resetPasswordRequest = ResetPasswordRequest(
    email: "test@example.com",
    newPassword: "12345678",
  );

  test(
    "returns SuccessApiResult when apiClient returns valid response",
    () async {
      // ARRANGE
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

      when(mockApiClient.resetPassword(any))
          .thenAnswer((_) async => fakeHttpResponse);

      // ACT
      final result = await authRemoteDataSourceImpl
          .resetPassword(resetPasswordRequest);

      // ASSERT
      expect(result, isA<SuccessApiResult<ResetpasswordResponse>>());

      final successResult =
          result as SuccessApiResult<ResetpasswordResponse>;

      expect(successResult.data.message,
          "Password reset successfully");

      verify(mockApiClient.resetPassword(any)).called(1);
    },
  );

  test(
    "returns ErrorApiResult when apiClient throws Exception",
    () async {
      // ARRANGE
      when(mockApiClient.resetPassword(any))
          .thenThrow(Exception("Reset failed"));

      // ACT
      final result = await authRemoteDataSourceImpl
          .resetPassword(resetPasswordRequest);

      // ASSERT
      expect(result, isA<ErrorApiResult>());

      final errorResult = result as ErrorApiResult;
      expect(errorResult.error, contains("Reset failed"));

      verify(mockApiClient.resetPassword(any)).called(1);
    },
  );
});

group("AuthRemoteDatasourceImpl.verifyResetCode()", () {

  final verifyResetCodeRequest = VerifyResetRequest(
    resetCode: "1234",
  );

  test(
    "returns SuccessApiResult when apiClient returns valid response",
    () async {
      // ARRANGE
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

      when(mockApiClient.verifyResetCode(any))
          .thenAnswer((_) async => fakeHttpResponse);

      // ACT
      final result = await authRemoteDataSourceImpl
          .verifyResetCode(verifyResetCodeRequest);

      // ASSERT
      expect(result, isA<SuccessApiResult<VerifyresetResponse>>());

      final successResult =
          result as SuccessApiResult<VerifyresetResponse>;

      expect(successResult.data.status,
          "Code verified successfully");

      verify(mockApiClient.verifyResetCode(any)).called(1);
    },
  );

  test(
    "returns ErrorApiResult when apiClient throws Exception",
    () async {
      // ARRANGE
      when(mockApiClient.verifyResetCode(any))
          .thenThrow(Exception("Invalid code"));

      // ACT
      final result = await authRemoteDataSourceImpl
          .verifyResetCode(verifyResetCodeRequest);

      // ASSERT
      expect(result, isA<ErrorApiResult>());

      final errorResult = result as ErrorApiResult;
      expect(errorResult.error, contains("Invalid code"));

      verify(mockApiClient.verifyResetCode(any)).called(1);
    },
  );
});






  });
}
