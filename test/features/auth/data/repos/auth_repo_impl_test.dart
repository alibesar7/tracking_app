import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/data/model/response/change_password_dto.dart';
import 'package:tracking_app/features/auth/data/models/request/resetpassword_request.dart';
import 'package:tracking_app/features/auth/data/models/response/forgetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/resetpassword_response.dart';
import 'package:tracking_app/features/auth/data/models/response/verifyreset_response.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/features/auth/domain/models/resetpassword_entity.dart';
import 'package:tracking_app/features/auth/domain/models/verifyreset_entity.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late MockAuthRemoteDataSource datasource;
  late AuthRepoImpl repo;

  late MockAuthRemoteDataSource
  mockDataSource; // for login/changePassword tests
  late AuthRepoImpl repoImp;

  setUpAll(() {
    // Provide dummy data for generics
    provideDummy<ApiResult<ForgetpasswordResponse>>(
      SuccessApiResult<ForgetpasswordResponse>(
        data: ForgetpasswordResponse(message: '', info: ''),
      ),
    );
    provideDummy<ApiResult<VerifyresetResponse>>(
      SuccessApiResult<VerifyresetResponse>(
        data: VerifyresetResponse(status: ''),
      ),
    );
    provideDummy<ApiResult<ResetpasswordResponse>>(
      SuccessApiResult<ResetpasswordResponse>(
        data: ResetpasswordResponse(message: '', token: ''),
      ),
    );
    provideDummy<ApiResult<LoginResponse>>(
      SuccessApiResult(
        data: LoginResponse(token: 'dummy', message: 'dummy'),
      ),
    );
    provideDummy<ApiResult<ChangePasswordDto>>(
      SuccessApiResult<ChangePasswordDto>(data: ChangePasswordDto()),
    );
  });

  setUp(() {
    datasource = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(datasource);

    mockDataSource = MockAuthRemoteDataSource();
    repoImp = AuthRepoImpl(mockDataSource);
  });

  // ============================================================
  // forgetPassword
  // ============================================================
  group("forgetPassword", () {
    const email = "test@mail.com";

    test("should return SuccessApiResult when datasource succeeds", () async {
      final fakeDto = ForgetpasswordResponse(
        message: "Email sent",
        info: "Check inbox",
      );

      when(datasource.forgetPassword(any)).thenAnswer(
        (_) async => SuccessApiResult<ForgetpasswordResponse>(data: fakeDto),
      );

      final result = await repo.forgetPassword(email);

      expect(result, isA<SuccessApiResult<ForgetPasswordEntitiy>>());
      final data = (result as SuccessApiResult<ForgetPasswordEntitiy>).data;
      expect(data.message, "Email sent");
      expect(data.info, "Check inbox");

      verify(datasource.forgetPassword(any)).called(1);
    });

    test("should return ErrorApiResult when datasource fails", () async {
      when(datasource.forgetPassword(any)).thenAnswer(
        (_) async =>
            ErrorApiResult<ForgetpasswordResponse>(error: "Network error"),
      );

      final result = await repo.forgetPassword(email);

      expect(result, isA<ErrorApiResult<ForgetPasswordEntitiy>>());
      expect((result as ErrorApiResult).error, "Network error");

      verify(datasource.forgetPassword(any)).called(1);
    });
  });

  // ============================================================
  // verifyResetCode
  // ============================================================
  group("verifyResetCode", () {
    const code = "123456";

    test("should return SuccessApiResult when datasource succeeds", () async {
      final fakeDto = VerifyresetResponse(status: "verified");

      when(datasource.verifyResetCode(any)).thenAnswer(
        (_) async => SuccessApiResult<VerifyresetResponse>(data: fakeDto),
      );

      final result = await repo.verifyResetCode(code);

      expect(result, isA<SuccessApiResult<VerifyResetCodeEntity>>());
      final data = (result as SuccessApiResult<VerifyResetCodeEntity>).data;
      expect(data.status, "verified");

      verify(datasource.verifyResetCode(any)).called(1);
    });

    test("should return ErrorApiResult when datasource fails", () async {
      when(datasource.verifyResetCode(any)).thenAnswer(
        (_) async => ErrorApiResult<VerifyresetResponse>(error: "Invalid code"),
      );

      final result = await repo.verifyResetCode(code);

      expect(result, isA<ErrorApiResult<VerifyResetCodeEntity>>());
      expect((result as ErrorApiResult).error, "Invalid code");

      verify(datasource.verifyResetCode(any)).called(1);
    });
  });

  // ============================================================
  // resetPassword
  // ============================================================
  group("resetPassword", () {
    final request = ResetPasswordRequest(
      email: "test@mail.com",
      newPassword: "12345678",
    );

    test("should return SuccessApiResult when datasource succeeds", () async {
      final fakeDto = ResetpasswordResponse(
        message: "Password reset",
        token: "abc123",
      );

      when(datasource.resetPassword(request)).thenAnswer(
        (_) async => SuccessApiResult<ResetpasswordResponse>(data: fakeDto),
      );

      final result = await repo.resetPassword(request);

      expect(result, isA<SuccessApiResult<ResetPasswordEntity>>());
      final data = (result as SuccessApiResult<ResetPasswordEntity>).data;
      expect(data.message, "Password reset");
      expect(data.token, "abc123");

      verify(datasource.resetPassword(request)).called(1);
    });

    test("should return ErrorApiResult when datasource fails", () async {
      when(datasource.resetPassword(request)).thenAnswer(
        (_) async =>
            ErrorApiResult<ResetpasswordResponse>(error: "Server error"),
      );

      final result = await repo.resetPassword(request);

      expect(result, isA<ErrorApiResult<ResetPasswordEntity>>());
      expect((result as ErrorApiResult).error, "Server error");

      verify(datasource.resetPassword(request)).called(1);
    });
  });

  // ============================================================
  // login
  // ============================================================
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tLoginResponse = LoginResponse(token: 'token123', message: 'Success');

  group('AuthRepoImpl.login', () {
    test(
      'should return SuccessApiResult when remote data source call is successful',
      () async {
        when(
          mockDataSource.login(any),
        ).thenAnswer((_) async => SuccessApiResult(data: tLoginResponse));

        final result = await repoImp.login(tEmail, tPassword);

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
        const tErrorMessage = 'An error occurred';
        when(
          mockDataSource.login(any),
        ).thenAnswer((_) async => ErrorApiResult(error: tErrorMessage));

        final result = await repoImp.login(tEmail, tPassword);

        expect(result, isA<ErrorApiResult<LoginResponse>>());
        expect((result as ErrorApiResult<LoginResponse>).error, tErrorMessage);

        verify(mockDataSource.login(any)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });

  // ============================================================
  // changePassword
  // ============================================================
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
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async => SuccessApiResult<ChangePasswordDto>(data: fakeDto),
        );

        final result =
            await repoImp.changePassword(
                  password: 'Mm@123456',
                  newPassword: 'Mmmm@123',
                )
                as SuccessApiResult<ChangePasswordModel>;

        expect(result, isA<SuccessApiResult<ChangePasswordModel>>());
        expect(result.data.token, fakeDto.token);
        expect(result.data.message, fakeDto.message);

        verify(
          mockDataSource.changePassword(
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
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorApiResult<ChangePasswordDto>(error: 'Network error'),
        );

        final result =
            await repoImp.changePassword(
                  password: 'Mm@123456',
                  newPassword: 'Mmmm@123',
                )
                as ErrorApiResult<ChangePasswordModel>;

        expect(result, isA<ErrorApiResult<ChangePasswordModel>>());
        expect(result.error.toString(), contains("Network error"));

        verify(
          mockDataSource.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).called(1);
      },
    );
  });
}
