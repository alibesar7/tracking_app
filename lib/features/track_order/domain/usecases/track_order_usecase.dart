import 'package:tracking_app/features/track_order/domain/entities/order_location_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

class TrackOrderUseCase {
  final TrackOrderRepo repository;

  TrackOrderUseCase(this.repository);

  Stream<Order> call(String orderId) {
    return repository.trackOrder(orderId);
  }
}
