import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/models/drivers_model.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/get_driver_data_usecase.dart';
import 'get_order_details_usecase_test.mocks.dart';

@GenerateMocks([OrderDetailsRepo])
void main() {
  late GetDriverDataUsecase usecase;
  late MockOrderDetailsRepo mockRepo;

  setUp(() {
    mockRepo = MockOrderDetailsRepo();
    usecase = GetDriverDataUsecase(repo: mockRepo);
    provideDummy<ApiResult<Stream<DriverDataModel>>>(
      ErrorApiResult(error: 'dummy'),
    );
  });

  const driverId = 'pxkMaEmWYVuvV5jkW0JK';

  final driverModel = DriverDataModel(
    id: 'id',
    name: 'name',
    phone: 'phone',
    deviceToken: 'deviceToken',
    currentLocation: DriverLocationModel(lat: 30, lng: 29),
  );

  group('GetDriverDataUsecase test', () {
    test(
      'should return SuccessApiResult containing the Stream from the repository',
      () async {
        when(
          mockRepo.getDriverData(driverId),
        ).thenAnswer((_) => SuccessApiResult(data: Stream.value(driverModel)));

        final result = usecase.call(driverId);

        expect(result, isA<SuccessApiResult<Stream<DriverDataModel>>>());
        final stream =
            (result as SuccessApiResult<Stream<DriverDataModel>>).data;
        await expectLater(stream, emits(driverModel));
        verify(mockRepo.getDriverData(driverId)).called(1);
      },
    );

    test('should return ErrorApiResult when the repository fails', () async {
      when(mockRepo.getDriverData(driverId)).thenAnswer(
        (_) => ErrorApiResult<Stream<DriverDataModel>>(
          error: 'Error from Repository',
        ),
      );

      final result = await usecase.call(driverId);

      expect(result, isA<ErrorApiResult<Stream<DriverDataModel>>>());
      expect((result as ErrorApiResult).error, 'Error from Repository');
    });
  });
}
