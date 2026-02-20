import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/address_title.dart';

void main() {
  testWidgets('AddressTile renders correctly with given data', (
    WidgetTester tester,
  ) async {
    const title = 'Store Name';
    const address = '123 Street, City';
    const imageUrl = 'https://example.com/image.png';

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AddressTile(
              title: title,
              address: address,
              image: imageUrl,
              isStore: true,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(address), findsOneWidget);
      expect(
        find.byType(NetworkImage),
        findsNothing,
      ); // Image is in BoxDecoration, not as a widget
      // We can check if the container with decoration exists
      expect(find.byType(Container), findsWidgets);
    });
  });
}
