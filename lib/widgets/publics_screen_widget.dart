import 'package:flutter/material.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/publics_screen_controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/widgets/item_widets.dart';

class PublicsScreenWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  final PublicScreenController publicScreenController =
      Get.put(PublicScreenController());

  PublicsScreenWidget({super.key, required this.onScroll});

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
          Obx(() {
            final filteredPublicaciones =
                publicScreenController.filteredPublicaciones;
            return filteredPublicaciones.isNotEmpty
                ? buildSliverList(filteredPublicaciones)
                : const SliverFillRemaining(
                    child: Center(
                      child: Text('No hay datos disponibles'),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      title: _buildAppBarContent(),
      floating: true,
      snap: true,
      expandedHeight: 105,
      flexibleSpace: FlexibleSpaceBar(
        background: buildHeader(),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleAvatar(),
          _buildLogoContainer(),
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      decoration: buildBackgroundDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 90.0, right: 10.0, left: 10.0),
        child: _buildNavigationButtons(publicScreenController),
      ),
    );
  }

  Widget _buildNavigationButtons(PublicScreenController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
          buildNavigationButton(controller, "Noticias"),
          buildNavigationButton(controller, "Productos"),
          buildNavigationButton(controller, "Empresas"),
          buildNavigationButton(controller, "Ofertas de trabajo"),
        ],
      ),
    );
  }

  Widget buildNavigationButton(PublicScreenController controller, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.5),
      child: Obx(() {
        final isSelected = controller.selectedButton.value == text;
        return TextButton(
          onPressed: () {
            controller.selectButton(text);
          },
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.grisLetras,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }

  Widget buildSliverList(List<Map<String, dynamic>> publicaciones) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = publicaciones[index];
          if (publicScreenController.selectedButton.value == 'Empresas') {
            return buildEmpresaItem(item);
          } else {
            return buildPublicacionItem(item);
          }
        },
        childCount: publicaciones.length,
      ),
    );
  }

  Widget _buildCircleAvatar() {
    return FutureBuilder<String?>(
      future: publicScreenController.getPhotoUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? photo = snapshot.data;
          return GestureDetector(
            onTap: () {
              // Get.toNamed(AppRoutes.profile);
            },
            child: SizedBox(
              height: 30,
              child: CircleAvatar(
                backgroundImage:
                    photo != null ? CachedNetworkImageProvider(photo) : null,
                child: photo == null ? const Icon(Icons.person) : null,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLogoContainer() {
    return SizedBox(
      height: 40,
      child: Image.asset(
        'assets/logo_sl_white.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSettingsButton() {
    return IconButton(
      icon: const Icon(
        Icons.settings_outlined,
        size: 30,
        color: AppColors.blanco,
      ),
      onPressed: () {},
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
}
