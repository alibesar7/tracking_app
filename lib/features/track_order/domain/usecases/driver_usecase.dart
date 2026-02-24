import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

@injectable
class TrackDriverUseCase {
  final TrackOrderRepo repository;
  TrackDriverUseCase(this.repository);
  ApiResult<Stream<DriverEntity>> call(String orderId) =>
      repository.trackOrderWithDriver(orderId);
}
