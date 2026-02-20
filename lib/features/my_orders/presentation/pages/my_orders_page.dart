import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_cubit.dart';
import 'package:tracking_app/features/my_orders/presentation/manager/my_orders_intent.dart';
import 'package:tracking_app/features/my_orders/presentation/widgets/my_orders_page_body.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<MyOrdersCubit>()
            ..doIntent(GetMyOrdersIntent(page: 1, limit: 10)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My orders", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: const MyOrdersPageBody(),
      ),
    );
  }
}
