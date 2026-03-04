import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/pages/order_details_page.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/summary_row.dart';

void main() {
  final tOrder = OrderEntity(
    id: "123456",
    user: UserEntity(
      id: "u1",
      firstName: "Noor",
      lastName: "mohamed",
      phone: "01012345678",
      photo: "https://example.com/user.png",
    ),
    store: StoreEntity(
      name: "Flowery store",
      image: "https://example.com/store.png",
      address: "20th st, Sheikh Zayed, Giza",
      phoneNumber: "01012345678",
    ),
    address: "20th st, Sheikh Zayed, Giza",
    items: [
      OrderItemEntity(
        product: ProductEntity(
          id: "p1",
          title: "Red roses",
          image: "https://example.com/item.png",
          price: 600,
        ),
        price: 600,
        quantity: 1,
      ),
    ],
    totalPrice: 3000,
    paymentType: "Cash on delivery",
    isPaid: true,
    isDelivered: true,
    state: "Completed",
    createdAt: "2023-01-01",
    orderNumber: "123456",
  );

  testWidgets('OrderDetailsPage renders correctly with given order', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(home: OrderDetailsPage(order: tOrder)),
      );

      expect(find.text("Order details"), findsWidgets);
      expect(find.text("Completed"), findsOneWidget);
      expect(find.text("# 123456"), findsOneWidget);

      expect(find.text("Pickup address"), findsOneWidget);
      expect(find.text("Flowery store"), findsOneWidget);

      expect(find.text("User address"), findsOneWidget);
      expect(find.text("Noor mohamed"), findsOneWidget);

      expect(find.byType(OrderItemTile), findsOneWidget);
      expect(find.text("Red roses"), findsOneWidget);

      expect(find.byType(SummaryRow), findsNWidgets(2));
      expect(find.text("Egp 3000"), findsOneWidget);
      expect(find.text("Cash on delivery"), findsOneWidget);
    });
  });
}
