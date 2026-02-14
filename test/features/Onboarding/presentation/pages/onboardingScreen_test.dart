import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/features/Onboarding/presentation/pages/onboardingScreen.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

import 'onboardingScreen_test.mocks.dart';

class MockAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "onboardingTitle": "Welcome to ",
      "onboardingDescription": "Flowery rider app ",
      "login": "Login",
      "applyNow": "Apply Now",
    };
  }
}

@GenerateMocks([AuthRepo])
void main() {
  late MockAuthRepo mockAuthRepo;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockAuthRepo = MockAuthRepo();
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      assetLoader: MockAssetLoader(),
      startLocale: const Locale('en'),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const Onboardingscreen(),
          );
        },
      ),
    );
  }

  group('Onboardingscreen Widget Test', () {
    testWidgets('renders all UI elements correctly', (
      WidgetTester tester,
    ) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();
      });

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Welcome to '), findsOneWidget);
      expect(find.text('Flowery rider app '), findsOneWidget);

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Apply Now'), findsOneWidget);
    });
  });
}
