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
import 'package:tracking_app/features/track_order/domain/repos/track_order_repo.dart';

part 'track_order_state.dart';

@injectable
class TrackOrderCubit extends Cubit<TrackOrderState> {
  final  TrackOrderUseCase trackOrderUseCase;
  final TrackDriverUseCase driverUseCase;
  final AuthStorage authStorage;

  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  StreamSubscription<DriverEntity>? _driverSubscription;

  TrackOrderCubit(
    this.trackOrderUseCase,
    this.driverUseCase,
    this.authStorage,
  ) : super(const TrackOrderState());

  Future<void> loadUserOrders() async {
    emit(state.copyWith(isLoading: true, error: null));

    final userId = await authStorage.getToken();

    if (userId == null) {
      emit(state.copyWith(
        isLoading: false,
        error: "User not logged in",
      ));
      return;
    }

    final result = trackOrderUseCase(userId);

    if (result is SuccessApiResult<Stream<List<OrderEntity>>>) {
      _ordersSubscription = result.data.listen(
        (orders) {
          emit(state.copyWith(
            orders: orders,
            isLoading: false,
            error: null,
          ));
        },
        onError: (error) {
          emit(state.copyWith(
            isLoading: false,
            error: error.toString(),
          ));
        },
      );
    } else if (result is ErrorApiResult<Stream<List<OrderEntity>>>) {
      emit(state.copyWith(
        isLoading: false,
        error: result.error,
      ));
    }
  }

  void trackDriver(String driverId) {
    final result = driverUseCase(driverId);

    if (result is SuccessApiResult<Stream<DriverEntity>>) {
      _driverSubscription = result.data.listen(
        (driver) => emit(state.copyWith(driver: driver)),
        onError: (error) =>
            emit(state.copyWith(error: error.toString())),
      );
    }
  }

  @override
  Future<void> close() async {
    await _ordersSubscription?.cancel();
    await _driverSubscription?.cancel();
    return super.close();
  }
}