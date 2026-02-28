import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/domain/usecase/forgetpassword_usecase.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/auth/domain/models/forgetpassword_entitiy.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';

class MockForgetPasswordUsecase extends Mock
    implements ForgetPasswordUsecase {}

class MockAuthStorage extends Mock implements AuthStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ForgetPasswordCubit cubit;
  late MockForgetPasswordUsecase mockUsecase;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    mockUsecase = MockForgetPasswordUsecase();
    mockAuthStorage = MockAuthStorage();
    cubit = ForgetPasswordCubit(mockUsecase, mockAuthStorage);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ForgetPasswordCubit', () {
    test('initial state is correct', () {
      expect(cubit.state.isFormValid, false);
      expect(cubit.state.resource.status, Status.initial);
    });

    test('FormChangedIntent updates isFormValid', () {
      cubit.emailController.text = 'test@mail.com';
      cubit.doIntent(const FormChangedIntent());

      expect(cubit.state.isFormValid, true);
    });

    test('Submit emits success', () async {
      final entity = ForgetPasswordEntitiy(message: 'Reset email sent', info: 'Check your inbox');

      cubit.emailController.text = 'test@mail.com';
      cubit.doIntent(const FormChangedIntent());

      when(() => mockUsecase(any()))
          .thenAnswer((_) async => SuccessApiResult(data: entity));

     await cubit.doIntent(const SubmitForgetPasswordIntent());

      expect(cubit.state.resource.status, Status.success);
      expect(cubit.state.resource.data, entity);
    });

    test('Submit emits error', () async {
      cubit.emailController.text = 'test@mail.com';
      cubit.doIntent(const FormChangedIntent());

      when(() => mockUsecase(any()))
          .thenAnswer((_) async => ErrorApiResult(error: 'Error'));

    await cubit.doIntent(const SubmitForgetPasswordIntent());

      expect(cubit.state.resource.status, Status.error);
    });
  });
}