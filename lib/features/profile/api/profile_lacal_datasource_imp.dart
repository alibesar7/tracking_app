import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/profile/data/datasorce/profile_lacal_datasource.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final AuthStorage storage;

  ProfileLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveUser(DriverModel user) async {
    await storage.saveUserJson(jsonEncode(user.toJson()));
  }

  @override
  Future<DriverModel?> getUser() async {
    final json = await storage.getUserJson();
    if (json == null) return null;
    return DriverModel.fromJson(jsonDecode(json));
  }
}
