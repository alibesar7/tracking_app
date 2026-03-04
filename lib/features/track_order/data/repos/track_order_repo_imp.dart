import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

@Injectable(as: TrackOrderRepo)
class TrackOrderRepoImpl implements TrackOrderRepo {
  final TrackOrderRemoteDataSource remoteDataSource;

  TrackOrderRepoImpl(this.remoteDataSource);

  @override
  ApiResult<Stream<List<OrderEntity>>> trackOrder(String userId) {
    final result = remoteDataSource.trackOrder(userId);

    return switch (result) {
      SuccessApiResult() => SuccessApiResult(
        data: (result.data).map(
          (models) => models
              .map(
                (model) => OrderEntity(
                  id: model.id,
                  userId: model.userId,
                  status: model.status,
                  driverId: model.driverId,
                  totalPrice: model.totalPrice,
                  pickupAddress: model.pickupAddress,
                  pickupName: model.pickupName,
                  userAddress: model.userAddress,
                  userName: model.userName,
                  deviceToken: model.deviceToken,
                ),
              )
              .toList(),
        ),
      ),

      ErrorApiResult() => ErrorApiResult(error: result.error),
    };
  }

  @override
  ApiResult<Stream<DriverEntity>> trackOrderWithDriver(String driverId) {
    final result = remoteDataSource.trackDriver(driverId);

    return switch (result) {
      SuccessApiResult() => SuccessApiResult(
        data: (result.data).map(
          (model) => DriverEntity(
            id: model.id,
            lat: model.lat,
            lng: model.lng,
            name: model.name,
            phone: model.phone,
            deviceToken: model.deviceToken,
          ),
        ),
      ),

      ErrorApiResult() => ErrorApiResult(error: result.error),
    };
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return remoteDataSource.updateOrderStatus(orderId, status);
  }
}
