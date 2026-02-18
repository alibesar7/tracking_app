import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/mapper/order_dto_mapper.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final OrderDetailsRemoteDatasource remoteDataSource;
  OrderDetailsRepoImpl(this.remoteDataSource);

  @override
  Stream<OrderModel> getOrderDetails(String orderId) {
    return remoteDataSource.getOrderStream(orderId).map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        throw Exception("Document does not exist in Firestore!");
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.data() as Map,
      );

      final orderDto = OrderDto.fromJson(data);
      return orderDto.toOrderModel();
    });
  }
}
