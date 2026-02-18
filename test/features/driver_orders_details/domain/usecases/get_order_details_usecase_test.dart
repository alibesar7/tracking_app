import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/orders_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_order_details_usecase.dart';

import 'get_order_details_usecase_test.mocks.dart';

@GenerateMocks([OrderDetailsRepo])
void main() {
  late GetOrderDetailsUsecase usecase;
  late MockOrderDetailsRepo mockRepo;

  setUp(() {
    mockRepo = MockOrderDetailsRepo();
    usecase = GetOrderDetailsUsecase(repo: mockRepo);
  });

  const tOrderId = 'pxkMaEmWYVuvV5jkW0JK';

  final tOrderModel = OrderModel(
    driverId: 'D1',
    id: tOrderId,
    status: 'accepted',
    totalPrice: '100',
    userAddress: UserAddressModel(address: 'Shebin', name: 'Ali'),
    userId: 'U1',
  );

  group('GetOrderDetailsUsecase test', () {
    test('should get order details from the repository when called', () async {
      when(
        mockRepo.getOrderDetails(any),
      ).thenAnswer((_) => Stream.value(tOrderModel));

      final result = usecase.call(tOrderId);

      expect(result, emits(tOrderModel));
      verify(mockRepo.getOrderDetails(tOrderId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should forward the error stream if the repository fails', () async {
      when(
        mockRepo.getOrderDetails(any),
      ).thenAnswer((_) => Stream.error('Error from Repository'));

      final result = usecase.call(tOrderId);

      expect(result, emitsError('Error from Repository'));
    });
  });
}
