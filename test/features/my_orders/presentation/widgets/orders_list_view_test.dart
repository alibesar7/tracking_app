import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_list_view.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_card.dart';

class MockMyOrdersCubit extends MockCubit<MyOrdersState>
    implements MyOrdersCubit {}

void main() {
  late MockMyOrdersCubit mockCubit;

  setUp(() {
    mockCubit = MockMyOrdersCubit();
  });

  testWidgets('OrdersListView shows loading indicator when loading', (
    WidgetTester tester,
  ) async {
    when(
      () => mockCubit.state,
    ).thenReturn(MyOrdersState(ordersResource: Resource.loading()));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<MyOrdersCubit>.value(
            value: mockCubit,
            child: const OrdersListView(),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('OrdersListView shows empty message when no orders', (
    WidgetTester tester,
  ) async {
    when(() => mockCubit.state).thenReturn(
      MyOrdersState(ordersResource: Resource.success(null), orders: []),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<MyOrdersCubit>.value(
            value: mockCubit,
            child: const OrdersListView(),
          ),
        ),
      ),
    );

    expect(find.text("No orders found"), findsOneWidget);
  });

  testWidgets('OrdersListView renders list of orders', (
    WidgetTester tester,
  ) async {
    final tOrder = OrderEntity(
      id: 'o1',
      user: UserEntity(
        id: 'u1',
        firstName: 'Noor',
        lastName: 'Mohamed',
        phone: '01',
        photo: 'https://img.com',
      ),
      items: [],
      totalPrice: 100,
      paymentType: 'Cash',
      isPaid: true,
      isDelivered: true,
      state: 'Delivered',
      createdAt: '2023',
      orderNumber: '1',
    );

    when(() => mockCubit.state).thenReturn(MyOrdersState(orders: [tOrder]));

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<MyOrdersCubit>.value(
              value: mockCubit,
              child: const OrdersListView(),
            ),
          ),
        ),
      );

      expect(find.byType(OrderCard), findsOneWidget);
      expect(find.text('# 1'), findsOneWidget);
    });
  });
}
