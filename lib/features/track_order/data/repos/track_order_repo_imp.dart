import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/data/models/driver_model.dart';
import 'package:tracking_app/features/track_order/data/models/track_order_model.dart';
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

    if (result is SuccessApiResult<Stream<List<TrackOrderModel>>>) {
      final successResult = result as SuccessApiResult<Stream<List<TrackOrderModel>>>;
      final entityStream = successResult.data.map(
        (models) => models
            .map(
              (model) => OrderEntity(
                id: model.id,
                userId: model.userId,
                status: model.status,
                driverId: model.driverId,
                totalPrice: model.totalPrice,
              ),
            )
            .toList(),
      );

      return SuccessApiResult(data: entityStream);
    }

    if (result is ErrorApiResult<Stream<List<TrackOrderModel>>>) {
      final errorResult = result as ErrorApiResult<Stream<List<TrackOrderModel>>>;
      return ErrorApiResult(error: errorResult.error);
    }

    throw Exception("Unhandled ApiResult type");
  }

  @override
  ApiResult<Stream<DriverEntity>> trackOrderWithDriver(String driverId) {
    final result = remoteDataSource.trackDriver(driverId);

    if (result is SuccessApiResult<Stream<DriverModel>>) {
      final successResult = result as SuccessApiResult<Stream<DriverModel>>;
      final entityStream = successResult.data.map(
        (model) => DriverEntity(
          id: model.id,
          lat: model.lat,
          lng: model.lng,
        ),
      );

      return SuccessApiResult(data: entityStream);
    }

    if (result is ErrorApiResult<Stream<DriverModel>>) {
      final errorResult = result as ErrorApiResult<Stream<DriverModel>>;
      return ErrorApiResult(error: errorResult.error);
    }

    throw Exception("Unhandled ApiResult type");
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) {
    return remoteDataSource.updateOrderStatus(orderId, status);
  }
}