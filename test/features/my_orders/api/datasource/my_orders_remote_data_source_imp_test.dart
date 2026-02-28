import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/app/core/api_manger/api_client.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/api/datasource/my_orders_remote_data_source_imp.dart';
import 'package:tracking_app/features/my_orders/data/models/response/my_order_response.dart';

import 'my_orders_remote_data_source_imp_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MyOrdersRemoteDataSourceImp dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = MyOrdersRemoteDataSourceImp(mockApiClient);
  });

  const tToken = 'token123';
  const tLimit = 10;
  const tPage = 1;
  final tOrderResponse = MyOrderResponse(orders: []);

  group('MyOrdersRemoteDataSourceImp', () {
    test(
      'should return SuccessApiResult when apiClient call is successful',
      () async {
        // Arrange
        final httpResponse = HttpResponse(
          tOrderResponse,
          Response(requestOptions: RequestOptions(path: ''), statusCode: 200),
        );
        when(
          mockApiClient.getAllOrders(
            token: anyNamed('token'),
            limit: anyNamed('limit'),
            page: anyNamed('page'),
          ),
        ).thenAnswer((_) async => httpResponse);

        // Act
        final result = await dataSource.getAllOrders(
          token: tToken,
          limit: tLimit,
          page: tPage,
        );

        // Assert
        expect(result, isA<SuccessApiResult<MyOrderResponse>>());
        expect(
          (result as SuccessApiResult<MyOrderResponse>).data,
          tOrderResponse,
        );
        verify(
          mockApiClient.getAllOrders(token: tToken, limit: tLimit, page: tPage),
        ).called(1);
      },
    );

    test('should return ErrorApiResult when apiClient call fails', () async {
      // Arrange
      when(
        mockApiClient.getAllOrders(
          token: anyNamed('token'),
          limit: anyNamed('limit'),
          page: anyNamed('page'),
        ),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // Act
      final result = await dataSource.getAllOrders(
        token: tToken,
        limit: tLimit,
        page: tPage,
      );

      // Assert
      expect(result, isA<ErrorApiResult<MyOrderResponse>>());
    });
  });
}
