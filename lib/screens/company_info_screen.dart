import 'package:flutter/material.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInfoContainer(),
            _buildRowButton(),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return Stack(
    children: [
      Container(
        height: 230,
      ),
      SizedBox(
        height: 180.0, // Altura solo para la imagen
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login_img.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 5,
        left: 20,
        child: Container(
          padding: const EdgeInsets.all(
              2), // Ajusta el espacio entre el borde y el avatar
          decoration: BoxDecoration(
            color: AppColors.blanco, // Color del borde
            shape: BoxShape.circle, // Forma del borde
            border: Border.all(
              color: AppColors.blanco, // Color del borde
              width: 2, // Ancho del borde
            ),
          ),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage('assets/gmail_logo.png'),
          ),
        ),
      ),
      Positioned(
          bottom: 0,
          right: 20,
          child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.phone),
              label: Text("WhatsApp"))),
    ],
  );
}

Widget _buildInfoContainer() {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "German Torees",
          style:
              GoogleFonts.openSans(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          "Agricultor",
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.normal, color: AppColors.grisLetras),
        ),
        Text(
          "Lorem asdfk kasjdf fksadjf ajskd fkjas fjasd fksajd fkasjd faskdjf askjd sk",
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.normal, color: AppColors.grisLetras),
        ),
        Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(
              width: 10,
            ),
            Text(
              'Bogota',
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal, color: AppColors.grisLetras),
            )
          ],
        ),
        Row(
          children: [
            Icon(Icons.calendar_month),
            SizedBox(
              width: 10,
            ),
            Text(
              'Se unio en marxo 2025',
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal, color: AppColors.grisLetras),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

Widget _buildRowButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      InkWell(
        child: Text("Productos"),
      ),
      InkWell(
        child: Text("Publicaciones"),
      )
    ],
  );
}
