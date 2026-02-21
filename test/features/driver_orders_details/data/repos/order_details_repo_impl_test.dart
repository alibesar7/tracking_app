import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/data/datasource/order_details_remote_datasource.dart';
import 'package:tracking_app/features/driver_orders_details/data/models/orders_dto.dart';
import 'package:tracking_app/features/driver_orders_details/data/repos/order_details_repo_impl.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'order_details_repo_impl_test.mocks.dart';

@GenerateMocks([OrderDetailsRemoteDatasource, DocumentSnapshot])
void main() {
  late OrderDetailsRepoImpl repository;
  late MockOrderDetailsRemoteDatasource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOrderDetailsRemoteDatasource();
    repository = OrderDetailsRepoImpl(mockRemoteDataSource);
    provideDummy<ApiResult<Stream<OrderDto>>>(
      ErrorApiResult(error: 'dummy_error'),
    );
  });

  const tOrderId = 'pxkMaEmWYVuvV5jkW0JK';

  final tOrderDto = OrderDto(
    driverId: 'D123',
    userAddress: UserAddressDto(
      address: 'Alex',
      name: 'Mariam',
      userId: 'U123',
    ),
    userId: 'U789',
    orderId: tOrderId,
    orderDetails: OrderDetailsDto(
      items: [],
      status: 'accepted',
      totalPrice: 150.0,
      pickupAddress: PickedAddressDto(name: 'Pharmacy', address: 'Downtown'),
      orderId: tOrderId,
      userAddress: 'Alex',
    ),
  );

  group('getOrderDetails', () {
    test(
      'should emit OrderModel when the remote data source returns SuccessApiResult with Stream',
      () async {
        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenReturn(SuccessApiResult(data: Stream.value(tOrderDto)));

        final result = repository.getOrderDetails(tOrderId);

        expect(result, isA<SuccessApiResult<Stream<OrderModel>>>());
        final stream = (result as SuccessApiResult<Stream<OrderModel>>).data;
        await expectLater(
          stream,
          emits(
            isA<OrderModel>()
                .having((o) => o.orderId, 'order id', tOrderId)
                .having((o) => o.userAddress.name, 'user name', 'Mariam')
                .having(
                  (o) => o.orderDetails.status,
                  'order status',
                  'accepted',
                )
                .having((o) => o.orderDetails.totalPrice, 'total price', 150.0),
          ),
        );
      },
    );

    test(
      'should throw an Exception when the document does not exist',
      () async {
        const errorMessage = "Network Error";
        when(
          mockRemoteDataSource.getOrderStream(tOrderId),
        ).thenReturn(ErrorApiResult(error: errorMessage));

        final result = repository.getOrderDetails(tOrderId);

        expect(result, isA<ErrorApiResult<Stream<OrderModel>>>());
        expect((result as ErrorApiResult).error, errorMessage);
      },
    );
  });
}
