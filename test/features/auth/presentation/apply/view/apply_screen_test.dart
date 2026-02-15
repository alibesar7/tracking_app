import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/auth/data/models/request/apply_request_model.dart';
import 'package:tracking_app/features/auth/domain/entities/country_entity.dart';
import 'package:tracking_app/features/auth/presentation/apply/manager/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/manager/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_success_view.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  group('ApplySuccessScreen Widget Tests -', () {
    testWidgets('should display success message', (tester) async {
      // Act
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const MaterialApp(home: ApplySuccessScreen()),
        ),
      );
      await tester.pumpAndSettle();
      debugPrint(
        "Found texts: ${tester.widgetList(find.byType(Text)).map((e) => (e as Text).data).toList()}",
      );

      // Assert
      expect(find.text(LocaleKeys.applicationSubmitted), findsOneWidget);
      expect(find.text(LocaleKeys.congratulationsMessage), findsOneWidget);
    });

    testWidgets('should display back to login button', (tester) async {
      // Act
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const MaterialApp(home: ApplySuccessScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(LocaleKeys.backToLogin), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display success icon', (tester) async {
      // Act
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const MaterialApp(home: ApplySuccessScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Check for circular container with success decoration
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Column).first,
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.shape, BoxShape.circle);
    });

    testWidgets('should navigate when back button is tapped', (tester) async {
      // Arrange
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      context.push('/success');
                    },
                    child: const Text('Go to Success'),
                  );
                },
              ),
            ),
          ),
          GoRoute(
            path: '/success',
            builder: (context, state) => const ApplySuccessScreen(),
          ),
          GoRoute(
            path: RouteNames.login,
            builder: (context, state) =>
                const Scaffold(body: Text('Login Screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      // Navigate to success screen
      await tester.tap(find.text('Go to Success'));
      await tester.pumpAndSettle();

      // Verify we're on success screen
      expect(find.text(LocaleKeys.applicationSubmitted), findsOneWidget);

      // Tap back to login button
      await tester.tap(find.text(LocaleKeys.backToLogin));
      await tester.pumpAndSettle();

      // Assert - Should navigate to login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  group('ApplyState Tests -', () {
    test('initial state should have correct default values', () {
      // Act
      const state = ApplyState();

      // Assert
      expect(state.status, ApplyStatus.initial);
      expect(state.countries, isEmpty);
      expect(state.errorMessage, isNull);
      expect(state.vehiclesStatus, ApplyStatus.initial);
      expect(state.vehicles, isEmpty);
      expect(state.vehiclesErrorMessage, isNull);
      expect(state.applyStatus, ApplyStatus.initial);
      expect(state.applyErrorMessage, isNull);
    });

    test('copyWith should update only specified fields', () {
      // Arrange
      const initialState = ApplyState();
      final countries = [
        const CountryEntity(
          name: 'Egypt',
          isoCode: 'EG',
          flag: '🇪🇬',
          phoneCode: '20',
        ),
      ];

      // Act
      final newState = initialState.copyWith(
        status: ApplyStatus.success,
        countries: countries,
      );

      // Assert
      expect(newState.status, ApplyStatus.success);
      expect(newState.countries, countries);
      expect(newState.vehiclesStatus, ApplyStatus.initial); // Unchanged
      expect(newState.applyStatus, ApplyStatus.initial); // Unchanged
    });

    test('state should support equality comparison', () {
      // Arrange
      const state1 = ApplyState();
      const state2 = ApplyState();

      // Assert
      expect(state1, equals(state2));
    });

    test('different states should not be equal', () {
      // Arrange
      const state1 = ApplyState(status: ApplyStatus.initial);
      const state2 = ApplyState(status: ApplyStatus.loading);

      // Assert
      expect(state1, isNot(equals(state2)));
    });
  });

  group('ApplyIntent Tests -', () {
    test('GetCountriesIntent should be created', () {
      // Act
      final intent = GetCountriesIntent();

      // Assert
      expect(intent, isA<ApplyIntent>());
      expect(intent, isA<GetCountriesIntent>());
    });

    test('GetVehiclesIntent should be created', () {
      // Act
      final intent = GetVehiclesIntent();

      // Assert
      expect(intent, isA<ApplyIntent>());
      expect(intent, isA<GetVehiclesIntent>());
    });

    test('SubmitApplyIntent should be created with request model', () {
      // Arrange
      final requestModel = ApplyRequestModel(
        country: 'EG',
        firstName: 'John',
        lastName: 'Doe',
        vehicleType: '1',
        vehicleNumber: 'ABC123',
        email: 'john@example.com',
        phone: '+201234567890',
        NID: '12345678901234',
        password: 'Password123!',
        rePassword: 'Password123!',
        gender: 'male',
        vehicleLicense: null,
        NIDimg: null,
      );

      // Act
      final intent = SubmitApplyIntent(requestModel);

      // Assert
      expect(intent, isA<ApplyIntent>());
      expect(intent, isA<SubmitApplyIntent>());
      expect(intent.applyRequestModel, requestModel);
    });
  });
}

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "applicationSubmitted": "Application Submitted!",
      "congratulationsMessage":
          "Congratulations! Your application has been submitted successfully.",
      "backToLogin": "Back to Login",
      "reviewMessage":
          "We will review your application and get back to you soon via email.",
    };
  }
}
