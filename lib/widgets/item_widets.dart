// lib/widgets/item_widgets.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/utils/app_colors.dart';

Widget buildEmpresaItem(Map<String, dynamic> empresa) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: empresa['logoUrl'] != null
                  ? CachedNetworkImageProvider(empresa['logoUrl'])
                  : const AssetImage('assets/logo_empresa.png')
                      as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empresa['name'] ?? 'Nombre de la empresa',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                  Text(empresa['description'] ?? 'Descripción'),
                  if (empresa['imgUrl'] != null && empresa['imgUrl'].isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: empresa['imgUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        const Divider(thickness: 0.8, color: AppColors.grisClaro),
      ],
    ),
  );
}

Widget buildPublicacionItem(Map<String, dynamic> publicacion) {
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
                  ? CachedNetworkImageProvider(publicacion['photoProfile'])
                  : const AssetImage('assets/logo_nego.png') as ImageProvider,
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
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                  Text(publicacion['content'] ?? 'Contenido'),
                  if (publicacion['imgUrl'] != null &&
                      publicacion['imgUrl'].isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: publicacion['imgUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        const Divider(thickness: 0.8, color: AppColors.grisClaro),
      ],
    ),
  );
}
