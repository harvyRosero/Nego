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
      Get.put(HomeProductListController());

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
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              buildSliverAppBar(),
              SliverToBoxAdapter(
                child: _buildCarousel(),
              ),
              PagedSliverGrid<int, ProductData>(
                pagingController: homeProductListController.pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
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
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _refreshData() async {
    return homeProductListController.pagingController.refresh();
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
}
