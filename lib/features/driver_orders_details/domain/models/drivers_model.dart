class DriverDataModel {
  final String id;
  final String name;
  final String phone;
  final String deviceToken;
  final DriverLocationModel currentLocation;

  DriverDataModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.deviceToken,
    required this.currentLocation,
  });
}

class DriverLocationModel {
  final double lat;
  final double lng;

  DriverLocationModel({required this.lat, required this.lng});
}
