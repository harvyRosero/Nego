import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agro/controllers/home_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

SliverAppBar buildSliverAppBar(VoidCallback refreshData) {
  return SliverAppBar(
    title: buildAppBarContent(refreshData),
    floating: true,
    snap: true,
    expandedHeight: 125,
    flexibleSpace: FlexibleSpaceBar(
      background: buildHeader(refreshData),
    ),
  );
}

Widget buildAppBarContent(VoidCallback refreshData) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCircleAvatar(),
        buildLogoContainer(),
        buildSettingsButton(),
      ],
    ),
  );
}

Widget buildHeader(VoidCallback refreshData) {
  return Container(
    decoration: buildBackgroundDecoration(),
    child: Padding(
      padding: const EdgeInsets.only(top: 110.0, right: 10.0, left: 10.0),
      child: buildNavigationButtons(refreshData),
    ),
  );
}

BoxDecoration buildBackgroundDecoration() {
  return const BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
    ),
    gradient: LinearGradient(
      colors: [AppColors.verdeNavbar, AppColors.verdeNavbar2],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

Widget buildCircleAvatar() {
  final HomeController controller = Get.put(HomeController());

  return FutureBuilder(
    future: controller.getPhotoUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        String? photo = snapshot.data;
        return GestureDetector(
          onTap: () async {
            Get.toNamed(AppRoutes.profile);
          },
          child: SizedBox(
            height: 30,
            child: CircleAvatar(
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null ? const Icon(Icons.person) : null,
            ),
          ),
        );
      }
    },
  );
}

Widget buildLogoContainer() {
  return SizedBox(
    height: 40,
    child: Image.asset(
      'assets/logo_sl_white.png',
      fit: BoxFit.cover,
    ),
  );
}

Widget buildSettingsButton() {
  return IconButton(
    icon: const Icon(
      Icons.settings_outlined,
      size: 30,
      color: AppColors.blanco,
    ),
    onPressed: () {},
  );
}

Widget buildNavigationButtons(VoidCallback refreshData) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: refreshData, icon: const Icon(Icons.refresh)),
        buildNavigationButton("Noticias"),
        buildNavigationButton("Productos"),
        buildNavigationButton("Empresas"),
        buildNavigationButton("Ofertas de trabajo"),
      ],
    ),
  );
}

Widget buildNavigationButton(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.5),
    child: TextButton(
      onPressed: () {
        if (text == 'Noticias') {
          print("hola");
        }
      },
      child: Text(
        text,
        style: GoogleFonts.openSans(
          color: AppColors.grisLetras,
          fontSize: 16,
        ),
      ),
    ),
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
                              const SizedBox(height: 8),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 400, // Altura máxima
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: publicacion['imgUrl'],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Text(
                                              'Error al cargar la imagen'),
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
              const Divider(
                thickness: 0.8,
                color: AppColors.grisClaro,
              ),
            ],
          ),
        );
      },
      childCount: publicaciones.length,
    ),
  );
}

Widget buildAnimatedBottomNavigationBar(
    ValueNotifier<bool> isBottomNavBarVisible) {
  return ValueListenableBuilder<bool>(
    valueListenable: isBottomNavBarVisible,
    builder: (context, isVisible, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isVisible ? kBottomNavigationBarHeight : 0.0,
        child: isVisible
            ? buildBottomNavigationBarContent()
            : const SizedBox.shrink(),
      );
    },
  );
}

Widget buildBottomNavigationBarContent() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.home, size: 30),
      ),
      IconButton(
        onPressed: () {
          Get.toNamed(AppRoutes.search);
        },
        icon: const Icon(Icons.search, size: 30),
      ),
      IconButton(
        onPressed: () {
          Get.toNamed(AppRoutes.form);
        },
        icon: const Icon(Icons.notifications, size: 30),
      ),
    ],
  );
}

Widget buildAnimatedFloatingActionButton(ValueNotifier<bool> isFabVisible) {
  return ValueListenableBuilder<bool>(
    valueListenable: isFabVisible,
    builder: (context, isVisible, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isVisible ? 56.0 : 0.0,
        child: isVisible
            ? FloatingActionButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.adMaker);
                },
                backgroundColor: AppColors.verdeNavbar2,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: AppColors.verdeNavbar,
                ),
              )
            : const SizedBox.shrink(),
      );
    },
  );
}
