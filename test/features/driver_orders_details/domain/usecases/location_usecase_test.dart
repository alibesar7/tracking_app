import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/driver_orders_details/domain/repos/order_details_repo.dart';
import 'package:tracking_app/features/driver_orders_details/domain/usecases/location_usecase.dart';

import 'get_order_details_usecase_test.mocks.dart';

@GenerateMocks([OrderDetailsRepo])
void main() {
  late LocationUsecase usecase;
  late MockOrderDetailsRepo mockRepo;

  setUp(() {
    mockRepo = MockOrderDetailsRepo();
    usecase = LocationUsecase(mockRepo);
    provideDummy<ApiResult<LatLng?>>(ErrorApiResult(error: 'dummy'));
    provideDummy<ApiResult<List<LatLng>>>(ErrorApiResult(error: 'dummy'));
  });

  const address = 'Cairo';
  final tLatLng = LatLng(30.0, 31.0);

  group('LocationUsecase.getAddress test', () {
    test(
      'should return SuccessApiResult containing the Stream from the repository when get address',
      () async {
        when(
          mockRepo.getLatLngFromAddress(address),
        ).thenAnswer((_) async => SuccessApiResult(data: tLatLng));

        final result = await usecase.getAddress(address);

        expect(result, isA<SuccessApiResult<LatLng?>>());
        verify(mockRepo.getLatLngFromAddress(address)).called(1);
      },
    );

    test('should return ErrorApiResult when the repository fails', () async {
      when(
        mockRepo.getLatLngFromAddress(address),
      ).thenAnswer((_) async => ErrorApiResult(error: 'Error from Repository'));

      final result = await usecase.getAddress(address);

      expect(result, isA<ErrorApiResult<LatLng?>>());
      expect((result as ErrorApiResult).error, 'Error from Repository');
    });
  });

  group('LocationUsecase.getRealRoute test', () {
    test(
      'should return SuccessApiResult containing the Stream from the repository',
      () async {
        when(
          mockRepo.getRealRoute(tLatLng, tLatLng),
        ).thenAnswer((_) async => SuccessApiResult(data: [tLatLng]));

        final result = await usecase.getRealRoute(tLatLng, tLatLng);

        expect(result, isA<SuccessApiResult<List<LatLng>>>());
        verify(mockRepo.getRealRoute(tLatLng, tLatLng)).called(1);
      },
    );

    test('should return ErrorApiResult when the repository fails', () async {
      when(
        mockRepo.getRealRoute(tLatLng, tLatLng),
      ).thenAnswer((_) async => ErrorApiResult(error: 'Error from Repository'));

      final result = await usecase.getRealRoute(tLatLng, tLatLng);

      expect(result, isA<ErrorApiResult<List<LatLng>>>());
      expect((result as ErrorApiResult).error, 'Error from Repository');
    });
  });
}
