import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/app/core/ui_helper/color/colors.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_cubit.dart';
import 'package:tracking_app/features/app_sections/presentation/manager/app_section_states.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/home_page_test.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/orders_page_test.dart';
import 'package:tracking_app/features/app_sections/presentation/pages/profile_page_test.dart';
import 'package:tracking_app/features/my_orders/presentation/pages/my_orders_page.dart';
import 'package:tracking_app/features/profile/presentation/pages/profile_page.dart';
import 'package:tracking_app/generated/locale_keys.g.dart';

class AppSectionsView extends StatefulWidget {
  const AppSectionsView({super.key});

  @override
  State<AppSectionsView> createState() => _AppSectionsViewState();
}

class _AppSectionsViewState extends State<AppSectionsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSectionCubit, AppSectionStates>(
      builder: (context, state) {
        Widget bodyWidget;
        switch (state.selectedIndex) {
          case 0:
            bodyWidget = const HomePageTest();
            break;
          case 1:
            bodyWidget = const MyOrdersPage();
            break;
          case 2:
            bodyWidget = const ProfilePage();
            break;
          default:
            bodyWidget = const HomePageTest();
        }

        return Scaffold(
          body: bodyWidget,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              setState(() {
                state.selectedIndex = index;
              });
            },
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            iconSize: 24,
            selectedItemColor: AppColors.pink,
            unselectedItemColor: AppColors.grey2,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: LocaleKeys.home.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.fact_check_outlined),
                label: LocaleKeys.orders.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                label: LocaleKeys.profile.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}
