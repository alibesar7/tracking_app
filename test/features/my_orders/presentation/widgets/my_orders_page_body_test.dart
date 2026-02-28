import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/my_orders_page_body.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_filters_row.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_list_view.dart';

class MockMyOrdersCubit extends MockCubit<MyOrdersState>
    implements MyOrdersCubit {}

void main() {
  late MockMyOrdersCubit mockCubit;

  setUp(() {
    mockCubit = MockMyOrdersCubit();
  });

  testWidgets('MyOrdersPageBody renders components correctly', (
    WidgetTester tester,
  ) async {
    when(() => mockCubit.state).thenReturn(MyOrdersState());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<MyOrdersCubit>.value(
            value: mockCubit,
            child: const MyOrdersPageBody(),
          ),
        ),
      ),
    );

    expect(find.byType(OrdersFiltersRow), findsOneWidget);
    expect(find.text("Recent orders"), findsOneWidget);
    expect(find.byType(OrdersListView), findsOneWidget);
  });
}
