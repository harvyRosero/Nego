import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agro/controllers/home_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/screens/me_screen.dart';
import 'package:agro/screens/news_screen.dart';
import 'package:agro/screens/company_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());
  final PageController _pageController = PageController();

  final List<Widget> pages = [
    NewsScreen(),
    CompanyScreen(),
    MeScreen(),
  ];

  HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        _buildPageView(),
      ],
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
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

  Widget _buildHeader() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLogoContainer(),
                _buildCircleAvatar(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildNavigationButtons(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoContainer() {
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.asset('assets/logo_sl_white.png'),
    );
  }

  Widget _buildCircleAvatar() {
    return FutureBuilder(
      future: _controller.getPhotoUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? photo = snapshot.data;
          return GestureDetector(
            onTap: () {
              Get.toNamed('profile');
            },
            child: CircleAvatar(
              radius: 13,
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null ? const Icon(Icons.person) : null,
            ),
          );
        }
      },
    );
  }

  Widget _buildNavigationButtons() {
    List<String> buttonTexts = ['Noticias', 'Empresas', 'Yo'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        pages.length,
        (index) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent, // Texto blanco
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Bordes menos redondeados
            ),
          ),
          onPressed: () {
            _pageController.jumpToPage(index);
          },
          child: Text(
            buttonTexts[index],
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
    );
  }
}
