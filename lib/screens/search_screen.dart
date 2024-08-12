import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:agro/controllers/search_controller.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final MySearchController mySearchController = Get.put(MySearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: TextField(
              controller: mySearchController.searchTextController,
              onChanged: (value) {
                mySearchController.updateSearchQuery(value);
              },
              decoration: const InputDecoration(
                hintText: '¿Qué estás buscando?',
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.verdeNavbar),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categorías:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 80, // Ajusta la altura según sea necesario
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryIcon(Icons.local_bar, 'Licores'),
                    const SizedBox(width: 10),
                    _buildCategoryIcon(Icons.fastfood, 'Comidas rapidas'),
                    const SizedBox(width: 10),
                    _buildCategoryIcon(Icons.icecream, 'Postres'),
                    const SizedBox(width: 10),
                    _buildCategoryIcon(Icons.local_cafe, 'bebidas'),
                    const SizedBox(width: 10),
                    _buildCategoryIcon(Icons.kitchen, 'Embutidos'),

                    // Agrega más iconos según sea necesario
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Container(
      width: 80, // Ajusta el tamaño del contenedor según sea necesario
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.verdeNavbar),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
