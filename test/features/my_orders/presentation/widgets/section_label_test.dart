import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/section_lable.dart';

void main() {
  testWidgets('SectionLabel renders correctly with given text', (
    WidgetTester tester,
  ) async {
    const testLabel = 'Test Label';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionLabel(label: testLabel)),
      ),
    );

    expect(find.text(testLabel), findsOneWidget);
  });
}
