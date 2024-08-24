import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/billing_controller.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';

class BillingScreen extends StatelessWidget {
  BillingScreen({super.key});
  final BillingController billingController = Get.put(BillingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturación'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles de Facturación',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Obx(() => _buildBillingDetailRow(
                  'Nombre', billingController.userName.value)),
              Obx(() => _buildBillingDetailRow(
                  'Dirección', billingController.direccion.value)),
              Obx(() => _buildBillingDetailRow(
                  'Teléfono', billingController.celular.value)),
              Obx(() => _buildBillingDetailRow(
                  'Correo Electrónico', billingController.gmail.value)),
              Obx(() => _buildBillingDetailRow(
                  'Ciudad', billingController.ciudad.value)),
              Obx(() => _buildBillingDetailRow(
                  'Barrio', billingController.barrio.value)),
              Obx(() => _buildBillingDetailRow('Detalles de Ubicación',
                  billingController.detallesUbicacion.value)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.configAddress,
                        arguments: {
                          'barrio': billingController.barrio.value,
                          'direccion': billingController.direccion.value,
                          'detallesDireccion':
                              billingController.detallesUbicacion.value,
                          'celular': billingController.celular.value,
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 15,
                    ),
                    label: const Text(
                      "Editar dirección",
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.gris,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Detalles de la Orden',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Obx(() => Column(
                    children: billingController.cartProducts.map((product) {
                      return _buildOrderDetailRow(
                        '${product.nombre} (x${product.cantidad})',
                        '\$ ${product.total.toStringAsFixed(2)}',
                      );
                    }).toList(),
                  )),
              const Divider(height: 32),
              Obx(() => _buildOrderDetailRow(
                    'Total',
                    '\$ ${billingController.totalSum.value.toStringAsFixed(2)}',
                    isTotal: true,
                  )),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    billingController.sendOrderToFirebase();
                    Get.offAllNamed(AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    backgroundColor: AppColors.verdeNavbar,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pagar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillingDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            maxLines: 2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(detail),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String title, String detail,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: isTotal
                  ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  : const TextStyle(),
            ),
          ),
          Text(
            detail,
            style: isTotal
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                : const TextStyle(),
          ),
        ],
      ),
    );
  }
}
