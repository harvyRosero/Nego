import 'package:agro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/search_controller.dart';
import 'package:agro/utils/app_colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final MySearchController controller = Get.put(MySearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de categorías
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CategoryCard(
                    icon: Icons.local_bar,
                    label: "Licores",
                    onTap: () {
                      controller.fetchProductsByCategory('Sector Licores');
                    },
                  ),
                  CategoryCard(
                    icon: Icons.cake,
                    label: "Postres",
                    onTap: () {
                      controller.fetchProductsByCategory('Sector Postres');
                    },
                  ),
                  CategoryCard(
                    icon: Icons.fastfood,
                    label: "C Rapidas",
                    onTap: () {
                      controller.fetchProductsByCategory('Sector Comida');
                    },
                  ),
                  CategoryCard(
                    icon: Icons.production_quantity_limits,
                    label: "Productos",
                    onTap: () {
                      controller.fetchProductsByCategory('Sector Productos');
                    },
                  ),
                  CategoryCard(
                    icon: Icons.nature,
                    label: "Orgánicos",
                    onTap: () {
                      controller.fetchProductsByCategory('Sector Orgánicos');
                    },
                  ),
                ],
              ),
            ),
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
                                  product.promo != 0.0
                                      ? Text(
                                          '\$ ${product.promo.toString()} COP',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Container(),
                                  product.promo != 0.0
                                      ? Text(
                                          '\$ ${product.price.toString()} COP',
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        )
                                      : Text(
                                          '\$ ${product.price.toString()} COP',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                ],
                              ),
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.detailProduct,
                                  arguments: {
                                    'pId': product.id,
                                    'name': product.name,
                                    'companyName': 'Nego',
                                    'price': product.price,
                                    'promo': product.promo,
                                    'img': product.imageUrl,
                                    'description': product.description,
                                    'rating': product.rating,
                                    'category': product.category,
                                    'estado': product.estado,
                                    'stock': product.stock,
                                  },
                                );
                              },
                            ),
                          ),
                          product.promo != 0.0
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
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
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.grisClaro,
              child: Icon(icon, color: AppColors.verdeNavbar, size: 35),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: AppColors.grisLetras),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
