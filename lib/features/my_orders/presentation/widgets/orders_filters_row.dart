import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';

class OrdersFiltersRow extends StatelessWidget {
  const OrdersFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyOrdersCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterButton(
            title: "Cancelled",
            color: Colors.red,
            onTap: () => cubit.doIntent(FilterCancelledOrdersIntent()),
          ),
          const SizedBox(width: 12),
          _FilterButton(
            title: "Completed",
            color: Colors.green,
            onTap: () => cubit.doIntent(FilterCompletedOrdersIntent()),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _FilterButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
