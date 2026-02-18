import 'package:tracking_app/features/track_order/data/datasource/track_order_remote_source.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_location_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

class TrackOrderRepoImpl implements TrackOrderRepo {
  final TrackOrderRemoteDataSource remoteDataSource;

  TrackOrderRepoImpl(this.remoteDataSource);

  @override
  Stream<Order> trackOrder(String orderId) {
    return remoteDataSource.trackOrder(orderId);
  }
}
