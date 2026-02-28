import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_success_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAssetLoader extends AssetLoader {
  const MockAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "applicationSubmitted": "Application Submitted!",
      "congratulationsMessage":
          "Congratulations! Your application has been submitted successfully.",
      "backToLogin": "Back to Login",
    };
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      assetLoader: const MockAssetLoader(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const ApplySuccessScreen(),
          );
        },
      ),
    );
  }

  testWidgets('should display success message', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Test for the actual text rendered, not the key
    expect(find.text('Application Submitted!'), findsOneWidget);
    expect(
      find.text(
        'Congratulations! Your application has been submitted successfully.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('should display back to login button', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Back to Login'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
