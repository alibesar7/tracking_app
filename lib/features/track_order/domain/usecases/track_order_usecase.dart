import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

@injectable
class TrackOrderUseCase {
  final TrackOrderRepo repository;

  TrackOrderUseCase(this.repository);

  ApiResult<Stream<List<OrderEntity>>> call(String userId) =>
      repository.trackOrder(userId);
}
