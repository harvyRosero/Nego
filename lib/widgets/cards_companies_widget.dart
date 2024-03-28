import 'package:flutter/material.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/utils/app_colors.dart';

Widget buildCompanyCard({
  required String nombre,
  required String descripcion,
  required String departamento,
  required String producto,
  required String imagenUrl,
  required String lugarCercano,
  required String ubicacion,
  required String contacto,
  // Agrega más parámetros según tus necesidades
}) {
  return InkWell(
    onTap: () {
      Get.toNamed(AppRoutes.companyInfo);
    },
    child: Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                // Cambio aquí
                imageUrl: imagenUrl, // URL de la imagen
                width: 100.0, // Ancho de la imagen
                height: 100.0, // Alto de la imagen
                fit: BoxFit.cover, // Ajuste de la imagen
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: AppColors.verdeNavbar,
                  strokeWidth: 2,
                ), // Widget que se muestra mientras se carga la imagen
                errorWidget: (context, url, error) => const Icon(Icons
                    .error), // Widget que se muestra si hay un error al cargar la imagen
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
                        color: Colors.grey,
                      ),
                      Text(
                        ubicacion,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Agrega más campos según tus necesidades
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildTransportistCard({
  required String camion,
  required String capacidadCarga,
  required String image,
  required String nombre,
  required String ubicacion,
  required String contacto,
}) {
  return InkWell(
    onTap: () {
      Get.toNamed(AppRoutes.companyInfo);
    },
    child: Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                // Cambio aquí
                imageUrl: image, // URL de la imagen
                width: 100.0, // Ancho de la imagen
                height: 100.0, // Alto de la imagen
                fit: BoxFit.cover, // Ajuste de la imagen
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: AppColors.verdeNavbar,
                  strokeWidth: 3,
                ), // Widget que se muestra mientras se carga la imagen
                errorWidget: (context, url, error) => const Icon(Icons
                    .error), // Widget que se muestra si hay un error al cargar la imagen
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
                        color: Colors.grey,
                      ),
                      Text(
                        ubicacion,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Agrega más campos según tus necesidades
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildStoreCard({
  required String tienda,
  required String ubicacion,
  required String contacto,
  required String image,
}) {
  return InkWell(
    onTap: () {
      Get.toNamed(AppRoutes.companyInfo);
    },
    child: Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                // Cambio aquí
                imageUrl: image, // URL de la imagen
                width: 100.0, // Ancho de la imagen
                height: 100.0, // Alto de la imagen
                fit: BoxFit.cover, // Ajuste de la imagen
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: AppColors.verdeNavbar,
                  strokeWidth: 2,
                ), // Widget que se muestra mientras se carga la imagen
                errorWidget: (context, url, error) => const Icon(Icons
                    .error), // Widget que se muestra si hay un error al cargar la imagen
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tienda,
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
                        color: Colors.grey,
                      ),
                      Text(
                        ubicacion,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Agrega más campos según tus necesidades
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
