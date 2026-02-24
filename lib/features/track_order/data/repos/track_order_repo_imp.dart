import 'package:injectable/injectable.dart';
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
  Stream<OrderEntity> trackOrder(String orderId) {
    return remoteDataSource.trackOrder(orderId).map((model) {
      return OrderEntity(
        id: model.id,
        userId: model.userId,
        status: model.status,
        driverId: model.driverId,
        totalPrice: model.totalPrice,
      );
    });
  }

  @override
  Stream<DriverEntity> trackOrderWithDriver(String orderId) {
    return remoteDataSource.trackDriver(orderId).map((model) {
      return DriverEntity(
        id: model.id,
        lat: model.lat,
        lng: model.lng,
      );
    });
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return remoteDataSource.updateOrderStatus(orderId, status);
  }
}
