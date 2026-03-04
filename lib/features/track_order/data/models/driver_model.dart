class DriverModel {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String deviceToken;

  DriverModel({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.deviceToken,
  });

  factory DriverModel.fromFirestore(String id, Map<String, dynamic> data) {
    final location = data['currentLocation'] as Map<String, dynamic>?;
    return DriverModel(
      id: id,
      lat: (location?['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (location?['lng'] as num?)?.toDouble() ?? 0.0,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      deviceToken: data['deviceToken'] ?? '',
    );
  }
}
