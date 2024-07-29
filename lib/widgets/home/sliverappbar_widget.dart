import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget buildSliverAppBar() {
  return SliverAppBar(
    title: _buildAppBarContent(),
    floating: true,
    snap: true,
    expandedHeight: 125,
    flexibleSpace: FlexibleSpaceBar(
      background: _buildHeader(),
    ),
  );
}

Widget _buildAppBarContent() {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogoContainer(),
        _buildShoppingCartButton(),
      ],
    ),
  );
}

Widget _buildHeader() {
  return Container(
    decoration: _buildBackgroundDecoration(),
    child: Padding(
      padding: const EdgeInsets.only(
          top: 100.0, right: 20.0, left: 20.0, bottom: 15),
      child: _buildSearchButton(),
    ),
  );
}

Widget _buildSearchButton() {
  return Container(
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4.0,
          spreadRadius: 1.0,
        ),
      ],
    ),
    child: const Row(
      children: [
        Icon(Icons.search, color: Colors.grey),
        SizedBox(width: 8.0),
        Expanded(
            child: Text(
          "¿Que estas buscando?",
          style: TextStyle(color: AppColors.grisLetras),
        )),
      ],
    ),
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

Widget _buildShoppingCartButton() {
  return IconButton(
    icon: const Icon(
      Icons.shopping_cart,
      size: 30,
      color: AppColors.blanco,
    ),
    onPressed: () {},
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
