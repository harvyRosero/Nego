import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home_controller2.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/routes/app_routes.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController2 _homeController2 = Get.put(HomeController2());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _homeController2.toggleBottomNav(false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _homeController2.toggleBottomNav(true);
      }
    });

    return Scaffold(
      body: Obx(() {
        return _buildBodyContent();
      }),
      bottomNavigationBar: Obx(() {
        return _buildBottomNavigationBar();
      }),
      floatingActionButton: Obx(() {
        return _buildFloatingActionButton();
      }),
    );
  }

  Widget _buildBodyContent() {
    switch (_homeController2.currentScreen.value) {
      case 'Home':
        return _buildHomeScreen();
      case 'Search':
        return _buildSearchScreen();
      case 'Notifications':
        return _buildNotificationsScreen();
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }

  Widget _buildHomeScreen() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        Obx(() {
          return Container();
        }),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       final publicacion = _homeController2.publicaciones[index];
        //       return ListTile(
        //         title: Text(publicacion['userName'] ?? 'Sin título'),
        //         subtitle: Text(publicacion['content'] ?? 'Sin descripción'),
        //       );
        //     },
        //     childCount: _homeController2.publicaciones.length,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSearchScreen() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        Obx(() {
          return buildSliverAppBar();
        }),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('Search Screen Content'),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsScreen() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        Obx(() {
          return buildSliverAppBar();
        }),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('Notifications Screen Content'),
          ),
        ),
      ],
    );
  }

  SliverAppBar buildSliverAppBar() {
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
        padding: const EdgeInsets.only(top: 70.0, right: 10.0, left: 10.0),
        child: _buildNavigationButtons(),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
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
          style: const TextStyle(
            color: AppColors.grisLetras,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return _homeController2.isBottomNavVisible.value
        ? BottomNavigationBar(
            currentIndex: _getCurrentTabIndex(),
            selectedItemColor: AppColors.verdeNavbar,
            unselectedItemColor: AppColors.gris,
            onTap: _onBottomNavTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notificaciones',
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  int _getCurrentTabIndex() {
    switch (_homeController2.currentScreen.value) {
      case 'Home':
        return 0;
      case 'Search':
        return 1;
      case 'Notifications':
        return 2;
      default:
        return 0;
    }
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        _homeController2.changeScreen('Home');
        break;
      case 1:
        _homeController2.changeScreen('Search');
        break;
      case 2:
        _homeController2.changeScreen('Notifications');
        break;
    }
  }

  Widget _buildFloatingActionButton() {
    return _homeController2.isBottomNavVisible.value
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
        : const SizedBox.shrink();
  }

  Widget _buildCircleAvatar() {
    return FutureBuilder(
      future: _homeController2.getPhotoUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? photo = snapshot.data;
          return GestureDetector(
            onTap: () async {
              // Get.toNamed(AppRoutes.profile);
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
