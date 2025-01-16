import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro/controllers/home/shopping_cart_controller.dart';
import 'package:get/get.dart';
import 'package:agro/models/selected_product_model.dart';
import 'package:intl/intl.dart';

class ShoppingCartScreen extends StatelessWidget {
  ShoppingCartScreen({super.key});
  final ShoppingCartController _controller = Get.put(ShoppingCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de compras"),
        leading: IconButton(
          onPressed: () {
            Get.back();
            _controller.updateCartItemCount();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _controller.loadCartProducts();
            },
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            return Text(
              _controller.category.value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeNavbar,
                fontFamily: 'Roboto',
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (_controller.cartProducts.isEmpty) {
                return Center(
                  child: Text(
                    'El carrito está vacío',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

              // Añadimos el RefreshIndicator aquí
              return RefreshIndicator(
                color: AppColors.verdeNavbar,
                onRefresh: _controller.loadCartProducts,
                child: ListView.builder(
                  itemCount: _controller.cartProducts.length,
                  itemBuilder: (context, index) {
                    final product = _controller.cartProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.detailProduct,
                          arguments: {
                            'pId': product.pId,
                            'category': product.categoria,
                            'flag': 'false',
                          },
                        );
                      },
                      child: _buildCartItem(product, context),
                    );
                  },
                ),
              );
            }),
          ),
          _buildTotalAndCheckoutButton(context),
        ],
      ),
    );
  }

  Widget _buildCartItem(SelectedProductData product, BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 1,
    );

    return Card(
      color: AppColors.blanco,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.imagen,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Cantidad: x${product.cantidad}'),
                  const SizedBox(height: 4),
                  product.promo > 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currencyFormat.format(product.promo),
                              style:
                                  const TextStyle(color: AppColors.verdeLetras),
                            ),
                            Text(
                              currencyFormat.format(product.precio),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          currencyFormat.format(product.precio),
                          style: const TextStyle(color: AppColors.gris),
                        ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(product.total),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _controller.removeFromCart(product.pId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAndCheckoutButton(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 1,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        children: [
          Obx(() {
            return Expanded(
              child: Text(
                currencyFormat.format(_controller.totalSum.value),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.verdeNavbar,
                    ),
              ),
            );
          }),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              if (_controller.totalSum.value != 0) {
                Get.toNamed(AppRoutes.billing);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
              backgroundColor: AppColors.verdeNavbar,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Facturar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
