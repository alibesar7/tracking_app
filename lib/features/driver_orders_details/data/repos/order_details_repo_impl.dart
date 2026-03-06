import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notcicationModel.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/notficationDevice.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orderStates.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/update_order_state_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/push_notification_usecase.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/send_device_notification_usecase.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsRemoteDatasource _remoteDataSource;
  OrderDetailsRepoImpl(this._remoteDataSource);

  @override
  ApiResult<Stream<OrderModel>> getOrderDetails(String orderId) {
    final result = _remoteDataSource.getOrderStream(orderId);

    switch (result) {
      case SuccessApiResult<Stream<OrderDto>>():
        return SuccessApiResult<Stream<OrderModel>>(
          data: result.data.map((dto) => dto.toOrderModel()),
        );
      case ErrorApiResult<Stream<OrderDto>>():
        return ErrorApiResult<Stream<OrderModel>>(error: result.error);
    }
  }

  @override
  Future<ApiResult<void>> updateOrderState(
    UpdateOrderStateParams params,
  ) async {
    return _remoteDataSource.updateOrderState(
      orderId: params.orderId,
      state: params.state,
    );
  }

  @override
  Future<ApiResult<void>> pushNotification(
    PushNotificationParams params,
  ) async {
    return _remoteDataSource.pushNotification(
      title: params.title,
      des: params.des,
    );
  }

  @override
  Future<ApiResult<void>> sendDeviceNotification(
    SendDeviceNotificationParams params,
  ) async {
    return _remoteDataSource.sendDeviceNotification(
      userId: params.userId,
      title: params.title,
      body: params.body,
    );
  }
}
