import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:agro/controllers/profile/terms_and_politics_controller.dart';

class TermsAndPoliticsScreen extends StatelessWidget {
  final TermsAndPoliticsController _controller =
      Get.put(TermsAndPoliticsController());

  TermsAndPoliticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Políticas de privacidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildButton(
                  context,
                  'Términos y condiciones',
                  Icons.article,
                  () => _controller.updateDataList('tyc'),
                  _controller.selectedButton.value == 'tyc',
                )),
            const SizedBox(height: 10),
            Obx(() => _buildButton(
                  context,
                  'Política de privacidad',
                  Icons.privacy_tip,
                  () => _controller.updateDataList('pdp'),
                  _controller.selectedButton.value == 'pdp',
                )),
            const SizedBox(height: 20),

            // Mostrar imágenes solo cuando `showImages` sea true
            Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!_controller.showImages.value) {
                return const SizedBox.shrink();
              }

              final dataList = _controller.selectedCategory.value == 'pdp'
                  ? _controller.dataList
                  : _controller.dataListTyc;

              return Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    String imageUrl = dataList[index].values.first;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Text('Error al cargar la imagen'));
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed, bool isSelected) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.verdeNavbar : AppColors.grisClaro2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : AppColors.verdeNavbar),
            Text(
              text,
              style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.verdeNavbar),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isSelected ? Colors.white : AppColors.verdeNavbar,
            ),
          ],
        ),
      ),
    );
  }
}
