import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/my_orders/data/mappers/metadata_mapper.dart';
import 'package:tracking_app/features/my_orders/data/models/meta_data_dto.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';

void main() {
  group('MetadataMapper', () {
    test('should map Metadata DTO to MetadataEntity correctly', () {
      final dto = Metadata(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        limit: 10,
        cancelledCount: 5,
        completedCount: 95,
      );

      final result = dto.toEntity();

      expect(result, isA<MetadataEntity>());
      expect(result.currentPage, 1);
      expect(result.totalPages, 10);
      expect(result.totalItems, 100);
      expect(result.limit, 10);
      expect(result.cancelledCount, 5);
      expect(result.completedCount, 95);
    });

    test(
      'should map Metadata DTO with null fields to MetadataEntity with default values',
      () {
        final dto = Metadata(
          currentPage: null,
          totalPages: null,
          totalItems: null,
          limit: null,
          cancelledCount: null,
          completedCount: null,
        );

        final result = dto.toEntity();

        expect(result.currentPage, 0);
        expect(result.totalPages, 0);
        expect(result.totalItems, 0);
        expect(result.limit, 10);
        expect(result.cancelledCount, 0);
        expect(result.completedCount, 0);
      },
    );
  });
}
