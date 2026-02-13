import 'package:tracking_app/features/profile/data/models/driver_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> saveUser(DriverModel user);
  Future<DriverModel?> getUser();
}
