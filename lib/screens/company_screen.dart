import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/companies_controller.dart';
import 'package:agro/widgets/cards_companies_widget.dart';

class CompanyScreen extends StatelessWidget {
  CompanyScreen({Key? key}) : super(key: key); // Corrección aquí

  final CompaniesController companiesController =
      Get.put(CompaniesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (companiesController.isButton1Enabled.value) {
                return _buildCompanyList();
              } else if (companiesController.isButton2Enabled.value) {
                return _buildTransportList();
              } else {
                return _buildStoreList();
              }
            }),
          ),
          _buildButtonRow(),
        ],
      ),
    );
  }

  Widget _buildCompanyList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('empresas').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              if (doc['categoria'] == 'Empresa Agricultora') {
                return buildCompanyCard(
                  nombre: doc['nombre'],
                  descripcion: doc['descripcion'],
                  departamento: doc['departamento'],
                  producto: doc['producto'],
                  imagenUrl: doc['imagePerfil'],
                  lugarCercano: doc['lugarCercano'],
                  ubicacion: doc['ubicacion'],
                  contacto: doc['contacto'],
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }

  Widget _buildTransportList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('empresas').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              if (doc['categoria'] == 'Transportista') {
                return buildTransportistCard(
                  nombre: doc['nombre'],
                  camion: doc['camion'],
                  image: doc['image'],
                  capacidadCarga: doc['capacidadCarga'],
                  ubicacion: doc['ubicacion'],
                  contacto: doc['contacto'],
                );
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }

  Widget _buildStoreList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('empresas').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              if (doc['categoria'] == 'Tienda') {
                return buildStoreCard(
                    tienda: doc['tienda'],
                    ubicacion: doc['ubicacion'],
                    contacto: doc['contacto'],
                    image: doc['image']);
              } else {
                return Container();
              }
            },
          );
        }
      },
    );
  }

  Widget _buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                text: 'Empresas',
                icon: Icons.eco,
                onTap: () {
                  companiesController.toggleButton1();
                },
                isEnabled: companiesController.isButton1Enabled,
              ),
              _buildButton(
                text: 'transporte',
                icon: Icons.local_shipping,
                onTap: () {
                  companiesController.toggleButton2();
                },
                isEnabled: companiesController.isButton2Enabled,
              ),
              _buildButton(
                text: 'tiendas',
                icon: Icons.store,
                onTap: () {
                  companiesController.toggleButton3();
                },
                isEnabled: companiesController.isButton3Enabled,
              ),
              _buildButton(
                text: 'Buscar',
                icon: Icons.search,
                onTap: () {
                  Get.toNamed('search');
                },
                isEnabled: false.obs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
    required RxBool isEnabled, // Cambia de bool a RxBool
  }) {
    return Obx(() => InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Icon(
                  icon,
                  color: isEnabled.value
                      ? AppColors.verdeClaro
                      : AppColors.verdeNavbar, // Accede al valor usando .value
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: GoogleFonts.openSans(
                  color: isEnabled.value
                      ? AppColors.verdeLetras
                      : AppColors.verdeNavbar,
                  fontWeight: FontWeight.bold,
                  fontSize: 9.0,
                ),
              ),
            ],
          ),
        ));
  }
}
