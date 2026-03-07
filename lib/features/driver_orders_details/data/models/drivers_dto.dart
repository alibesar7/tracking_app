class DriverDataDto {
  final String id;
  final String name;
  final String phone;
  final String deviceToken;
  final DriverLocationDto currentLocation;

  DriverDataDto({
    required this.id,
    required this.name,
    required this.phone,
    required this.deviceToken,
    required this.currentLocation,
  });

  factory DriverDataDto.fromJson(Map<String, dynamic> json) {
    return DriverDataDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
      currentLocation: DriverLocationDto.fromJson(
        json['currentLocation'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'deviceToken': deviceToken,
      'currentLocation': currentLocation.toJson(),
    };
  }
}

class DriverLocationDto {
  final double lat;
  final double lng;

  DriverLocationDto({required this.lat, required this.lng});

  factory DriverLocationDto.fromJson(Map<String, dynamic> json) {
    return DriverLocationDto(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
