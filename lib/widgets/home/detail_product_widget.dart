import 'package:agro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/home/product_detail_controller.dart';
import 'package:agro/models/selected_product_model.dart';
import 'package:intl/intl.dart';

class DetailProductWidget extends StatelessWidget {
  DetailProductWidget({super.key});
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return _buildEmptyState(context);
    }

    controller.getArguments(arguments);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalles del Producto",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(height: 16.0),
            _buildProductDetails(context),
            const SizedBox(height: 16.0),
            _buildCategory(context),
            const SizedBox(height: 16.0),
            _buildRating(),
            const SizedBox(height: 8.0),
            _buildPrice(context),
            const SizedBox(height: 16.0),
            _buildQuantitySelector(context),
            const SizedBox(height: 16.0),
            _buildAddToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Center(
        child: Text(
          'No se proporcionaron detalles del producto.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Obx(() {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            controller.img.value,
            height: 250.0,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const LinearProgressIndicator(
                color: AppColors.verdeNavbar,
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildProductDetails(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.name.value,
            style: GoogleFonts.montserrat(
              color: AppColors.verdeLetras,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            controller.description.value,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.grisLetras,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Sugerencias',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey[600]),
          ),
          _buildSuggestedProducts()
        ],
      );
    });
  }

  Widget _buildSuggestedProducts() {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 2,
    );

    return Obx(() {
      if (controller.productsSug.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.productsSug.length,
              itemBuilder: (context, index) {
                var producto = controller.productsSug[index];
                return GestureDetector(
                  onTap: () {
                    controller.fetchProductById(producto['id']);
                    controller.quantity.value = 1;
                    controller.totalValue.value = producto['promo'] == 0.0
                        ? producto['price']
                        : producto['promo'];
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            producto['imageUrl'] ?? '',
                            height: 100,
                            width: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          producto['name'] ?? 'Nombre del producto',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          currencyFormat.format(producto['price']),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCategory(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          if (controller.flag.value != 'true') {
            Get.offNamed(AppRoutes.company,
                arguments: {'category': controller.category.value});
          }
        },
        child: Column(
          children: [
            controller.flag.value == 'true'
                ? Container()
                : const Text(
                    "Ver mas",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grisLetras,
                    ),
                  ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                  size: 25,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.category.value,
                  style: const TextStyle(
                    color: AppColors.verdeNavbar,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                  size: 25,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRating() {
    return Obx(() {
      return Row(
        children: List.generate(5, (index) {
          return Icon(
            Icons.star,
            color: index < controller.rating.value
                ? Colors.amber
                : Colors.grey[400],
            size: 20.0,
          );
        }),
      );
    });
  }

  Widget _buildPrice(BuildContext contxt) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 2,
    );

    return Obx(() {
      return controller.promo.value > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currencyFormat.format(controller.promo.value),
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    color: AppColors.verdeNavbar,
                  ),
                ),
                Text(
                  currencyFormat.format(controller.price.value),
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: AppColors.rojoError,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            )
          : Text(
              currencyFormat.format(controller.price.value),
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: AppColors.verdeNavbar,
              ),
            );
    });
  }

  Widget _buildQuantitySelector(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 1,
    );

    return Obx(() {
      double price0 = controller.promo.value > 0
          ? controller.promo.value
          : controller.price.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cantidad",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey[600]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (controller.quantity.value > 1) {
                        controller.quantity.value--;
                        controller.totalValue.value =
                            price0 * controller.quantity.value;
                      }
                    },
                  ),
                  Text(
                    controller.quantity.value.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      controller.quantity.value++;
                      controller.totalValue.value =
                          price0 * controller.quantity.value;
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                controller.totalValue.value.isEqual(0.0)
                    ? currencyFormat.format(price0)
                    : currencyFormat.format(controller.totalValue.value),
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: AppColors.verdeNavbar,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: controller.isLoading.value
            ? const LinearProgressIndicator(color: AppColors.verdeNavbar)
            : ElevatedButton.icon(
                onPressed: () async {
                  if (controller.estado.value == 'Agotado') {
                    Get.snackbar(
                      'Info',
                      'Este producto está agotado, por favor actualiza los productos e intenta más tarde',
                      backgroundColor: Colors.red.withOpacity(0.7),
                      colorText: Colors.white,
                    );
                    return;
                  }
                  double price0 =
                      (controller.price.value as num?)?.toDouble() ?? 0.0;
                  double price =
                      (controller.price.value as num?)?.toDouble() ?? 0.0;
                  final double promo =
                      (controller.promo.value as num?)?.toDouble() ?? 0.0;
                  if (promo > 0) {
                    price = promo;
                  }

                  final product = SelectedProductData(
                    pId: controller.pId.value,
                    nombre: controller.name.value,
                    precio: price0,
                    promo: promo,
                    imagen: controller.img.value,
                    categoria: controller.category.value,
                    total: controller.quantity.value == 1
                        ? price
                        : controller.totalValue.value,
                    cantidad: controller.quantity.value,
                  );

                  controller.addToCart(product);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.estado.value == 'Agotado'
                      ? AppColors.gris
                      : AppColors.verdeNavbar,
                  foregroundColor: AppColors.blanco,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: Text(
                  controller.estado.value == 'Agotado'
                      ? "Producto Agotado"
                      : "Agregar al carrito",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      );
    });
  }
}
