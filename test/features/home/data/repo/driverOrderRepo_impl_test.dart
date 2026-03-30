import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/datascourse/driverOrderDatascource.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/data/repo/driverOrderRepo_impl.dart';

import 'driverOrderRepo_impl_test.mocks.dart';

@GenerateMocks([DriverOrderDataSource])
void main() {
  late DriverOrderRepositoryImpl repository;
  late MockDriverOrderDataSource mockDataSource;

  setUp(() {
    provideDummy<ApiResult<OrderResponse>>(
      SuccessApiResult(data: OrderResponse()),
    );
    mockDataSource = MockDriverOrderDataSource();
    repository = DriverOrderRepositoryImpl(mockDataSource);
  });

  group('DriverOrderRepositoryImpl', () {
    const tToken = 'test_token';
    final tOrderResponse = OrderResponse(message: 'Success', orders: []);

    test(
      'should return data when the call to remote data source is successful',
      () async {
        // Arrange
        when(
          mockDataSource.getPendingOrders(any),
        ).thenAnswer((_) async => SuccessApiResult(data: tOrderResponse));

        // Act
        final result = await repository.getPendingOrders(tToken);

        // Assert
        expect(result, isA<SuccessApiResult<OrderResponse>>());
        verify(mockDataSource.getPendingOrders(tToken));
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return error when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        when(
          mockDataSource.getPendingOrders(any),
        ).thenAnswer((_) async => ErrorApiResult(error: 'Error'));

        // Act
        final result = await repository.getPendingOrders(tToken);

        // Assert
        expect(result, isA<ErrorApiResult<OrderResponse>>());
        verify(mockDataSource.getPendingOrders(tToken));
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}
