import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/core/network/api_result.dart';
import 'package:tracking_app/app/config/auth_storage/auth_storage.dart';
import 'package:tracking_app/features/track_order/domain/entities/order_entity.dart';
import 'package:tracking_app/features/track_order/domain/entities/driver_entity.dart';
import 'package:tracking_app/features/track_order/domain/usecases/track_order_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/driver_usecase.dart';
import 'package:tracking_app/features/track_order/domain/usecases/update_state_usecase.dart';
part 'track_order_intent.dart';
part 'track_order_state.dart';

@injectable
class TrackOrderCubit extends Cubit<TrackOrderState> {
  final TrackOrderUseCase trackOrderUseCase;
  final TrackDriverUseCase driverUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final AuthStorage authStorage;

  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  StreamSubscription<DriverEntity>? _driverSubscription;

  TrackOrderCubit(
    this.trackOrderUseCase,
    this.driverUseCase,
    this.updateOrderStatusUseCase,
    this.authStorage,
  ) : super(const TrackOrderState());

  Future<void> loadUserOrders() async {
    emit(state.copyWith(isLoading: true, error: null));

    final token = await authStorage.getToken();

    if (token == null) {
      emit(state.copyWith(isLoading: false, error: "User not logged in"));
      return;
    }

    final result = trackOrderUseCase(token);

    if (result is SuccessApiResult<Stream<List<OrderEntity>>>) {
      _ordersSubscription = result.data.listen(
        (orders) {
          emit(state.copyWith(orders: orders, isLoading: false));
        },
        onError: (error) {
          emit(state.copyWith(isLoading: false, error: error.toString()));
        },
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await updateOrderStatusUseCase(orderId, status);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _ordersSubscription?.cancel();
    await _driverSubscription?.cancel();
    return super.close();
  }
}
