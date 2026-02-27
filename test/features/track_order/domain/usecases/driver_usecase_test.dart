// test/features/track_order/domain/usecases/track_driver_usecase_test.dart

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

class MockTrackOrderRepo extends Mock implements TrackOrderRepo {}

void main() {
  late MockTrackOrderRepo mockRepo;
  late TrackDriverUseCase useCase;

  setUp(() {
    mockRepo = MockTrackOrderRepo();
    useCase = TrackDriverUseCase(mockRepo);
  });

  group('TrackDriverUseCase', () {
    final driver = DriverEntity(id: 'd1', lat: 10.0, lng: 20.0);

    test('returns SuccessApiResult with driver stream', () async {
      when(() => mockRepo.trackOrderWithDriver('d1'))
          .thenReturn(SuccessApiResult(data: Stream.value(driver)));

      final result = useCase.call('d1');

      expect(result, isA<SuccessApiResult<Stream<DriverEntity>>>());

      final d = await (result as SuccessApiResult).data.first;
      expect(d.id, 'd1');
      expect(d.lat, 10.0);
      expect(d.lng, 20.0);
    });

    test('returns ErrorApiResult when repository fails', () {
      when(() => mockRepo.trackOrderWithDriver('d1'))
          .thenReturn(ErrorApiResult(error: 'Driver not found'));

      final result = useCase.call('d1');

      expect(result, isA<ErrorApiResult>());
      expect((result as ErrorApiResult).error, 'Driver not found');
    });
  });
}