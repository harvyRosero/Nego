import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String productCompanyName;
  final double productPrice;
  final String productImage;
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
    required this.productImage,
    required this.productDescription,
    required this.productRating,
    required this.stock,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.detailProduct,
          arguments: {
            'pId': productId,
            'name': productName,
            'companyName': productCompanyName,
            'price': productPrice,
            'img': productImage,
            'description': productDescription,
            'rating': productRating,
            'category': category,
            'stock': stock,
          },
        );
      },
      child: AspectRatio(
        aspectRatio: 0.75,
        child: Card(
          color: AppColors.blanco,
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  productImage,
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          productDescription,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[700], height: 1),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$ $productPrice',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
