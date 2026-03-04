import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

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
}
