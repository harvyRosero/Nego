import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/home/product_detail_controller.dart';
import 'package:agro/models/selected_product_model.dart';

class DetailProductWidget extends StatelessWidget {
  DetailProductWidget({super.key});
  final ProductDetailController productDetailController =
      Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalles del Producto"),
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back_ios), // Cambia este icono por el que prefieras
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

    final String name = arguments['name'] ?? '';
    final String companyName = arguments['companyName'] ?? '';
    final String description = arguments['description'] ?? '';
    final int stock = arguments['stock'] ?? 0;
    final double rating = arguments['rating']?.toDouble() ?? 0.0;
    final String category = arguments['category'] ?? '';
    final double price = arguments['price']?.toDouble() ?? 0.0;
    final double promo = arguments['promo']?.toDouble() ?? 0.0;
    final String img = arguments['img'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(img),
            const SizedBox(height: 16.0),
            _buildProductDetails(name, description, companyName, context),
            const SizedBox(height: 16.0),
            _buildStockAndCategory(stock, category, context),
            const SizedBox(height: 16.0),
            _buildRating(rating, context),
            const SizedBox(height: 8.0),
            _buildPrice(price, context, promo),
            const SizedBox(height: 16.0),
            _buildQuantitySelector(context, price, promo),
            _buildAddToCartButton(context, arguments),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String img) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          img,
          height: 200.0,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails(String name, String description,
      String companyName, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: GoogleFonts.montserrat(
            color: AppColors.verdeLetras,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.grisLetras,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Por: $companyName',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStockAndCategory(
      int stock, String category, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Stock: $stock',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.green[700]),
          ),
        ),
        Expanded(
          child: Text(
            'Categoría: $category',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildRating(double rating, BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        const SizedBox(width: 4.0),
        Text(
          rating.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPrice(double price, BuildContext context, double promo) {
    return promo > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$ ${promo.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.green[700]),
              ),
              Text(
                '\$ ${price.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.red[700], fontSize: 14),
              )
            ],
          )
        : Text(
            '\$ ${price.toStringAsFixed(2)}',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.green[700]),
          );
  }

  Widget _buildQuantitySelector(
      BuildContext context, double price, double promo) {
    if (promo > 0) {
      price = promo;
    }
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
                    if (productDetailController.quantity.value > 1) {
                      productDetailController.quantity.value--;
                      productDetailController.totalValue.value =
                          price * productDetailController.quantity.value;
                    }
                  },
                ),
                Obx(() => Text(
                      productDetailController.quantity.value.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    )),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    productDetailController.quantity.value++;
                    productDetailController.totalValue.value =
                        price * productDetailController.quantity.value;
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
            Obx(
              () => Text(
                productDetailController.totalValue.value.isEqual(0.0)
                    ? price.toStringAsFixed(2)
                    : '\$ ${productDetailController.totalValue.value.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.green[700]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context, Map<String, dynamic> arguments) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (arguments['estado'] == 'Agotado') {
            Get.snackbar('Info',
                'Este producto está agotado, por favor actualiza los productos e intenta más tarde');
            return;
          }

          double price = (arguments['price'] as num?)?.toDouble() ?? 0.0;
          double price2 = (arguments['price'] as num?)?.toDouble() ?? 0.0;
          final double promo = (arguments['promo'] as num?)?.toDouble() ?? 0.0;
          if (promo > 0) {
            price = promo;
          }

          final product = SelectedProductData(
            pId: arguments['pId'] ?? '',
            nombre: arguments['name'] ?? '',
            precio: price2,
            promo: promo,
            imagen: arguments['img'] ?? '',
            total: productDetailController.quantity.value == 1
                ? price
                : productDetailController.totalValue.value,
            cantidad: productDetailController.quantity.value,
          );

          productDetailController.addToCart(product);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: arguments['estado'] == 'Agotado'
              ? AppColors.gris
              : AppColors.verdeNavbar,
          foregroundColor: AppColors.blanco,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_shopping_cart, size: 20),
            const SizedBox(width: 8.0),
            Text(
              arguments['estado'] == 'Agotado'
                  ? "Producto Agotado"
                  : "Agregar al carrito",
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
