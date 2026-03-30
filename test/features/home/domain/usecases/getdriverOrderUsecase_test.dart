import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/home/data/model/response/orderRespons.dart';
import 'package:tracking_app/features/home/domain/repo/driverOrderRepo.dart';
import 'package:tracking_app/features/home/domain/usecase/getdriverOrderUsecase.dart';

import 'getdriverOrderUsecase_test.mocks.dart';

@GenerateMocks([DriverOrderRepo])
void main() {
  late GetDriverOrdersUseCase useCase;
  late MockDriverOrderRepo mockRepository;

  setUp(() {
    provideDummy<ApiResult<OrderResponse>>(
      SuccessApiResult(data: OrderResponse()),
    );
    mockRepository = MockDriverOrderRepo();
    useCase = GetDriverOrdersUseCase(mockRepository);
  });

  const tToken = 'test_token';
  final tOrderResponse = OrderResponse(message: 'Success', orders: []);

  group('GetDriverOrdersUseCase', () {
    test('should get pending orders from the repository', () async {
      // Arrange
      when(
        mockRepository.getPendingOrders(any),
      ).thenAnswer((_) async => SuccessApiResult(data: tOrderResponse));

      // Act
      final result = await useCase(tToken);

      // Assert
      expect(result, isA<SuccessApiResult<OrderResponse>>());
      verify(mockRepository.getPendingOrders(tToken));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return error value from the repository', () async {
      // Arrange
      when(
        mockRepository.getPendingOrders(any),
      ).thenAnswer((_) async => ErrorApiResult(error: 'Error'));

      // Act
      final result = await useCase(tToken);

      // Assert
      expect(result, isA<ErrorApiResult<OrderResponse>>());
      verify(mockRepository.getPendingOrders(tToken));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
