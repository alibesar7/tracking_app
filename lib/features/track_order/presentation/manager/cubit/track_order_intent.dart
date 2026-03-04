part of 'track_order_cubit.dart';


abstract class TrackOrderIntent extends Equatable {
  const TrackOrderIntent();

  @override
  List<Object?> get props => [];
}

class LoadUserOrdersIntent extends TrackOrderIntent {
  const LoadUserOrdersIntent();

  @override
  List<Object?> get props => [];
}

class AcceptOrderIntent extends TrackOrderIntent {
  final String orderId;
  const AcceptOrderIntent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}