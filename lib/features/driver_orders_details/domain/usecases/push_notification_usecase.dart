import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@injectable
class PushNotificationUsecase {
  final OrderDetailsRepo _repo;

  PushNotificationUsecase({required OrderDetailsRepo repo}) : _repo = repo;

  Future<ApiResult<void>> call(PushNotificationParams params) =>
      _repo.pushNotification(params);
}
