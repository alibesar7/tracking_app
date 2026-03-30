import 'package:tracking_app/features/my_orders/domain/models/product_entity.dart';
import '../models/product_model.dart';

extension ProductMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      title: title ?? '',
      image: image ?? '',
      price: price ?? 0,
    );
  }
}
