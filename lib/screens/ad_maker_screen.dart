import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/ad_maker_controller.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AdMakerScreen extends StatelessWidget {
  final AdMakerController adMakerController = Get.put(AdMakerController());
  final TextEditingController _controller = TextEditingController();

  AdMakerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: AppColors.grisClaro,
              thickness: 0.5,
              height: 3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileImage(),
                _buildTextInputSection(),
              ],
            ),
            _buildCheckList(),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  // AppBar widget with close button and publish button
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        _buildPublishButton(context),
      ],
    );
  }

  // Publish button widget
  Widget _buildPublishButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: ElevatedButton(
          onPressed: () async {
            adMakerController.sendDataPublication(_controller.text);
            _controller.text = '';
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.verdeNavbar,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          ),
          child: const Text(
            "Publicar",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ));
  }

  // Profile image widget with CircleAvatar
  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Obx(() {
        final imageUrl = adMakerController.imageUrl.value;
        return CircleAvatar(
          radius: 25,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
        );
      }),
    );
  }

  // Text input section with TextField and Image Upload Container
  Widget _buildTextInputSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 15),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              maxLength: 300,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Escribe Aquí...",
              ),
            ),
            const SizedBox(height: 20),
            InkWell(onTap: () async {
              XFile? image = await adMakerController.getImage();
              if (image != null) {
                adMakerController.selectedImage.value = image.path;
              }
            }, child: Obx(() {
              final selectedImagePath = adMakerController.selectedImage.value;
              return selectedImagePath.isNotEmpty
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 400, // Altura máxima
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              15), // Redondea los bordes de la imagen
                          child: Image.file(
                            File(selectedImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.grisClaro,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                      ),
                    );
            })),
          ],
        ),
      ),
    );
  }

  // Checklist widget
  Widget _buildCheckList() {
    return Column(
      children: [
        Obx(() => RadioListTile<String>(
              title: const Text('Publicación normal'),
              value: 'publicacion_normal',
              groupValue: adMakerController.selectedOption.value,
              onChanged: (value) {
                adMakerController.selectedOption.value = value!;
              },
            )),
        Obx(() => RadioListTile<String>(
              title: const Text('Producto'),
              value: 'producto',
              groupValue: adMakerController.selectedOption.value,
              onChanged: (value) {
                adMakerController.selectedOption.value = value!;
              },
            )),
        Obx(() => RadioListTile<String>(
              title: const Text('Oferta de trabajo'),
              value: 'oferta_trabajo',
              groupValue: adMakerController.selectedOption.value,
              onChanged: (value) {
                adMakerController.selectedOption.value = value!;
              },
            )),
      ],
    );
  }
}
