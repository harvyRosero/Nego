import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/controllers/home/cart_item_controller.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItemController = Get.put(CartItemController());

    return Obx(() {
      return Stack(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 30,
              color: AppColors.blanco,
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.shoppingCart);
            },
          ),
          if (cartItemController.itemCount.value > 0)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                child: Text(
                  ' ${cartItemController.itemCount.value} ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
