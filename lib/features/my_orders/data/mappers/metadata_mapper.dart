import 'package:tracking_app/features/my_orders/data/models/meta_data_dto.dart';
import 'package:tracking_app/features/my_orders/domain/models/meta_data_entity.dart';

extension MetadataMapper on Metadata {
  MetadataEntity toEntity() {
    return MetadataEntity(
      currentPage: currentPage ?? 0,
      totalPages: totalPages ?? 0,
      totalItems: totalItems ?? 0,
      limit: limit ?? 10,
      cancelledCount: cancelledCount ?? 0,
      completedCount: completedCount ?? 0,
    );
  }
}
