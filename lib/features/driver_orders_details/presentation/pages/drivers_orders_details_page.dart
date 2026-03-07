import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/config/base_state/base_state.dart';
import 'package:tracking_app/app/config/di/di.dart';
import 'package:tracking_app/app/core/router/route_names.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/app/core/values/paths.dart';
import 'package:tracking_app/app/core/widgets/custom_button.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_cubit.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/manager/order_details_states.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/address_card.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/bottom_row_section.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/order_item.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/order_status.dart';
import 'package:tracking_app/features/driver_orders_details/presentation/widgets/section_title.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class DriversOrdersDetailsPage extends StatelessWidget {
  const DriversOrdersDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () => context.pop(),
        ),
        title: Text(
          LocaleKeys.orderDetails.tr(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 20,
            color: AppColors.blackColor,
          ),
        ),
      ),
      body: BlocProvider<OrderDetailsCubit>(
        create: (context) => getIt<OrderDetailsCubit>()..getOrderDetails(),
        child: BlocBuilder<OrderDetailsCubit, OrderDetailsStates>(
          builder: (context, state) {
            if (state.data?.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.data?.status == Status.error) {
              return Center(child: Text(state.data!.error.toString()));
            } else if (state.data?.status == Status.success) {
              final order = state.data!.data;
              final status = OrderStatus.fromString(order?.orderDetails.status);

              int currentStep = status.step;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: index < currentStep
                                  ? AppColors.green
                                  : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightPink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${LocaleKeys.status.tr()}${order?.orderDetails.status}',
                            style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${LocaleKeys.orderId.tr()}${order?.orderId}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Wed, 03 Sep 2024, 11:00 AM',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SectionTitle(title: LocaleKeys.pickupAddress.tr()),
                    InkWell(
                      onTap: () => context.push(
                        RouteNames.locationPage,
                        extra: 'pickup',
                      ),
                      child: AddressCard(
                        title: order?.orderDetails.pickupAddress.name ?? '',
                        address:
                            order?.orderDetails.pickupAddress.address ?? '',
                        imagePath: AppPaths.flowerLogo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionTitle(title: LocaleKeys.userAddress.tr()),
                    InkWell(
                      onTap: () =>
                          context.push(RouteNames.locationPage, extra: 'user'),
                      child: AddressCard(
                        title: order?.userAddress.name ?? '',
                        address: order?.userAddress.address ?? '',
                        imagePath: AppPaths.flowerLogo,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SectionTitle(title: LocaleKeys.orderDetails.tr()),
                    OrderItems(),
                    const SizedBox(height: 16),

                    BottomRowSection(
                      label: LocaleKeys.total.tr(),
                      value:
                          '${LocaleKeys.egp.tr()} ${order?.orderDetails.totalPrice.toStringAsFixed(2)}',
                    ),
                    BottomRowSection(
                      label: LocaleKeys.payment_method.tr(),
                      value: LocaleKeys.cash_on_delivery.tr(),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CustomButton(
                        isEnabled: true,
                        onPressed: () {},
                        isLoading: false,
                        text: status.buttonTextKey.tr(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
