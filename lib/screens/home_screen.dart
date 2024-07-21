import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/widgets/publics_screen_widget.dart';
import 'package:agro/widgets/search_screen_widget.dart';
import 'package:agro/widgets/notifications_screen_widget.dart';
import 'package:agro/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _buildBodyContent();
      }),
      bottomNavigationBar: Obx(() {
        return _buildBottomNavigationBar();
      }),
      floatingActionButton: Obx(() {
        return _buildFloatingActionButton();
      }),
    );
  }

  Widget _buildBodyContent() {
    switch (_homeController.currentScreen.value) {
      case 'Home':
        return PublicsScreenWidget(
          onScroll: _handleScroll,
        );
      case 'Search':
        return SearchScreenWidget(
            // onScroll: _handleScroll,
            );
      case 'Notifications':
        return NotificationsScreenWidget(
            // onScroll: _handleScroll,
            );
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }

  void _handleScroll(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      if (scrollInfo is UserScrollNotification) {
        if (scrollInfo.direction == ScrollDirection.forward) {
          _homeController.toggleBottomNav(true);
        } else if (scrollInfo.direction == ScrollDirection.reverse) {
          _homeController.toggleBottomNav(false);
        }
      }
    }
  }

  Widget _buildFloatingActionButton() {
    return _homeController.isBottomNavVisible.value
        ? FloatingActionButton(
            onPressed: () {
              Get.toNamed(AppRoutes.adMaker);
            },
            backgroundColor: AppColors.verdeNavbar2,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: AppColors.verdeNavbar,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar() {
    return _homeController.isBottomNavVisible.value
        ? BottomNavigationBar(
            currentIndex: _getCurrentTabIndex(),
            selectedItemColor: AppColors.verdeNavbar,
            unselectedItemColor: AppColors.gris,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notificaciones',
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  int _getCurrentTabIndex() {
    switch (_homeController.currentScreen.value) {
      case 'Home':
        return 0;
      case 'Search':
        return 1;
      case 'Notifications':
        return 2;
      default:
        return 0;
    }
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        _homeController.changeScreen('Home');
        break;
      case 1:
        _homeController.changeScreen('Search');
        break;
      case 2:
        _homeController.changeScreen('Notifications');
        break;
    }
  }
}
