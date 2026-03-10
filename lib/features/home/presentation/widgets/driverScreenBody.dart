import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderCubit.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderIntent.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderStates.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverOrderItem.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class DriverOrderBody extends StatefulWidget {
  const DriverOrderBody({super.key});

  @override
  State<DriverOrderBody> createState() => _DriverOrderBodyState();
}

class _DriverOrderBodyState extends State<DriverOrderBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverOrderCubit, DriverOrderState>(
      builder: (context, state) {
        final resource = state.orderResource;

        if (resource.status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (resource.status == Status.error) {
          return Center(
            child: Text(
              resource.error ?? LocaleKeys.unknownError.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (resource.status == Status.success) {
          final orders = resource.data!.orders?.reversed.toList() ?? [];
          if (orders.isEmpty) {
            return Center(child: Text(LocaleKeys.noPendingOrders.tr()));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DriverOrderCubit>().onIntent(GetPendingOrders());
            },
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return DriverOrderItem(
                  order: orders[index],
                  onAccept: () async {
                    final order = orders[index];
                    await getIt<AuthStorage>().saveOrderId(order.id.toString());
                    debugPrint('<<<< Saved Order ID: ${order.id}');
                    context.read<DriverOrderCubit>().onIntent(
                      AcceptOrder(orders[index]),
                    );
                    context.push(RouteNames.ordersDetailsPage);
                  },
                  onReject: () {
                    context.read<DriverOrderCubit>().onIntent(
                      RemoveOrder(orders[index]),
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
