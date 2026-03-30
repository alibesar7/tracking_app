import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/my_orders/domain/repo/my_orders_repo.dart';
import 'package:tracking_app/features/my_orders/domain/usecases/get_order_use_case.dart';

import 'get_order_use_case_test.mocks.dart';

@GenerateMocks([MyOrdersRepo])
void main() {
  late GetOrderUseCase getOrderUseCase;
  late MockMyOrdersRepo mockMyOrdersRepo;

  setUpAll(() {
    provideDummy<ApiResult<MyOrdersResult>>(
      SuccessApiResult(data: MyOrdersResult(orders: [])),
    );
  });

  setUp(() {
    mockMyOrdersRepo = MockMyOrdersRepo();
    getOrderUseCase = GetOrderUseCase(mockMyOrdersRepo);
  });

  const tToken = 'token123';
  const tPage = 1;
  const tLimit = 10;
  final tMyOrdersResult = MyOrdersResult(orders: []);

  group('GetOrderUseCase', () {
    test(
      'should return SuccessApiResult when repo call is successful',
      () async {
        // Arrange
        when(
          mockMyOrdersRepo.getAllOrders(
            token: anyNamed('token'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => SuccessApiResult(data: tMyOrdersResult));

        // Act
        final result = await getOrderUseCase.call(
          token: tToken,
          page: tPage,
          limit: tLimit,
        );

        // Assert
        expect(result, isA<SuccessApiResult<MyOrdersResult>>());
        expect(
          (result as SuccessApiResult<MyOrdersResult>).data,
          tMyOrdersResult,
        );
        verify(
          mockMyOrdersRepo.getAllOrders(
            token: tToken,
            page: tPage,
            limit: tLimit,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockMyOrdersRepo);
      },
    );

    test('should return ErrorApiResult when repo call fails', () async {
      // Arrange
      const tErrorMessage = 'An error occurred';
      when(
        mockMyOrdersRepo.getAllOrders(
          token: anyNamed('token'),
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => ErrorApiResult(error: tErrorMessage));

      // Act
      final result = await getOrderUseCase.call(
        token: tToken,
        page: tPage,
        limit: tLimit,
      );

      // Assert
      expect(result, isA<ErrorApiResult<MyOrdersResult>>());
      expect((result as ErrorApiResult<MyOrdersResult>).error, tErrorMessage);
      verify(
        mockMyOrdersRepo.getAllOrders(
          token: tToken,
          page: tPage,
          limit: tLimit,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockMyOrdersRepo);
    });
  });
}
