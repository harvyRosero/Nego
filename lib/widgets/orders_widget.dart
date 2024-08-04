import 'package:flutter/material.dart';

class OrdersWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;
  const OrdersWidget({super.key, required this.onScroll});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("mis ordes"));
  }
}
