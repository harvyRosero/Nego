import 'package:flutter/material.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/utils/app_colors.dart';

Widget buildCompanyCard({
  required String nombre,
  required String categoria,
  required String fechaCreacion,
  required String imagePortada,
  required String descripcion,
  required String departamento,
  required String producto,
  required String estado,
  required String imagenUrl,
  required String lugarCercano,
  required String ubicacion,
  required String contacto,
}) {
  return InkWell(
    onTap: () {
      Get.toNamed(
        AppRoutes.companyInfo,
        arguments: {
          'nombre': nombre,
          'ubicacion': ubicacion,
          'contacto': contacto,
          'categoria': categoria,
          'image': imagenUrl,
          'departamento': departamento,
          'imagePortada': imagePortada,
          'descripcion': descripcion,
          'fechaCreacion': fechaCreacion
        },
      );
    },
    child: Card(
      color: AppColors.cardColor,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                imageUrl: imagenUrl,
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
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 88, 86, 86),
                    ),
                  ),
                  const SizedBox(height: 0.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 15,
                        color: AppColors.grisLetras,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        ubicacion,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: AppColors.grisLetras,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        size: 15,
                        color: AppColors.grisLetras,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        lugarCercano,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: AppColors.grisLetras,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_florist,
                        size: 15,
                        color: AppColors.grisLetras,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        producto,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: AppColors.grisLetras,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: estado == 'En cosecha'
                            ? AppColors.verdeLetras
                            : AppColors.grisLetras,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        estado,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: AppColors.grisLetras,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      const Icon(
                        Icons.star_rate,
                        color: AppColors.verdeButtons,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        departamento,
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grisLetras,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
