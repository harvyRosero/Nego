import 'package:flutter/material.dart';
import 'package:agro/controllers/home/home_widget_controller.dart';
import 'package:get/get.dart';
import 'package:agro/widgets/home/sliverappbar_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreenWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  final HomeScreenWidgetController homeScreenWidgetController =
      Get.put(HomeScreenWidgetController());

  HomeScreenWidget({super.key, required this.onScroll});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        onScroll(scrollInfo);
        return false;
      },
      child: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildCarousel(),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.1,
              crossAxisSpacing:
                  0.2, // Espaciado entre elementos en el eje transversal
              childAspectRatio: 0.8, // Relación de aspecto de las tarjetas
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ProductCard(
                  productName: 'Producto $index',
                  productPrice: '\$${(index + 1) * 10}',
                  productImage:
                      'https://club.involves.com/es/wp-content/uploads/2019/01/Como_definir_o_mix_de_produtos_ideal-1.png', // URL de la imagen del producto
                );
              },
              childCount: 10, // Número de productos
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1800),
        viewportFraction: 1.0, // Ocupar todo el ancho
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                  vertical: 2.0), // Sin margen horizontal
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Center(
                // Centrar el texto
                child: Text(
                  'Text $i',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
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
              height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              productName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              productPrice,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
