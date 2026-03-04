import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

@injectable
class UpdateOrderStatusUseCase {
  final TrackOrderRepo repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<void> call(String orderId, String status) {
    return repository.updateOrderStatus(orderId, status);
  }
}
