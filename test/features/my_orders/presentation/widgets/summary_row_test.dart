import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/summary_row.dart';

void main() {
  testWidgets('SummaryRow renders correctly with given label and value', (
    WidgetTester tester,
  ) async {
    const label = 'Total';
    const value = 'Egp 3000';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SummaryRow(label: label, value: value),
        ),
      ),
    );

    expect(find.text(label), findsOneWidget);
    expect(find.text(value), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });
}
