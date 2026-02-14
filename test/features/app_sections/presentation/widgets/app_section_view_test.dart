import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_cubit.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_states.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/home_page_test.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/orders_page_test.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/profile_page_test.dart';
import 'package:tracking_app/features/app_sections/presentation/widgets/app_section_view.dart';

import 'app_section_view_test.mocks.dart';

@GenerateMocks([AppSectionCubit])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAppSectionCubit mockCubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockCubit = MockAppSectionCubit();
  });

  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        home: BlocProvider<AppSectionCubit>(
          create: (_) => mockCubit,
          child: AppSectionsView(),
        ),
      ),
    );
  }

  group('AppSectionsView Widget Test', () {
    testWidgets('should show Home page by default', (
      WidgetTester tester,
    ) async {
      when(mockCubit.state).thenReturn(AppSectionStates(selectedIndex: 0));
      when(mockCubit.stream).thenAnswer(
        (_) =>
            Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 0)),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.byIcon(Icons.home));
      await tester.pump();

      expect(find.byType(HomePageTest), findsOneWidget);
      expect(find.byType(OrdersPageTest), findsNothing);
      expect(find.byType(ProfilePageTest), findsNothing);
    });

    testWidgets('should navigate to Orders page when tapping Orders', (
      WidgetTester tester,
    ) async {
      when(mockCubit.state).thenReturn(AppSectionStates(selectedIndex: 1));
      when(mockCubit.stream).thenAnswer(
        (_) =>
            Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 1)),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.byIcon(Icons.fact_check_outlined));
      await tester.pump();

      expect(find.byType(OrdersPageTest), findsOneWidget);
    });

    testWidgets('should navigate to Profile page when tapping Profile', (
      WidgetTester tester,
    ) async {
      when(mockCubit.state).thenReturn(AppSectionStates(selectedIndex: 2));
      when(mockCubit.stream).thenAnswer(
        (_) =>
            Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 2)),
      );

      await tester.pumpWidget(buildTestableWidget());
      await tester.tap(find.byIcon(Icons.person_outlined));
      await tester.pump();

      expect(find.byType(ProfilePageTest), findsOneWidget);
    });
  });
}
