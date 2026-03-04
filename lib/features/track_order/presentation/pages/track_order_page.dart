import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';
import 'package:tracking_app/features/track_order/presentation/pages/driver_header.dart';
import 'package:tracking_app/features/track_order/presentation/pages/order_card.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackOrderCubit>().loadUserOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(LocaleKeys.track_order.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.appStart),
        ),
      ),
      body: BlocConsumer<TrackOrderCubit, TrackOrderState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.error != null) ...[
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.error!.contains('multiple indexes')
                            ? "Database Index Required\nPlease click the link in your console to create the missing Firestore indexes, then retry."
                            : state.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<TrackOrderCubit>().loadUserOrders(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pink,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Retry"),
                      ),
                    ] else
                      Text(LocaleKeys.no_orders_found.tr()),
                  ],
                ),
              ),
            );
          }

          final lastOrder = state.orders.last;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (state.driver != null)
                  DriverHeader(driverName: state.driver!.name),

                const SizedBox(height: 20),

                Expanded(
                  child: Center(child: OrderCard(order: lastOrder)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
