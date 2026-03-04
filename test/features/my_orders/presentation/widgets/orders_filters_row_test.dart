import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_filters_row.dart';

class MockMyOrdersCubit extends MockCubit<MyOrdersState>
    implements MyOrdersCubit {}

void main() {
  late MockMyOrdersCubit mockCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    registerFallbackValue(FilterCancelledOrdersIntent());
    registerFallbackValue(FilterCompletedOrdersIntent());
  });

  setUp(() {
    mockCubit = MockMyOrdersCubit();
    when(() => mockCubit.doIntent(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        home: Scaffold(
          body: BlocProvider<MyOrdersCubit>.value(
            value: mockCubit,
            child: const OrdersFiltersRow(),
          ),
        ),
      ),
    );
  }

  testWidgets('OrdersFiltersRow renders correct counts from metadata', (
    WidgetTester tester,
  ) async {
    final state = MyOrdersState(
      metadata: const MetadataEntity(
        currentPage: 1,
        totalPages: 1,
        totalItems: 10,
        limit: 10,
        cancelledCount: 3,
        completedCount: 7,
      ),
    );

    when(() => mockCubit.state).thenReturn(state);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('OrdersFiltersRow triggers intents on tap', (
    WidgetTester tester,
  ) async {
    final state = MyOrdersState();
    when(() => mockCubit.state).thenReturn(state);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelled'));
    await tester.pump();
    verify(
      () => mockCubit.doIntent(any(that: isA<FilterCancelledOrdersIntent>())),
    ).called(1);

    await tester.tap(find.text('Completed'));
    await tester.pump();
    verify(
      () => mockCubit.doIntent(any(that: isA<FilterCompletedOrdersIntent>())),
    ).called(1);
  });
}
