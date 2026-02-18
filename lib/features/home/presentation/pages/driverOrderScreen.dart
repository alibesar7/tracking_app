import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderCubit.dart';
import 'package:tracking_app/features/home/presentation/manger/driverorderIntent.dart';
import 'package:tracking_app/features/home/presentation/widgets/driverScreenBody.dart';

class DriverOrderScreen extends StatelessWidget {
  const DriverOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DriverOrderCubit>()..onIntent(GetPendingOrders()),
      child: const DriverOrderBody(),
    );
  }
}
