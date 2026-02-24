class TrackOrderModel {
  final String driverId;
  final String id;
  final String status;
  final String totalPrice;
  final String userId;

  TrackOrderModel({
    required this.driverId,
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.userId,
  });

    factory TrackOrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TrackOrderModel(
      id: id,
      driverId: data['driverId'] ?? '',
      status: data['status'] ?? '',
      totalPrice: data['totalPrice'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}