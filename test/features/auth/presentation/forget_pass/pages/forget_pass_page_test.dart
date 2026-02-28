import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/manager/cubit/forget_pass_cubit.dart';
import 'package:tracking_app/features/auth/presentation/forget_pass/pages/forget_pass_page.dart';

class MockForgetPasswordCubit extends Mock
    implements ForgetPasswordCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockForgetPasswordCubit mockCubit;

  setUp(() {
    mockCubit = MockForgetPasswordCubit();

    when(() => mockCubit.state)
        .thenReturn(ForgetPasswordState.initial());

    when(() => mockCubit.stream)
        .thenAnswer((_) => const Stream.empty());

    when(() => mockCubit.formKey)
        .thenReturn(GlobalKey<FormState>());

    when(() => mockCubit.emailController)
        .thenReturn(TextEditingController());
  });

  Widget buildTestableWidget() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return BlocProvider<ForgetPasswordCubit>.value(
              value: mockCubit,
              child: const ForgetPasswordPage(),
            );
          },
        ),
        GoRoute(
          path: '/verify',
          builder: (context, state) => const Scaffold(),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('renders ForgetPasswordPage correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('shows loading indicator when loading',
      (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(
      ForgetPasswordState(
        resource: Resource.loading(),
        isFormValid: true,
      ),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}