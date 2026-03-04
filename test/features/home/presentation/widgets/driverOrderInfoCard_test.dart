import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderInfoCard.dart';

void main() {
  group('DriverOrderInfoCard Widget Tests', () {
    testWidgets('renders correct title and subtitle', (tester) async {
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DriverOrderInfoCard(
              image: null,
              title: title,
              subtitle: subtitle,
              isStore: false,
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('renders store icon when isStore is true and image is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DriverOrderInfoCard(
              image: null,
              title: 'Store',
              subtitle: 'Address',
              isStore: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.store), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets('renders person icon when isStore is false and image is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DriverOrderInfoCard(
              image: null,
              title: 'User',
              subtitle: 'Address',
              isStore: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.store), findsNothing);
    });

    testWidgets('renders NetworkImage when image is provided', (tester) async {
      const imageUrl = 'https://example.com/image.jpg';

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DriverOrderInfoCard(
                image: imageUrl,
                title: 'With Image',
                subtitle: 'Address',
                isStore: false,
              ),
            ),
          ),
        );
      });

      // We need to find the specific container with the image.
      // The hierarchy is Container > Row > [Container(image), SizedBox, Expanded(...)]
      // So let's look for a Container with a BoxDecoration that has an image.

      final imageContainer = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.image != null &&
              decoration.image!.image is NetworkImage &&
              (decoration.image!.image as NetworkImage).url == imageUrl;
        }
        return false;
      });

      expect(imageContainer, findsOneWidget);

      // Verify no fallback icon is shown
      expect(find.byIcon(Icons.person), findsNothing);
      expect(find.byIcon(Icons.store), findsNothing);
    });
  });
}
