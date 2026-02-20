import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_card.dart';

void main() {
  final tOrder = OrderEntity(
    id: 'o1',
    user: UserEntity(
      id: 'u1',
      firstName: 'Noor',
      lastName: 'Mohamed',
      phone: '010',
      photo: 'https://example.com/u1.png',
    ),
    store: StoreEntity(
      name: 'Test Store',
      image: 'https://example.com/s1.png',
      address: 'Store Address',
      phoneNumber: '011',
    ),
    address: 'User Address',
    items: [],
    totalPrice: 100,
    paymentType: 'Cash',
    isPaid: true,
    isDelivered: true,
    state: 'Delivered',
    createdAt: '2023-01-01',
    orderNumber: 'ORD123',
  );

  testWidgets('OrderCard renders correctly and handles tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderCard(order: tOrder, onTap: () => tapped = true),
          ),
        ),
      );

      expect(find.text('Delivered'), findsOneWidget);
      expect(find.text('# ORD123'), findsOneWidget);
      expect(find.text('Test Store'), findsOneWidget);
      expect(find.text('Store Address'), findsOneWidget);
      expect(find.text('Noor Mohamed'), findsOneWidget);
      expect(find.text('User Address'), findsOneWidget);

      await tester.tap(find.byType(OrderCard));
      expect(tapped, true);
    });
  });
}
