import 'package:flutter/material.dart';
import 'package:agro/controllers/home/home_product_list_controller.dart';
import 'package:get/get.dart';
import 'package:agro/widgets/home/sliverappbar_widget.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:agro/widgets/home/product_card_widget.dart';

class HomeProductListWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  final HomeProductListController homeProductListController =
      Get.put(HomeProductListController());

  HomeProductListWidget({super.key, required this.onScroll});

  @override
  Widget build(BuildContext context) {
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
            // SliverToBoxAdapter(
            //   child: _buildCarousel(),
            // ),
            Obx(() {
              if (homeProductListController.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product =
                          homeProductListController.productList[index];
                      return ProductCard(
                        productId: product.pId,
                        productName: product.nombre,
                        productCompanyName: product.nombreEmpresa,
                        productPrice: product.precio,
                        productImage: product.imagen,
                        productDescription: product.descripcion,
                        productRating: product.rating,
                        category: product.categoria,
                        stock: product.stock,
                      );
                    },
                    childCount: homeProductListController.productList.length,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await homeProductListController.fetchProducts();
  }

  // Widget _buildCarousel() {
  //   return CarouselSlider(
  //     options: CarouselOptions(
  //       height: 150.0,
  //       autoPlay: true,
  //       enlargeCenterPage: true,
  //       aspectRatio: 16 / 9,
  //       autoPlayCurve: Curves.fastOutSlowIn,
  //       enableInfiniteScroll: true,
  //       autoPlayAnimationDuration: const Duration(milliseconds: 1800),
  //       viewportFraction: 1.0,
  //     ),
  //     items: [1, 2, 3, 4, 5].map((i) {
  //       return Builder(
  //         builder: (BuildContext context) {
  //           return Container(
  //             width: MediaQuery.of(context).size.width,
  //             margin: const EdgeInsets.symmetric(vertical: 2.0),
  //             decoration: const BoxDecoration(
  //               color: Colors.amber,
  //             ),
  //             child: Center(
  //               child: Text(
  //                 'Text $i',
  //                 style: const TextStyle(fontSize: 14.0),
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }).toList(),
  //   );
  // }
}
