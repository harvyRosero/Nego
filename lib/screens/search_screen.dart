import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/controllers/search_controller.dart';
import 'package:agro/utils/app_colors.dart';

class SearchScreen extends StatelessWidget {
  final MySearchController searchController = Get.put(MySearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              searchController.getDataPublic();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (searchController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (searchController.publicaciones.isEmpty) {
          return Center(child: Text('No hay publicaciones'));
        } else {
          return CustomScrollView(
            slivers: [
              buildSliverList(searchController.publicaciones),
            ],
          );
        }
      }),
    );
  }

  SliverList buildSliverList(List<Map<String, dynamic>> publicaciones) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var publicacion = publicaciones[index];

          return Padding(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: publicacion['photoProfile'] != null
                          ? NetworkImage(publicacion['photoProfile'])
                          : const AssetImage('assets/logo_nego.png')
                              as ImageProvider,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            publicacion['userName'] ?? 'Nombre de usuario',
                            textAlign: TextAlign.left,
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.bold),
                          ),
                          Text(publicacion['content'] ?? 'Contenido'),
                          if (publicacion['imgUrl'] != null &&
                              publicacion['imgUrl'].isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 400, // Altura máxima
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            15), // Redondea los bordes de la imagen
                                        child: Image.network(
                                          publicacion['imgUrl'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Text(
                                                  'Error al cargar la imagen'),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.8,
                  color: AppColors.grisClaro,
                )
              ],
            ),
          );
        },
        childCount: publicaciones.length,
      ),
    );
  }
}
