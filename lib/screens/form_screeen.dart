import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/widgets/snackbars.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FormScreen extends StatelessWidget {
  final TextEditingController nombreFincaController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();
  final TextEditingController ciudadCercanaController = TextEditingController();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();

  FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userType = Get.arguments ?? "Cargando...";

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(userType),
          _buildBody(userType),
        ],
      ),
    );
  }

  Widget _buildHeader(String userType) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
              child: Text(
            userType,
            style: GoogleFonts.openSans(
                fontWeight: FontWeight.w700,
                color: AppColors.blanco,
                fontSize: 22),
          )),
          SizedBox(
            height: 20,
          )
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

  Widget _buildBody(String userType) {
    if (userType == 'Agricultor') {
      // Retorna el widget para Agricultor
      return _buildAgricultorForm();
    } else if (userType == 'Transportista') {
      // Retorna el widget para Transportista
      return _buildTransportistaForm();
    } else {
      // Retorna el widget para otros tipos de usuarios
      return _buildDefaultForm();
    }
  }

  Widget _buildAgricultorForm() {
    // Construye el formulario para Agricultor
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: nombreFincaController,
            decoration: InputDecoration(labelText: 'Nombre de la finca'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el nombre de la finca';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: ubicacionController,
            decoration: InputDecoration(labelText: 'Ubicación'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese la ubicación';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: ciudadCercanaController,
            decoration: InputDecoration(labelText: 'Ciudad cercana'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese la ciudad cercana';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: productoController,
            decoration: InputDecoration(labelText: 'Producto que produce'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el producto que produce';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: contactoController,
            decoration: InputDecoration(labelText: 'Contacto'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese el contacto';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nombreFincaController.text.isEmpty ||
                  ubicacionController.text.isEmpty ||
                  ciudadCercanaController.text.isEmpty ||
                  productoController.text.isEmpty ||
                  contactoController.text.isEmpty) {
                SnackbarUtils.error('Debe llenar todos los campos');
                return;
              }

              // Aquí puedes enviar los datos a donde sea necesario
              // Puedes acceder a los datos utilizando los controladores
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportistaForm() {
    // Construye el formulario para Transportista
    return Center(
      child: Text("Formulario para Transportista"),
    );
  }

  Widget _buildDefaultForm() {
    // Construye el formulario para otros tipos de usuarios
    return Center(
      child: Text("Formulario tienda agricola"),
    );
  }
}
