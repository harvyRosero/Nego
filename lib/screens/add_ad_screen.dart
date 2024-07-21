import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/add_ad_controller.dart';
import 'package:agro/widgets/ad_maker_widget.dart';
import 'package:agro/widgets/ad_product_widget.dart';
import 'package:agro/utils/app_colors.dart';

class AddAdScreen extends StatelessWidget {
  final AddAdController addAddController = Get.put(AddAdController());

  AddAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (addAddController.currentScreen.value == 'Add') {
          return AdMakerWidget();
        } else if (addAddController.currentScreen.value == 'product') {
          return AdProductWidget();
        } else if (addAddController.currentScreen.value == 'job') {
          return Container();
        } else {
          return const Center(child: Text('Unknown Screen'));
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: addAddController.currentScreen.value == 'Add'
              ? 0
              : addAddController.currentScreen.value == 'product'
                  ? 1
                  : 2,
          selectedItemColor: AppColors.verdeNavbar,
          unselectedItemColor: AppColors.gris,
          onTap: (index) {
            if (index == 0) {
              addAddController.changeScreen('Add');
            } else if (index == 1) {
              addAddController.changeScreen('product');
            } else if (index == 2) {
              addAddController.changeScreen('job');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'Publicacion',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Producto',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Oferta de trabajo',
            ),
          ],
        );
      }),
    );
  }
}
