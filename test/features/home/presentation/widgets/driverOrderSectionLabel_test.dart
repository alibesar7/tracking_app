import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderSectionLabel.dart';

void main() {
  testWidgets('DriverOrderSectionLabel renders correct text and style', (
    tester,
  ) async {
    const labelText = 'Test Label';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DriverOrderSectionLabel(labelText)),
      ),
    );

    // Verify text is rendered
    expect(find.text(labelText), findsOneWidget);

    // Verify text style
    final textWidget = tester.widget<Text>(find.text(labelText));
    expect(textWidget.style?.fontSize, 14);
    expect(textWidget.style?.color, Colors.grey);
  });
}
