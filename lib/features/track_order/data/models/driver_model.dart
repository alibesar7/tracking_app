class DriverModel {
  final String id;
  final double lat;
  final double lng;

  DriverModel({required this.id, required this.lat, required this.lng});

  factory DriverModel.fromFirestore(String id, Map<String, dynamic> data) {
    return DriverModel(
      id: id,
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
    );
  }
}
