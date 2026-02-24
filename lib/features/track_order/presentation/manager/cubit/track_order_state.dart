part of 'track_order_cubit.dart';

class TrackOrderState extends Equatable {
  final OrderEntity? order;
  final DriverEntity? driver;
  final bool isLoading;
  final String? error;

  const TrackOrderState({
    this.order,
    this.driver,
    this.isLoading = false,
    this.error,
  });

  TrackOrderState copyWith({
    OrderEntity? order,
    DriverEntity? driver,
    bool? isLoading,
    String? error,
  }) {
    return TrackOrderState(
      order: order ?? this.order,
      driver: driver ?? this.driver,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [order, driver, isLoading, error];
}
