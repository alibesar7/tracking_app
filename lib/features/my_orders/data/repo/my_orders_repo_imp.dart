import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/data/datasource/my_orders_remote_data_source.dart';
import 'package:tracking_app/features/my_orders/data/mappers/metadata_mapper.dart';
import 'package:tracking_app/features/my_orders/data/mappers/order_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_item_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';
import 'package:tracking_app/features/my_orders/domain/models/order_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';
import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';

@Injectable(as: MyOrdersRepo)
class MyOrdersRepoImpl implements MyOrdersRepo {
  final MyOrdersRemoteDataSource remoteDataSource;

  MyOrdersRepoImpl(this.remoteDataSource);

  @override
  Future<ApiResult<MyOrdersResult>> getAllOrders({
    required String token,
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.getAllOrders(
        token: token,
        limit: limit,
        page: page,
      );

      if (result is SuccessApiResult<MyOrderResponse>) {
        final response = result.data;
        List<OrderEntity> orders =
            response.orders?.map((e) => e.toEntity()).toList() ?? [];
        MetadataEntity? metadata = response.metadata?.toEntity();

        if (orders.isEmpty) {
          orders = _getDummyOrders();
          metadata = const MetadataEntity(
            currentPage: 1,
            totalPages: 1,
            totalItems: 4,
            limit: 10,
            cancelledCount: 1,
            completedCount: 3,
          );
        }

        return SuccessApiResult(
          data: MyOrdersResult(orders: orders, metadata: metadata),
        );
      } else if (result is ErrorApiResult<MyOrderResponse>) {
        return ErrorApiResult(error: result.error);
      } else {
        return ErrorApiResult(error: 'Unknown error');
      }
    } catch (e) {
      return ErrorApiResult(error: e.toString());
    }
  }

  List<OrderEntity> _getDummyOrders() {
    final dummyItems = [
      OrderItemEntity(
        product: ProductEntity(
          id: "p1",
          title: "Red roses, 15 Pink Rose Bouquet",
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
          price: 600,
        ),
        price: 600,
        quantity: 1,
      ),
      OrderItemEntity(
        product: ProductEntity(
          id: "p2",
          title: "Red roses, 15 Pink Rose Bouquet",
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
          price: 600,
        ),
        price: 600,
        quantity: 4,
      ),
    ];

    return [
      OrderEntity(
        id: "123456",
        user: UserEntity(
          id: "u1",
          firstName: "Noor",
          lastName: "mohamed",
          phone: "01012345678",
          photo: "https://i.pravatar.cc/150?u=u1",
        ),
        store: StoreEntity(
          name: "Flowery store",
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
          address: "20th st, Sheikh Zayed, Giza",
          phoneNumber: "01012345678",
        ),
        address: "20th st, Sheikh Zayed, Giza",
        items: dummyItems,
        totalPrice: 3000,
        paymentType: "Cash on delivery",
        isPaid: true,
        isDelivered: true,
        state: "Completed",
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        orderNumber: "123456",
      ),
      OrderEntity(
        id: "123457",
        user: UserEntity(
          id: "u1",
          firstName: "Nooor",
          lastName: "mohamed",
          phone: "01012345678",
          photo: "https://i.pravatar.cc/150?u=u1",
        ),
        store: StoreEntity(
          name: "Flowery store",
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
          address: "20th st, Sheikh Zayed, Giza",
          phoneNumber: "01012345678",
        ),
        address: "20th st, Sheikh Zayed, Giza",
        items: dummyItems,
        totalPrice: 3000,
        paymentType: "Cash on delivery",
        isPaid: false,
        isDelivered: false,
        state: "Cancelled",
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 4))
            .toIso8601String(),
        orderNumber: "123456",
      ),
      OrderEntity(
        id: "123458",
        user: UserEntity(
          id: "u1",
          firstName: "Noor",
          lastName: "mohamed",
          phone: "01012345678",
          photo: "https://i.pravatar.cc/150?u=u1",
        ),
        store: StoreEntity(
          name: "Flowery store",
          image:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-k6E9vG_c9B_I0m_K-7J1f8e6C9F5G1g5A&s",
          address: "20th st, Sheikh Zayed, Giza",
          phoneNumber: "01012345678",
        ),
        address: "20th st, Sheikh Zayed, Giza",
        items: dummyItems,
        totalPrice: 3000,
        paymentType: "Cash on delivery",
        isPaid: false,
        isDelivered: false,
        state: "Pending",
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 6))
            .toIso8601String(),
        orderNumber: "123456",
      ),
    ];
  }
}
