import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home/home_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/widgets/profile/profile_screen_widget.dart';
import 'package:agro/widgets/notifications_screen_widget.dart';
import 'package:agro/widgets/home/home_product_list_widget.dart';
import 'package:agro/widgets/orders_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _buildBodyContent();
      }),
      bottomNavigationBar: Obx(() {
        return _buildBottomNavigationBar();
      }),
    );
  }

  Widget _buildBodyContent() {
    switch (homeController.currentScreen.value) {
      case 'Home':
        return HomeProductListWidget(
          onScroll: _handleScroll,
        );
      case 'Orders':
        return OrdersWidget(
          onScroll: _handleScroll,
        );
      case 'Notifications':
        return NotificationsScreenWidget(
          onScroll: _handleScroll,
        );
      case 'Profile':
        return ProfileScreenWidget(
          onScroll: _handleScroll,
        );
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }

  void _handleScroll(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      if (scrollInfo is UserScrollNotification) {
        if (scrollInfo.direction == ScrollDirection.forward) {
          homeController.toggleBottomNav(true);
        } else if (scrollInfo.direction == ScrollDirection.reverse) {
          homeController.toggleBottomNav(false);
        }
      }
    }
  }

  Widget _buildBottomNavigationBar() {
    return homeController.isBottomNavVisible.value
        ? BottomNavigationBar(
            currentIndex: _getCurrentTabIndex(),
            backgroundColor: AppColors.blanco,
            selectedItemColor: AppColors.verdeNavbar,
            unselectedItemColor: AppColors.gris,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dock),
                label: 'Mis Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notificaciones',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Mi cuenta',
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  int _getCurrentTabIndex() {
    switch (homeController.currentScreen.value) {
      case 'Home':
        return 0;
      case 'Orders':
        return 1;
      case 'Notifications':
        return 2;
      case 'Profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        homeController.changeScreen('Home');
        break;
      case 1:
        homeController.changeScreen('Orders');
        break;
      case 2:
        homeController.changeScreen('Notifications');
        break;
      case 3:
        homeController.changeScreen('Profile');
        break;
    }
  }
}
