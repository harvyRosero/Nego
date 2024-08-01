import 'package:agro/controllers/profile/all_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllOrdersScreen extends StatelessWidget {
  AllOrdersScreen({super.key});

  final AllOrdersController allOrdersController =
      Get.put(AllOrdersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
