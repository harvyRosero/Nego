import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home/home_product_list_controller.dart';
import 'package:agro/widgets/home/sliverappbar_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:agro/widgets/home/product_card_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:agro/models/product_model.dart';

class HomeProductListWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  final HomeProductListController homeProductListController =
      Get.put(HomeProductListController(), permanent: true);

  HomeProductListWidget({super.key, required this.onScroll});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          onScroll(scrollInfo);
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresca tanto los productos como la publicidad
            await homeProductListController.refreshData();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              buildSliverAppBar(),
              SliverToBoxAdapter(
                child: _buildCarousel(),
              ),
              PagedSliverGrid<int, ProductData>(
                pagingController: homeProductListController.pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 1,
                  childAspectRatio: 0.65,
                ),
                builderDelegate: PagedChildBuilderDelegate<ProductData>(
                  itemBuilder: (context, product, index) => ProductCard(
                    productId: product.id,
                    productName: product.name,
                    productCompanyName: 'Nego',
                    productPrice: product.price,
                    productPromo: product.promo,
                    productImage: product.imageUrl,
                    productDescription: product.description,
                    productRating: product.rating,
                    category: product.category,
                    estado: product.estado,
                    stock: product.stock,
                  ),
                  noItemsFoundIndicatorBuilder: (context) =>
                      _buildNoItemsFound(homeProductListController),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCarousel() {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 3),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 100.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 1800),
          viewportFraction: 1.0,
        ),
        items: homeProductListController.publicidadImages.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: LinearProgressIndicator(
                    color: AppColors.verdeNavbar,
                  )),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoItemsFound(
      HomeProductListController homeProductListController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 50,
              color:
                  AppColors.verdeNavbar.withOpacity(0.6), // Color consistente
            ),
            const SizedBox(height: 20),
            const Text(
              'Ubicación no encontrada.\nConfigura tu ubicación para ver productos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Get.toNamed(
                  AppRoutes.configAddress,
                  arguments: {
                    'barrio': '',
                    'direccion': '',
                    'detallesDireccion': '',
                    'celular': '',
                  },
                );
              },
              icon: const Icon(Icons.add_location_alt, color: Colors.white),
              label: const Text('Agregar ubicación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.verdeNavbar,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                homeProductListController.pagingController.refresh();
              },
              child: const Text(
                'Refrescar',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.verdeNavbar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
