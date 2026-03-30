import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/summary_card.dart';

void main() {
  testWidgets('SummaryCard renders correctly and handles tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    const title = 'Cancelled';
    const count = '5';
    const icon = Icons.cancel;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SummaryCard(
            title: title,
            count: count,
            icon: icon,
            color: Colors.red,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(count), findsOneWidget);
    expect(find.byIcon(icon), findsOneWidget);

    await tester.tap(find.byType(SummaryCard));
    expect(tapped, true);
  });
}
