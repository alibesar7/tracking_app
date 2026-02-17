import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/loginScreen.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

import 'loginScreen_test.mocks.dart';

@GenerateMocks([AuthRepo, AuthStorage])
void main() {
  late MockAuthRepo mockAuthRepo;
  late MockAuthStorage mockAuthStorage;
  late LoginUseCase loginUseCase;
  late LoginCubit loginCubit;
  late GetIt getIt;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    getIt = GetIt.instance;
    mockAuthRepo = MockAuthRepo();
    mockAuthStorage = MockAuthStorage();
    loginUseCase = LoginUseCase(mockAuthRepo);
    loginCubit = LoginCubit(loginUseCase, mockAuthStorage);

    // Register LoginCubit in GetIt
    if (getIt.isRegistered<LoginCubit>()) {
      getIt.unregister<LoginCubit>();
    }
    getIt.registerSingleton<LoginCubit>(loginCubit);
  });

  tearDown(() {
    loginCubit.close();
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(LocaleKeys.email), findsOneWidget);
    expect(find.text(LocaleKeys.password), findsOneWidget);
    expect(find.text(LocaleKeys.login), findsNWidgets(2));
  });

  testWidgets('Enters text into email and password fields', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pump();

    // Assert
    expect(find.text('test@test.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });
}
