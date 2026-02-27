// test/features/track_order/domain/usecases/track_order_usecase_test.dart

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

class MockTrackOrderRepo extends Mock implements TrackOrderRepo {}

void main() {
  late MockTrackOrderRepo mockRepo;
  late TrackOrderUseCase useCase;

  setUp(() {
    mockRepo = MockTrackOrderRepo();
    useCase = TrackOrderUseCase(mockRepo);
  });

  group('TrackOrderUseCase', () {
    final orders = [OrderEntity(id: 'o1', userId: 'u1', status: 'delivered')];

    test('returns SuccessApiResult with orders stream', () async {
      when(() => mockRepo.trackOrder('u1'))
          .thenReturn(SuccessApiResult(data: Stream.value(orders)));

      final result = useCase.call('u1');

      expect(result, isA<SuccessApiResult<Stream<List<OrderEntity>>>>());

      final list = await (result as SuccessApiResult).data.first;
      expect(list.length, 1);
      expect(list.first.id, 'o1');
    });

    test('returns ErrorApiResult when repository fails', () {
      when(() => mockRepo.trackOrder('u1'))
          .thenReturn(ErrorApiResult(error: 'Network Error'));

      final result = useCase.call('u1');

      expect(result, isA<ErrorApiResult>());
      expect((result as ErrorApiResult).error, 'Network Error');
    });
  });
}