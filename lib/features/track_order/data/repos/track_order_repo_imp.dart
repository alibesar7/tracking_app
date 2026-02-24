import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Injectable(as: TrackOrderRepo)
class TrackOrderRepoImpl implements TrackOrderRepo {
  final TrackOrderRemoteDataSource remoteDataSource;

  TrackOrderRepoImpl(this.remoteDataSource);

  @override
  ApiResult<Stream<OrderEntity>> trackOrder(String orderId) {
    final result = remoteDataSource.trackOrder(orderId);

    if (result is SuccessApiResult<Stream<TrackOrderModel>>) {
      final entityStream = result.data.map(
        (model) => OrderEntity(
          id: model.id,
          userId: model.userId,
          status: model.status,
          driverId: model.driverId,
          totalPrice: model.totalPrice,
        ),
      );

      return SuccessApiResult(data: entityStream);
    }

    if (result is ErrorApiResult<Stream<TrackOrderModel>>) {
      return ErrorApiResult(error: result.error);
    }

    throw Exception("Unhandled ApiResult type");
  }

  @override
  ApiResult<Stream<DriverEntity>> trackOrderWithDriver(String driverId) {
    final result = remoteDataSource.trackDriver(driverId);

    if (result is SuccessApiResult<Stream<DriverModel>>) {
      final entityStream = result.data.map(
        (model) => DriverEntity(
          id: model.id,
          lat: model.lat,
          lng: model.lng,
        ),
      );

      return SuccessApiResult(data: entityStream);
    }

    if (result is ErrorApiResult<Stream<DriverModel>>) {
      return ErrorApiResult(error: result.error);
    }

    throw Exception("Unhandled ApiResult type");
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return remoteDataSource.updateOrderStatus(orderId, status);
  }
}
