import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_item_tile.dart';

void main() {
  final tOrderItem = OrderItemEntity(
    product: ProductEntity(
      id: "p1",
      title: "Red roses, 15 Pink Rose Bouquet",
      image: "https://example.com/image.png",
      price: 600,
    ),
    price: 600,
    quantity: 2,
  );

  testWidgets('OrderItemTile renders correctly with given data', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: OrderItemTile(item: tOrderItem)),
        ),
      );

      expect(find.text("Red roses, 15 Pink Rose Bouquet"), findsOneWidget);
      expect(find.text("EGP 600"), findsOneWidget);
      expect(find.text("X2"), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });
}
