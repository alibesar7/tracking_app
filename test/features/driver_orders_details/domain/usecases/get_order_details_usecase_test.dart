import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
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
    provideDummy<ApiResult<Stream<OrderModel>>>(ErrorApiResult(error: 'dummy'));
  });

  const tOrderId = 'pxkMaEmWYVuvV5jkW0JK';

  final tOrderModel = OrderModel(
    driverId: 'D1',
    userAddress: UserAddressModel(address: 'Shebin', name: 'Ali', userId: 'U1'),
    userId: 'U1',
    orderId: tOrderId,
    orderDetails: OrderDetailsModel(
      items: [],
      status: 'accepted',
      totalPrice: 500,
      pickupAddress: PickedAddressModel(name: 'Pharmacy', address: 'Downtown'),
      orderId: tOrderId,
      userAddress: 'Shebin',
    ),
  );

  group('GetOrderDetailsUsecase test', () {
    test(
      'should return SuccessApiResult containing the Stream from the repository',
      () async {
        when(mockRepo.getOrderDetails()).thenAnswer(
          (_) async => SuccessApiResult(data: Stream.value(tOrderModel)),
        );

        final result = await usecase.call();

        expect(result, isA<SuccessApiResult<Stream<OrderModel>>>());
        final stream = (result as SuccessApiResult<Stream<OrderModel>>).data;
        await expectLater(stream, emits(tOrderModel));
        verify(mockRepo.getOrderDetails()).called(1);
      },
    );

    test('should return ErrorApiResult when the repository fails', () async {
      when(
        mockRepo.getOrderDetails(),
      ).thenAnswer((_) async => ErrorApiResult(error: 'Error from Repository'));

      final result = await usecase.call();

      expect(result, isA<ErrorApiResult<Stream<OrderModel>>>());
      expect((result as ErrorApiResult).error, 'Error from Repository');
    });
  });
}
