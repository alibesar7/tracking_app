import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/data/datasource/my_orders_remote_data_source.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';
import 'package:tracking_app/features/my_orders/data/models/order_model.dart';
import 'package:tracking_app/features/my_orders/data/models/user_model.dart';
import 'package:tracking_app/features/my_orders/data/repo/my_orders_repo_imp.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';

import 'my_orders_repo_imp_test.mocks.dart';

@GenerateMocks([MyOrdersRemoteDataSource])
void main() {
  late MyOrdersRepoImpl repo;
  late MockMyOrdersRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    provideDummy<ApiResult<MyOrderResponse>>(
      SuccessApiResult(data: MyOrderResponse(orders: [])),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockMyOrdersRemoteDataSource();
    repo = MyOrdersRepoImpl(mockRemoteDataSource);
  });

  const tToken = 'token123';
  final tOrderModel = Order(
    id: 'o1',
    user: User(id: 'u1'),
  );
  final tOrderResponse = MyOrderResponse(orders: [tOrderModel], metadata: null);

  group('MyOrdersRepoImpl', () {
    test(
      'should return SuccessApiResult with data from remote data source when it is successful and not empty',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getAllOrders(
            token: anyNamed('token'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: tOrderResponse));

        // Act
        final result = await repo.getAllOrders(token: tToken);

        // Assert
        expect(result, isA<SuccessApiResult<MyOrdersResult>>());
        final data = (result as SuccessApiResult<MyOrdersResult>).data;
        expect(data.orders.length, 1);
        expect(data.orders[0].id, 'o1');
        verify(
          mockRemoteDataSource.getAllOrders(token: tToken, limit: 10, page: 1),
        ).called(1);
      },
    );

    test(
      'should return SuccessApiResult with dummy data when remote data source returns empty list',
      () async {
        // Arrange
        final emptyResponse = MyOrderResponse(orders: [], metadata: null);
        when(
          mockRemoteDataSource.getAllOrders(
            token: anyNamed('token'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: emptyResponse));

        // Act
        final result = await repo.getAllOrders(token: tToken);

        // Assert
        expect(result, isA<SuccessApiResult<MyOrdersResult>>());
        final data = (result as SuccessApiResult<MyOrdersResult>).data;
        expect(data.orders.isNotEmpty, true);
        expect(data.orders[0].id, '123456');
        verify(
          mockRemoteDataSource.getAllOrders(token: tToken, limit: 10, page: 1),
        ).called(1);
      },
    );

    test(
      'should return ErrorApiResult when remote data source call fails',
      () async {
        // Arrange
        const tError = 'Server error';
        when(
          mockRemoteDataSource.getAllOrders(
            token: anyNamed('token'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => ErrorApiResult(error: tError));

        // Act
        final result = await repo.getAllOrders(token: tToken);

        // Assert
        expect(result, isA<ErrorApiResult<MyOrdersResult>>());
        expect((result as ErrorApiResult<MyOrdersResult>).error, tError);
      },
    );
  });
}
