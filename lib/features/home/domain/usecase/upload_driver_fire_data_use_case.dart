import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/profile/data/models/driver_model.dart';

@injectable
class UploadDriverFireDataUseCase {
  final FirebaseFirestore _firestore;

  UploadDriverFireDataUseCase(this._firestore);

  Future<void> call(
    DriverModel driver, {
    required double lat,
    required double lng,
    String? deviceToken,
  }) async {
    final driverCollection = _firestore.collection('drivers');
    await driverCollection.doc(driver.Id).set({
      'id': driver.Id,
      'name': '${driver.firstName} ${driver.lastName}',
      'phone': driver.phone,
      'currentLocation': {'lat': lat, 'lng': lng},
      'deviceToken': deviceToken,
    }, SetOptions(merge: true));
  }
}
