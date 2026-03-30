import 'package:tracking_app/features/my_orders/domain/models/store_entity.dart';
import '../models/store_model.dart';

extension StoreMapper on Store {
  StoreEntity toEntity() {
    return StoreEntity(
      name: name ?? '',
      image: image ?? '',
      address: address ?? '',
      phoneNumber: phoneNumber ?? '',
    );
  }
}
