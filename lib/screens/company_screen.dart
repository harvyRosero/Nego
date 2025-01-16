import 'package:agro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agro/controllers/company_controller.dart';

class CompanyScreen extends StatelessWidget {
  CompanyScreen({super.key});
  final CompanyController controller = Get.put(CompanyController());
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'es_CO', symbol: '\$');

  @override
  Widget build(BuildContext context) {
    final category = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getArguments(category);
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.category.value)),
      ),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return const Center(
            child: Text(
              'No hay productos disponibles.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _buildProductCard(product, currencyFormat);
          },
        );
      }),
    );
  }

  Widget _buildProductCard(
      Map<String, dynamic> product, NumberFormat currencyFormat) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: product['imageUrl'] != null &&
                            product['imageUrl'].isNotEmpty
                        ? Image.network(
                            product['imageUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/placeholder.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                  ),
                  title: Text(
                    product['name'] ?? 'Sin nombre',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        product['description'] ?? 'Sin descripción',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currencyFormat.format(product['price'] ?? 0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.detailProduct,
                      arguments: {
                        'pId': product['id'],
                        'category': product['category'],
                        'flag': 'true',
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (product['promo'] != null && product['promo'] != 0.0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: const Text(
                  'Promo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
