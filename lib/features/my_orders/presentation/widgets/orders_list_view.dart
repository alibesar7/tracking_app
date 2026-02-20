import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/order_card.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOrdersCubit, MyOrdersState>(
      builder: (context, state) {
        if (state.ordersResource.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.orders.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.orders.length) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final order = state.orders[index];

            return OrderCard(
              order: order,
              onTap: () {
                context.read<MyOrdersCubit>().doIntent(
                  OpenOrderDetailsIntent(order),
                );
                //Navigate to details nn
              },
            );
          },
        );
      },
    );
  }
}
