import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/widgets/show_snak_bar.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_state.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_filters_row.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/orders_list_view.dart';

class MyOrdersPageBody extends StatelessWidget {
  const MyOrdersPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyOrdersCubit, MyOrdersState>(
      listenWhen: (prev, curr) => prev.ordersResource != curr.ordersResource,
      listener: (context, state) {
        if (state.ordersResource.isError == true) {
          showAppSnackbar(
            context,
            state.ordersResource.error ?? "Failed to load orders",
          );
        }
      },
      child: Column(
        children: const [
          SizedBox(height: 12),
          OrdersFiltersRow(),
          SizedBox(height: 12),
          Expanded(child: OrdersListView()),
        ],
      ),
    );
  }
}
