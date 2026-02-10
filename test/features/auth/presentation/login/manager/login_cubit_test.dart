import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/data/model/response/LoginResponse.dart';
import 'package:tracking_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_intent.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_states.dart';

import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  late LoginUseCase loginUseCase;
  late AuthStorage authStorage;
  late LoginCubit loginCubit;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    authStorage = MockAuthStorage();
    loginCubit = LoginCubit(loginUseCase, authStorage);

    // Default mocks for authStorage to avoid null errors during tests
    when(() => authStorage.saveToken(any())).thenAnswer((_) async {});
    when(() => authStorage.setRememberMe(any())).thenAnswer((_) async {});
  });

  group('LoginCubit', () {
    test('initial state is correct', () {
      expect(loginCubit.state.loginResource.status, Status.initial);
      expect(loginCubit.state.rememberMe, false);
    });

    blocTest<LoginCubit, LoginStates>(
      'emits [loading, success] when PerformLogin succeeds',
      build: () {
        when(() => loginUseCase.call(any(), any())).thenAnswer(
          (_) async => SuccessApiResult(data: LoginResponse(token: 'token')),
        );
        return loginCubit;
      },
      act: (cubit) => cubit.doAction(
        PerformLogin(
          email: 'test@test.com',
          password: 'pass',
          rememberMe: false,
        ),
      ),
      expect: () => [
        isA<LoginStates>().having(
          (s) => s.loginResource.status,
          'status',
          Status.loading,
        ),
        isA<LoginStates>().having(
          (s) => s.loginResource.status,
          'status',
          Status.success,
        ),
      ],
    );

    blocTest<LoginCubit, LoginStates>(
      'emits [loading, error] when PerformLogin fails',
      build: () {
        when(
          () => loginUseCase.call(any(), any()),
        ).thenAnswer((_) async => ErrorApiResult(error: 'error'));
        return loginCubit;
      },
      act: (cubit) => cubit.doAction(
        PerformLogin(
          email: 'test@test.com',
          password: 'pass',
          rememberMe: false,
        ),
      ),
      expect: () => [
        isA<LoginStates>().having(
          (s) => s.loginResource.status,
          'status',
          Status.loading,
        ),
        isA<LoginStates>().having(
          (s) => s.loginResource.status,
          'status',
          Status.error,
        ),
      ],
    );

    blocTest<LoginCubit, LoginStates>(
      'emits state with new rememberMe when ToggleRememberMe is called',
      build: () => loginCubit,
      act: (cubit) => cubit.doAction(ToggleRememberMe(true)),
      expect: () => [
        isA<LoginStates>().having((s) => s.rememberMe, 'rememberMe', true),
      ],
    );
  });
}
