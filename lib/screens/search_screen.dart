import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:agro/controllers/search_controller.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final MySearchController controller = Get.put(MySearchController());

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(),
            Expanded(
              child: Obx(() {
                if (controller.searchResults.isEmpty &&
                    controller.searchQuery.isNotEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron resultados',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final product = controller.searchResults[index];
                    return _buildProductCard(product, currencyFormat);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              onChanged: (value) {
                controller.updateSearchQuery(value);
              },
              decoration: const InputDecoration(
                hintText: '¿Qué estás buscando?',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 100.0,
      child: Obx(() {
        if (controller.categoriesData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categoriesData.length,
          itemBuilder: (context, index) {
            String categoryName =
                controller.categoriesData.keys.elementAt(index);
            String imageUrl = controller.categoriesData[categoryName];

            return CategoryCard(
              imageUrl: imageUrl,
              label: categoryName,
              onTap: () => controller.fetchProductsByCategory(categoryName),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductCard(product, NumberFormat currencyFormat) {
    return Card(
      color: AppColors.blanco,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
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
                product.name,
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
                    product.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  _buildPriceSection(product, currencyFormat),
                ],
              ),
              onTap: () {
                Get.toNamed(
                  AppRoutes.detailProduct,
                  arguments: {'pId': product.id, 'category': product.category},
                );
              },
            ),
          ),
          if (product.promo != 0.0)
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

  Widget _buildPriceSection(product, NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.promo != 0.0)
          Text(
            currencyFormat.format(product.promo),
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
            ),
          ),
        Text(
          currencyFormat.format(product.price),
          style: TextStyle(
            color: product.promo != 0.0 ? Colors.red : Colors.green,
            fontSize: product.promo != 0.0 ? 12 : 14,
            decoration:
                product.promo != 0.0 ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 40), // Para manejar errores de carga de imagen
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
