import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';

Widget buildStoreCard({
  required BuildContext context,
  required String tienda,
  required String ubicacion,
  required String categoria,
  required String contacto,
  required String image,
  required String departamento,
  required String imagePortada,
  required String descripcion,
  required String fechaCreacion,
}) {
  return InkWell(
    onTap: () {
      Get.toNamed(
        AppRoutes.companyInfo,
        arguments: {
          'nombre': tienda,
          'ubicacion': ubicacion,
          'contacto': contacto,
          'categoria': categoria,
          'image': image,
          'departamento': departamento,
          'imagePortada': imagePortada,
          'descripcion': descripcion,
          'fechaCreacion': fechaCreacion
        },
      );
    },
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40,
            ),
            Card(
              margin: const EdgeInsets.all(10.0),
              elevation: 5.0,
              child: SizedBox(
                  child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 55,
                    ),
                    Text(
                      tienda,
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      'Productos destacados:',
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                          color: AppColors.grisLetras),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 50.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(
                color: AppColors.verdeNavbar,
                strokeWidth: 2,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ],
    ),
  );
}
