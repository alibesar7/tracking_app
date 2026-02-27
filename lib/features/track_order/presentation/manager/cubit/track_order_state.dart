part of 'track_order_cubit.dart';

class TrackOrderState extends Equatable {
  final List<OrderEntity> orders;
  final DriverEntity? driver;
  final bool isLoading;
  final String? error;

  const TrackOrderState({
    this.orders = const [],
    this.driver,
    this.isLoading = false,
    this.error,
  });

  TrackOrderState copyWith({
    List<OrderEntity>? orders,
    DriverEntity? driver,
    bool? isLoading,
    String? error,
  }) {
    return TrackOrderState(
      orders: orders ?? this.orders,
      driver: driver ?? this.driver,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [orders, driver, isLoading, error];
}
