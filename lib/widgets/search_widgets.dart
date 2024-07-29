import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Home Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Product Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
