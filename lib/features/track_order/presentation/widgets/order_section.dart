import 'package:flutter/material.dart';

class OrderSection extends StatelessWidget {
  final dynamic order;

  const OrderSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order.id}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text("Status: ${order.status}"),
            const SizedBox(height: 8),
            Text("Total: ${order.totalPrice} EGP"),
          ],
        ),
      ),
    );
  }
}
