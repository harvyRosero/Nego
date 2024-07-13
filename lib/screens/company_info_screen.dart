import 'package:flutter/material.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final String categoria = args['categoria'];
    if (categoria == 'transportista') {
      // final String capacidadCarga = args['capacidadCarga'];
      // final String tipoCarga = args['tipoCarga'];
    }
    final String nombre = args['nombre'];
    final String ubicacion = args['ubicacion'];
    final String contacto = args['contacto'];
    final String image = args['image'];
    final String descripcion = args['descripcion'];
    final String fechaCreacion = args['fechaCreacion'];
    final String imagePortada = args['imagePortada'];
    final String departamento = args['departamento'];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(image, imagePortada, contacto),
            _buildInfoContainer(nombre, categoria, descripcion, ubicacion,
                departamento, fechaCreacion),
            _buildRowButton(),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(image, imagePortada, contacto) {
  return Stack(
    children: [
      Container(
        height: 230,
      ),
      SizedBox(
        height: 180.0,
        width: double.infinity, // Ocupa todo el ancho de la pantalla
        child: CachedNetworkImage(
          imageUrl: imagePortada,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      Positioned(
        bottom: 5,
        left: 20,
        child: Container(
          padding: const EdgeInsets.all(
              2), // Ajusta el espacio entre el borde y el avatar
          decoration: BoxDecoration(
            color: AppColors.blanco, // Color del borde
            shape: BoxShape.circle, // Forma del borde
            border: Border.all(
              color: AppColors.blanco, // Color del borde
              width: 2, // Ancho del borde
            ),
          ),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(image),
          ),
        ),
      ),
      Positioned(
          bottom: 0,
          right: 20,
          child: Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 5,
              ),
              Text(
                contacto,
                style: GoogleFonts.openSans(
                    color: AppColors.grisLetras, fontWeight: FontWeight.bold),
              )
            ],
          )),
    ],
  );
}

Widget _buildInfoContainer(
    tienda, categoria, descripion, ubicacion, departamento, fechaCreacion) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 13,
      right: 13,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tienda,
          style:
              GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          categoria,
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: AppColors.grisLetras,
              fontSize: 14),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          descripion,
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.normal, color: AppColors.grisLetras),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(
              width: 10,
            ),
            Text(
              ubicacion,
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal, color: AppColors.grisLetras),
            )
          ],
        ),
        Row(
          children: [
            const Icon(Icons.location_city),
            const SizedBox(
              width: 10,
            ),
            Text(
              departamento,
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal, color: AppColors.grisLetras),
            )
          ],
        ),
        Row(
          children: [
            const Icon(Icons.calendar_month),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Se unio el $fechaCreacion',
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal, color: AppColors.grisLetras),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Widget _buildRowButton() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      InkWell(
        child: Text("Productos"),
      ),
      InkWell(
        child: Text("Publicaciones"),
      )
    ],
  );
}
