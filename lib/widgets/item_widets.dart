import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget buildEmpresaItem(Map<String, dynamic> empresa) {
  final createdAt = empresa['createdAt'] != null
      ? DateTime.parse(empresa['createdAt'])
      : DateTime.now();
  final timeAgo = timeago.format(createdAt);

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
                    empresa['companyName'] ?? 'Nombre de la empresa',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                  Text(empresa['description'] ?? 'Descripción'),
                  Text(
                    timeAgo,
                    style: const TextStyle(color: AppColors.grisLetras),
                  ),
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
                                    child: LinearProgressIndicator()),
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
  final createdAt = publicacion['createdAt'] != null
      ? DateTime.parse(publicacion['createdAt'])
      : DateTime.now();
  final timeAgo = timeago.format(createdAt);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        publicacion['userName'] ?? 'Nombre de usuario',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                            color: AppColors.grisLetras, fontSize: 10),
                      ),
                    ],
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
                                    child: LinearProgressIndicator(
                                  color: AppColors.verdeNavbar,
                                )),
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
