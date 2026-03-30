import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderButton.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderInfoCard.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderItem.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Widget createWidgetUnderTest(
    Order order, {
    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    return EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        home: Scaffold(
          body: DriverOrderItem(
            order: order,
            onAccept: onAccept ?? () {},
            onReject: onReject ?? () {},
          ),
        ),
      ),
    );
  }

  group('DriverOrderItem Widget Tests', () {
    final testOrder = Order(
      id: '1',
      totalPrice: 100,
      store: Store(
        name: 'Test Store',
        address: 'Store Address',
        image: 'store_image.jpg',
      ),
      user: User(firstName: 'John', lastName: 'Doe', photo: 'user_photo.jpg'),
      shippingAddress: ShippingAddress(street: 'User Street'),
    );

    testWidgets('renders order details correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidgetUnderTest(testOrder));
        await tester.pumpAndSettle();
      });

      // Verify Store Info
      expect(find.text('Test Store'), findsOneWidget);
      expect(find.text('Store Address'), findsOneWidget);

      // Verify User Info
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('User Street'), findsOneWidget);

      // Verify Price
      expect(find.text('100 egp'), findsOneWidget);

      // Verify sub-widgets are present
      expect(find.byType(DriverOrderInfoCard), findsNWidgets(2));
      expect(find.byType(DriverOrderButton), findsNWidgets(2));
    });

    testWidgets('calls onAccept when accept button is tapped', (tester) async {
      var isAccepted = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(testOrder, onAccept: () => isAccepted = true),
        );
        await tester.pumpAndSettle();
      });

      final acceptButtonFinder = find.descendant(
        of: find.byType(DriverOrderButton),
        matching: find.text('accept'),
      );

      await tester.tap(acceptButtonFinder);
      expect(isAccepted, isTrue);
    });

    testWidgets('calls onReject when reject button is tapped', (tester) async {
      var isRejected = false;
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createWidgetUnderTest(testOrder, onReject: () => isRejected = true),
        );
        await tester.pumpAndSettle();
      });

      // Find reject button
      final rejectButtonFinder = find.descendant(
        of: find.byType(DriverOrderButton),
        matching: find.text('reject'),
      );

      await tester.tap(rejectButtonFinder);
      expect(isRejected, isTrue);
    });
  });
}
