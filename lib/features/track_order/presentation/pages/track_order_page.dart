import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/features/track_order/presentation/widgets/driver_section.dart';
import 'package:tracking_app/features/track_order/presentation/widgets/order_section.dart';

class TrackOrderPage extends StatefulWidget {
  final String orderId;

  const TrackOrderPage({
    super.key,
    required this.orderId,
  });

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrackOrderCubit>().trackOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: BlocBuilder<TrackOrderCubit, TrackOrderState>(
        builder: (context, state) {
          if (state.isLoading && state.order == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<TrackOrderCubit>()
                  .trackOrder(widget.orderId);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.order != null)
                  OrderSection(order: state.order!),

                const SizedBox(height: 20),

                if (state.driver != null)
                  DriverSection(driver: state.driver!),

                if (state.driver == null)
                  const Center(
                    child: Text("Waiting for driver assignment..."),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
