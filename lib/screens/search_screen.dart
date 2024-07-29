import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/search_controller.dart';
import 'package:agro/widgets/search_widgets.dart';

class SearchScreen extends StatelessWidget {
  final MySearchController searchController = Get.put(MySearchController());

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Screen with GetX'),
      ),
      body: Obx(() {
        if (searchController.currentScreen.value == 'home') {
          return const HomeScreen();
        } else if (searchController.currentScreen.value == 'product') {
          return const ProductScreen();
        } else {
          return const Center(child: Text('Unknown Screen'));
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: searchController.currentScreen.value == 'home' ? 0 : 1,
        onTap: (index) {
          if (index == 0) {
            searchController.changeScreen('home');
          } else {
            searchController.changeScreen('product');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Product',
          ),
        ],
      ),
    );
  }
}
