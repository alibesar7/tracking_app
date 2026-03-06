import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class SendDeviceNotificationUsecase {
  final OrderDetailsRepo _repo;

  SendDeviceNotificationUsecase({required OrderDetailsRepo repo})
    : _repo = repo;

  Future<ApiResult<void>> call(SendDeviceNotificationParams params) =>
      _repo.sendDeviceNotification(params);
}
