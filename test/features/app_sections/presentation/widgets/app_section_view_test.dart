import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_cubit.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_states.dart';
import 'package:tracking_app/features/app_sections/presentation/widgets/app_section_view.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderCubit.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderStates.dart';
import 'package:tracking_app/features/home/presentation/pages/driverOrderScreen.dart';

import 'app_section_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppSectionCubit>(), MockSpec<DriverOrderCubit>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAppSectionCubit mockAppSectionCubit;
  late MockDriverOrderCubit mockDriverOrderCubit;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  setUp(() {
    mockAppSectionCubit = MockAppSectionCubit();
    mockDriverOrderCubit = MockDriverOrderCubit();
    if (getIt.isRegistered<DriverOrderCubit>()) {
      getIt.unregister<DriverOrderCubit>();
    }
    getIt.registerFactory<DriverOrderCubit>(() => mockDriverOrderCubit);
  });

  tearDown(() {
    if (getIt.isRegistered<DriverOrderCubit>()) {
      getIt.unregister<DriverOrderCubit>();
    }
  });

  Widget buildTestableWidget() {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AppSectionCubit>(create: (_) => mockAppSectionCubit),
            BlocProvider<DriverOrderCubit>(create: (_) => mockDriverOrderCubit),
          ],
          child: AppSectionsView(),
        ),
      ),
    );
  }

  group('AppSectionsView Widget Test', () {
    testWidgets('should show DriverOrderScreen by default (index 0)', (
      WidgetTester tester,
    ) async {
      when(
        mockAppSectionCubit.state,
      ).thenReturn(AppSectionStates(selectedIndex: 0));
      when(mockAppSectionCubit.stream).thenAnswer(
        (_) =>
            Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 0)),
      );

      // Stub DriverOrderCubit
      when(
        mockDriverOrderCubit.state,
      ).thenReturn(DriverOrderState(orderResource: Resource.loading()));
      when(
        mockDriverOrderCubit.stream,
      ).thenAnswer((_) => Stream<DriverOrderState>.empty());

      await tester.pumpWidget(buildTestableWidget());
      // No tap needed for default

      expect(find.byType(DriverOrderScreen), findsOneWidget);
    });

    // testWidgets('should navigate to Orders page when tapping Orders', (
    //   WidgetTester tester,
    // ) async {
    //   when(
    //     mockAppSectionCubit.state,
    //   ).thenReturn(AppSectionStates(selectedIndex: 1));
    //   when(mockAppSectionCubit.stream).thenAnswer(
    //     (_) =>
    //         Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 1)),
    //   );

    //   // Stub DriverOrderCubit just in case (though not used in index 1 view)
    //   when(
    //     mockDriverOrderCubit.state,
    //   ).thenReturn(DriverOrderState(orderResource: Resource.loading()));
    //   when(
    //     mockDriverOrderCubit.stream,
    //   ).thenAnswer((_) => Stream<DriverOrderState>.empty());

    //   await tester.pumpWidget(buildTestableWidget());
    //   await tester.tap(find.byIcon(Icons.fact_check_outlined));
    //   await tester.pump();

    //   expect(find.byType(OrdersPageTest), findsOneWidget);
    // });

    // testWidgets('should navigate to Profile page when tapping Profile', (
    //   WidgetTester tester,
    // ) async {
    //   when(mockAppSectionCubit.state).thenReturn(AppSectionStates(selectedIndex: 2));
    //   when(mockAppSectionCubit.stream).thenAnswer(
    //     (_) => Stream<AppSectionStates>.value(AppSectionStates(selectedIndex: 2)),
    //   );
    //   await tester.pumpWidget(buildTestableWidget());
    //   await tester.tap(find.byIcon(Icons.person_outlined));
    //   await tester.pump();
    //   expect(find.byType(ProfilePage), findsOneWidget);
    // });
  });
}
