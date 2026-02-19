/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderSectionLabel.dart';

void main() {
  testWidgets('DriverOrderSectionLabel renders correct text and style', (
    tester,
  ) async {
    const labelText = 'Test Label';
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(400, 800)),
          child: Scaffold(body: DriverOrderSectionLabel(labelText)),
        ),
      ),
    );

    // Verify text is rendered
    expect(find.text(labelText), findsOneWidget);

    // Verify text style
    final textWidget = tester.widget<Text>(find.text(labelText));
    // 400 * 0.035 = 14.0
    expect(textWidget.style?.fontSize, 14.0);
    expect(textWidget.style?.color, Colors.grey);
  });
}
*/
