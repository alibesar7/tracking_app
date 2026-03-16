import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';

class OrderDetailsStates {
  final Resource<OrderModel>? data;
  final Resource<DriverDataModel>? driverData;
  final LatLng? destination;
  final List<LatLng>? polylines;
  const OrderDetailsStates({
    this.data,
    this.driverData,
    this.destination,
    this.polylines,
  });

  OrderDetailsStates copyWith({
    Resource<OrderModel>? data,
    Resource<DriverDataModel>? driverData,
    LatLng? destination,
    List<LatLng>? polylines,
  }) {
    return OrderDetailsStates(
      data: data ?? this.data,
      driverData: driverData ?? this.driverData,
      destination: destination ?? this.destination,
      polylines: polylines ?? this.polylines,
    );
  }
}
