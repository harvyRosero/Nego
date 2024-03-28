import 'package:flutter/material.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [_buildHeader()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.blanco,
                  )),
              const Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blanco)),
                    hintText: 'Buscar',
                    hintStyle: TextStyle(color: AppColors.blanco)),
              )),
              Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.blanco,
                        size: 30,
                      ))),
            ],
          ),
          const SizedBox(height: 20)
        ],
      ),
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
}
