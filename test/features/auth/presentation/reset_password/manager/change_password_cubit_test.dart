import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/change_password_model.dart';
import 'package:tracking_app/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_states.dart';
import 'change_password_cubit_test.mocks.dart';

@GenerateMocks([ChangePasswordUsecase, AuthStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockChangePasswordUsecase mockUseCase;
  late MockAuthStorage mockAuthStorage;
  late ChangePasswordCubit cubit;

  setUpAll(() {
    mockUseCase = MockChangePasswordUsecase();
    mockAuthStorage = MockAuthStorage();
    provideDummy<ApiResult<ChangePasswordModel>>(
      SuccessApiResult(data: ChangePasswordModel()),
    );
  });
  setUp(() {
    cubit = ChangePasswordCubit(mockUseCase, mockAuthStorage);
  });
  tearDown(() async {
    await cubit.close();
  });
  group("Change password intent", () {
    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits loading then success when usecase returns SuccessApiResult',
      build: () {
        final fakeData = ChangePasswordModel(
          message: 'Success',
          token: 'fake_token',
          error: null,
        );
        when(mockAuthStorage.getToken()).thenAnswer((_) async => 'fake_token');
        when(
          mockUseCase.call(
            token: 'Bearer fake_token',
            password: 'Test@123',
            newPassword: 'Test@1234',
          ),
        ).thenAnswer(
          (_) async => SuccessApiResult<ChangePasswordModel>(data: fakeData),
        );
        return cubit;
      },

      act: (cubit) {
        cubit.doIntent(CurrentPasswordIntent(currentPass: 'Test@123'));
        cubit.doIntent(NewPasswordIntent(newPass: 'Test@1234'));
        cubit.doIntent(ConfirmPasswordIntent(confirmPass: 'Test@1234'));
        return cubit.doIntent(SubmitChangePasswordIntent());
      },
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.currentPassword,
          "currentPass",
          true,
        ),
        isA<ChangePasswordStates>().having(
          (s) => s.newPassword,
          "newPass",
          true,
        ),
        isA<ChangePasswordStates>().having(
          (s) => s.confirmPassword,
          "confirmPass",
          true,
        ),

        isA<ChangePasswordStates>().having(
          (s) => s.data?.status,
          "status",
          Status.loading,
        ),
        isA<ChangePasswordStates>()
            .having((s) => s.data?.status, "status", Status.success)
            .having((s) => s.data?.data?.token, "token", "fake_token")
            .having((s) => s.data!.data!.message, "message", "Success"),
      ],
      verify: (_) {
        verify(
          mockUseCase.call(
            token: 'Bearer fake_token',
            password: 'Test@123',
            newPassword: 'Test@1234',
          ),
        ).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits loading then error when usecase returns ErrorApiResult',
      build: () {
        when(mockAuthStorage.getToken()).thenAnswer((_) async => 'fake_token');
        when(
          mockUseCase.call(
            token: 'Bearer fake_token',
            password: 'Test@123',
            newPassword: 'Test@1234',
          ),
        ).thenAnswer(
          (_) async => ErrorApiResult<ChangePasswordModel>(
            error: 'Change password failed',
          ),
        );
        return cubit;
      },

      act: (cubit) {
        cubit.doIntent(CurrentPasswordIntent(currentPass: 'Test@123'));
        cubit.doIntent(NewPasswordIntent(newPass: 'Test@1234'));
        cubit.doIntent(ConfirmPasswordIntent(confirmPass: 'Test@1234'));
        return cubit.doIntent(SubmitChangePasswordIntent());
      },
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.currentPassword,
          "currentPass",
          true,
        ),
        isA<ChangePasswordStates>().having(
          (s) => s.newPassword,
          "newPass",
          true,
        ),
        isA<ChangePasswordStates>().having(
          (s) => s.confirmPassword,
          "confirmPass",
          true,
        ),

        isA<ChangePasswordStates>().having(
          (s) => s.data!.status,
          'status',
          Status.loading,
        ),
        isA<ChangePasswordStates>().having(
          (s) => s.data!.error,
          'error',
          contains('Change password failed'),
        ),
      ],

      verify: (_) {
        verify(
          mockUseCase.call(
            token: 'Bearer fake_token',
            password: 'Test@123',
            newPassword: 'Test@1234',
          ),
        ).called(1);
      },
    );
  });

  group('Text field changes', () {
    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits state with currentPass=true',
      build: () => cubit,
      act: (cubit) =>
          cubit.doIntent(CurrentPasswordIntent(currentPass: 'Test@123')),
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.currentPassword,
          'currentPassword',
          true,
        ),
      ],
      verify: (_) {
        expect(cubit.currentPass, 'Test@123');
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits state with newPassword=true',
      build: () => cubit,
      act: (cubit) => cubit.doIntent(NewPasswordIntent(newPass: 'Test@1234')),
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.newPassword,
          'newPassword',
          true,
        ),
      ],
      verify: (_) {
        expect(cubit.newPass, 'Test@1234');
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits state with confirmPassword=true',
      build: () => cubit,
      act: (cubit) =>
          cubit.doIntent(ConfirmPasswordIntent(confirmPass: 'Test@1234')),
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.confirmPassword,
          'confirmPassword',
          true,
        ),
      ],
      verify: (_) {
        expect(cubit.confirmPass, 'Test@1234');
      },
    );
  });

  group('Form Validation', () {
    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits isFormValid = false when confirm password does not match',
      build: () {
        cubit.currentPass = 'Test@123';
        cubit.newPass = 'Test@1234';
        cubit.confirmPass = 'Test@12345';
        return cubit;
      },
      act: (cubit) => cubit.doIntent(FormValidIntent()),
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.isFormValid,
          'isFormValid',
          false,
        ),
      ],
    );

    blocTest<ChangePasswordCubit, ChangePasswordStates>(
      'emits isFormValid = false when any password is invalid',
      build: () {
        cubit.currentPass = 'test';
        cubit.newPass = '123';
        cubit.confirmPass = '123';
        return cubit;
      },
      act: (cubit) => cubit.doIntent(FormValidIntent()),
      expect: () => [
        isA<ChangePasswordStates>().having(
          (s) => s.isFormValid,
          'isFormValid',
          false,
        ),
      ],
    );
  });
}
