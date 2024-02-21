import 'package:flutter/material.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('company'),
      ),
      body: SingleChildScrollView(
          child: Center(
              child:
                  ElevatedButton(onPressed: () {}, child: Text("Compania")))),
    );
  }
}
