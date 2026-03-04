import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderButton.dart';

void main() {
  group('DriverOrderButton Widget Tests', () {
    testWidgets('renders button with correct text', (tester) async {
      // Arrange
      const buttonText = 'Accept';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DriverOrderButton(
              text: buttonText,
              onTap: () {},
              isPrimary: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      // Arrange
      var isTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DriverOrderButton(
              text: 'Tap Me',
              onTap: () {
                isTapped = true;
              },
              isPrimary: true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(DriverOrderButton));
      await tester.pumpAndSettle();

      // Assert
      expect(isTapped, isTrue);
    });

    testWidgets('renders primary style correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DriverOrderButton(
              text: 'Primary',
              onTap: () {},
              isPrimary: true,
            ),
          ),
        ),
      );

      // Verify Container decoration
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Primary'),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;

      // Assert
      expect(decoration.color, const Color(0xFFE91E63)); // Primary color
      expect(decoration.border, isNull);

      // Verify Text style
      final text = tester.widget<Text>(find.text('Primary'));
      expect(text.style?.color, Colors.white);
    });

    testWidgets('renders secondary style correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DriverOrderButton(
              text: 'Secondary',
              onTap: () {},
              isPrimary: false,
            ),
          ),
        ),
      );

      // Verify Container decoration
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Secondary'),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;

      // Assert
      expect(decoration.color, Colors.white);
      expect(decoration.border, isNotNull);
      // We can check border color if needed, but existence is good for now

      // Verify Text style
      final text = tester.widget<Text>(find.text('Secondary'));
      expect(text.style?.color, const Color(0xFFE91E63));
    });
  });
}
