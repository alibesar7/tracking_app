import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/summary_card.dart';

class OrdersFiltersRow extends StatelessWidget {
  const OrdersFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyOrdersCubit>();

    return BlocBuilder<MyOrdersCubit, MyOrdersState>(
      builder: (context, state) {
        final metadata = state.metadata;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: "Cancelled",
                  count: "${metadata?.cancelledCount ?? 0}",
                  color: AppColors.red,
                  icon: Icons.cancel_outlined,
                  onTap: () => cubit.doIntent(FilterCancelledOrdersIntent()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: "Completed",
                  count: "${metadata?.completedCount ?? 0}",
                  color: AppColors.green,
                  icon: Icons.check_circle_outline,
                  onTap: () => cubit.doIntent(FilterCompletedOrdersIntent()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
