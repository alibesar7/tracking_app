import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:tracking_app/features/auth/presentation/login/manager/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/pages/loginScreen.dart';

import 'loginScreen_test.mocks.dart';

@GenerateMocks([AuthRepo, AuthStorage])
void main() {
  late MockAuthRepo mockAuthRepo;
  late MockAuthStorage mockAuthStorage;
  late LoginUseCase loginUseCase;
  late LoginCubit loginCubit;
  late GetIt getIt;

  setUp(() async {
    // Mock shared preferences to avoid MissingPluginException
    SharedPreferences.setMockInitialValues({});

    getIt = GetIt.instance;
    mockAuthRepo = MockAuthRepo();
    mockAuthStorage = MockAuthStorage();
    loginUseCase = LoginUseCase(mockAuthRepo);
    loginCubit = LoginCubit(loginUseCase, mockAuthStorage);

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
      supportedLocales: const [Locale('en')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const LoginScreen(),
      ),
    );
  }

  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized(); // initialize EasyLocalization
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('email'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });

  testWidgets('Enters text into email and password fields', (tester) async {
    await EasyLocalization.ensureInitialized();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pump();

    final emailField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(emailField.controller?.text, 'test@test.com');

    final passwordField = tester.widget<TextFormField>(
      find.byType(TextFormField).last,
    );
    expect(passwordField.controller?.text, 'password123');
  });
}
