import 'package:tracking_app/features/my_orders/domain/models/user_entity.dart';
import '../models/user_model.dart';

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
    );
  }
}
