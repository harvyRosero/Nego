import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String productCompanyName;
  final double productPrice;
  final double productPromo;
  final String productImage;
  final String estado;
  final String productDescription;
  final double productRating;
  final int stock;
  final String category;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productCompanyName,
    required this.productPrice,
    required this.productPromo,
    required this.productImage,
    required this.productDescription,
    required this.productRating,
    required this.stock,
    required this.category,
    required this.estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 2,
    );

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.detailProduct,
          arguments: {
            'pId': productId,
            'category': category,
            'flag': 'false',
          },
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          // Escala base para calcular tamaños
          // final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

          // Tamaño mínimo para las fuentes (en caso de dispositivos muy pequeños)
          final double baseFontSize = (width * 0.045).clamp(14.0, 22.0);

          return Card(
            color: AppColors.blanco,
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.03),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * 0.03),
                      ),
                      child: SizedBox(
                        height: height * 0.55,
                        width: double.infinity,
                        child: Image.network(
                          productImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.verdeNavbar,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: TextStyle(
                              fontSize: baseFontSize * 1.2, // Ajuste dinámico
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: height * 0.01),
                          if (productPromo > 0) ...[
                            Text(
                              currencyFormat.format(productPromo),
                              style: TextStyle(
                                color: AppColors.verdeLetras,
                                fontSize: baseFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.005),
                            Text(
                              currencyFormat.format(productPrice),
                              style: TextStyle(
                                fontSize: baseFontSize * 0.8,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Text(
                              productDescription,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: baseFontSize * 0.9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grisLetras,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: height * 0.005),
                            Text(
                              currencyFormat.format(productPrice),
                              style: TextStyle(
                                fontSize: baseFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grisLetras,
                              ),
                            ),
                          ],
                          SizedBox(height: height * 0.01),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < productRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: baseFontSize * 0.8, // Escala de ícono
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (productPromo > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.008,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Promo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: baseFontSize * 0.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
