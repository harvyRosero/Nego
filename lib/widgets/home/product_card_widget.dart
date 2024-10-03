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
          arguments: {'pId': productId, 'category': category},
        );
      },
      child: AspectRatio(
        aspectRatio: 0.65,
        child: Card(
          color: AppColors.blanco,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16.0)),
                      child: AspectRatio(
                        aspectRatio:
                            1.0, // Ajusta la proporción según necesites
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
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              productName,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.047,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          productPromo > 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currencyFormat.format(productPromo),
                                      style: TextStyle(
                                        color: AppColors.verdeLetras,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      currencyFormat.format(productPrice),
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productDescription,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.grisLetras),
                                    ),
                                    Text(
                                      currencyFormat.format(productPrice),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.grisLetras),
                                    ),
                                  ],
                                ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < productRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 12,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (productPromo > 0)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Promo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
