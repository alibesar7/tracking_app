import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_cubit.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/manager/change_password_states.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/pages/change_password_page.dart';
import 'package:tracking_app/features/auth/presentation/reset_password/widgets/text_form_field_widget.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

import 'change_password_page_test.mocks.dart';

@GenerateMocks([ChangePasswordCubit])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockChangePasswordCubit cubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    cubit = MockChangePasswordCubit();
    GetIt.I.registerSingleton<ChangePasswordCubit>(cubit);
    when(cubit.formKey).thenReturn(GlobalKey<FormState>());
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: false,
      child: Builder(
        builder: (context) {
          return MaterialApp(home: ChangePasswordPage());
        },
      ),
    );
  }

  testWidgets('renders all password fields', (tester) async {
    when(cubit.state).thenReturn(ChangePasswordStates());
    when(cubit.stream).thenAnswer((_) => Stream.value(ChangePasswordStates()));

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data == LocaleKeys.newPassword.tr() &&
            widget.style?.color == AppColors.grey2,
      ),
      findsOneWidget,
    );
    expect(find.byType(Icon), findsNWidgets(4));
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(3));
    expect(find.text(LocaleKeys.currentPassword), findsNWidgets(2));
    expect(find.bySemanticsLabel(LocaleKeys.newPassword.tr()), findsOneWidget);
    expect(
      find.widgetWithText(TextFormFieldWidget, LocaleKeys.newPassword),
      findsNWidgets(2),
    );
    expect(
      find.widgetWithText(TextFormFieldWidget, LocaleKeys.confirmPassword),
      findsNWidgets(2),
    );
    expect(find.text(LocaleKeys.update), findsOneWidget);
  });

  testWidgets('Toggling visibility icon changes obscureText property', (
    tester,
  ) async {
    when(cubit.state).thenReturn(ChangePasswordStates());
    when(cubit.stream).thenAnswer(
      (_) => Stream<ChangePasswordStates>.value(ChangePasswordStates()),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final passwordFieldFinder = find.widgetWithText(
      TextFormFieldWidget,
      LocaleKeys.currentPassword,
    );
    final textFieldFinder = find.descendant(
      of: passwordFieldFinder,
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(textFieldFinder).obscureText, isTrue);

    final visibilityIconFinder = find.descendant(
      of: passwordFieldFinder,
      matching: find.byIcon(Icons.visibility_off),
    );

    await tester.tap(visibilityIconFinder);
    await tester.pump();

    expect(tester.widget<TextField>(textFieldFinder).obscureText, isFalse);
  });

  testWidgets('Typing in text fields triggers Cubit intents', (tester) async {
    when(cubit.state).thenReturn(ChangePasswordStates());
    when(cubit.stream).thenAnswer((_) => Stream.value(ChangePasswordStates()));

    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final currentPassField = find.widgetWithText(
      TextFormFieldWidget,
      LocaleKeys.currentPassword,
    );
    await tester.enterText(currentPassField, 'Test@123');
    await tester.pump();

    verify(cubit.doIntent(argThat(isA<CurrentPasswordIntent>()))).called(1);
    verify(cubit.doIntent(argThat(isA<FormValidIntent>()))).called(1);
  });

  testWidgets('Shows SnackBar on Status.success', (tester) async {
    final initialState = ChangePasswordStates(data: Resource.loading());
    final successState = ChangePasswordStates(
      data: Resource.success(null),
      isFormValid: true,
    );

    when(cubit.state).thenReturn(initialState);
    when(cubit.stream).thenAnswer((_) => Stream.value(successState));

    final testRouter = GoRouter(
      initialLocation: '/change_password',
      routes: [
        GoRoute(
          path: '/change_password',
          builder: (context, state) => ChangePasswordPage(),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text(LocaleKeys.passwordUpdated.tr()), findsOneWidget);
    expect(find.text('Login Page'), findsOneWidget);
  });

  testWidgets('Shows Error Dialog on Status.error', (tester) async {
    final initialState = ChangePasswordStates();
    final errorState = ChangePasswordStates(
      data: Resource.error('Wrong Password'),
      isFormValid: true,
    );

    when(cubit.state).thenReturn(initialState);
    when(cubit.stream).thenAnswer((_) => Stream.value(errorState));

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Wrong Password'), findsOneWidget);
  });
}
