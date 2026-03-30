import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/api/driverOrderDataS_imp.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:dio/dio.dart';

import 'driverOrderDataS_imp_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late DriverOrderDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = DriverOrderDataSourceImpl(mockApiClient);
  });

  group('DriverOrderDataSourceImpl', () {
    const tToken = 'test_token';
    final tOrderResponse = OrderResponse(message: 'Success', orders: []);

    test(
      'should return SuccessApiResult when the call to ApiClient is successful',
      () async {
        // Arrange
        final httpResponse = HttpResponse(
          tOrderResponse,
          Response(
            data: tOrderResponse,
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ),
        );
        when(
          mockApiClient.getPendingOrders(any),
        ).thenAnswer((_) async => httpResponse);

        // Act
        final result = await dataSource.getPendingOrders(tToken);

        // Assert
        expect(result, isA<SuccessApiResult<OrderResponse>>());
        verify(mockApiClient.getPendingOrders(tToken));
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return ErrorApiResult when the call to ApiClient throws an exception',
      () async {
        // Arrange
        when(mockApiClient.getPendingOrders(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Error',
            type: DioExceptionType.unknown,
          ),
        );

        // Act
        final result = await dataSource.getPendingOrders(tToken);

        // Assert
        expect(result, isA<ErrorApiResult<OrderResponse>>());
        verify(mockApiClient.getPendingOrders(tToken));
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
