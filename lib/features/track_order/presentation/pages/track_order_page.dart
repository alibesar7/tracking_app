import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/track_order/presentation/manager/cubit/track_order_cubit.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrackOrderCubit>().loadUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Orders')),
      body: BlocBuilder<TrackOrderCubit, TrackOrderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Order ID: ${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${order.status}'),
                          Text('Total: \$${order.totalPrice ?? '-'}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        if (order.driverId != null &&
                            order.driverId!.isNotEmpty) {
                          context.read<TrackOrderCubit>().trackDriver(
                            order.driverId!,
                          );

                          _showDriverBottomSheet(context);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _buildStatusButton(context, order),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, OrderEntity order) {
    String buttonText;
    String nextStatus;

    switch (order.status.toLowerCase()) {
      case 'accepted':
        buttonText = 'Arrived at Pickup point';
        nextStatus = 'Arrived';
        break;
      case 'arrived':
        buttonText = 'Pick Up Order';
        nextStatus = 'Picked';
        break;
      case 'picked':
        buttonText = 'Start Tracking';
        nextStatus = 'On the Way';
        break;
      case 'on the way':
        buttonText = 'Mark as Delivered';
        nextStatus = 'Delivered';
        break;
      case 'delivered':
        return const SizedBox.shrink();
      default:
        buttonText = 'Start Tracking';
        nextStatus = 'On the Way';
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        context.read<TrackOrderCubit>().updateOrderStatus(order.id, nextStatus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $nextStatus')),
        );
      },
      child: Text(buttonText),
    );
  }

  void _showDriverBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocBuilder<TrackOrderCubit, TrackOrderState>(
          builder: (context, state) {
            if (state.driver == null) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Driver not assigned yet'),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Driver Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('Driver ID: ${state.driver!.id}'),
                  Text('Latitude: ${state.driver!.lat}'),
                  Text('Longitude: ${state.driver!.lng}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
