import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/billing_controller.dart';
import 'package:agro/routes/app_routes.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:intl/intl.dart';

class BillingScreen extends StatelessWidget {
  BillingScreen({super.key});
  final BillingController controller = Get.put(BillingController());

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 2,
    );

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
              Obx(() =>
                  _buildBillingDetailRow('Nombre', controller.userName.value)),
              Obx(() => _buildBillingDetailRow(
                  'Dirección', controller.direccion.value)),
              Obx(() =>
                  _buildBillingDetailRow('Teléfono', controller.celular.value)),
              Obx(() => _buildBillingDetailRow(
                  'Correo Electrónico', controller.gmail.value)),
              Obx(() =>
                  _buildBillingDetailRow('Ciudad', controller.ciudad.value)),
              Obx(() =>
                  _buildBillingDetailRow('Barrio', controller.barrio.value)),
              Obx(() => _buildBillingDetailRow(
                  'Detalles de Ubicación', controller.detallesUbicacion.value)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Container()),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.configAddress,
                        arguments: {
                          'barrio': controller.barrio.value,
                          'direccion': controller.direccion.value,
                          'detallesDireccion':
                              controller.detallesUbicacion.value,
                          'celular': controller.celular.value,
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
                    children: controller.cartProducts.map((product) {
                      return _buildOrderDetailRow(
                        '${product.nombre} (x${product.cantidad})',
                        currencyFormat.format(product.total),
                      );
                    }).toList(),
                  )),
              Obx(() => _buildOrderDetailRow(
                    'Costo Domicilio',
                    currencyFormat.format(controller.costoDom.value),
                  )),
              const Divider(height: 32),
              Obx(() => _buildOrderDetailRow(
                    'Total',
                    currencyFormat.format(controller.totalSum.value),
                    isTotal: true,
                  )),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Mostrar cuadro de diálogo de confirmación
                    Get.defaultDialog(
                      title: '¿Confirmas tu Pedido?',
                      titleStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.verdeNavbar,
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 60,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Al confirmar este pedido, aceptas realizar el pago al recibirlo. '
                              'Incumplir con el pago puede resultar en la inhabilitación de tu cuenta y posibles acciones legales según nuestras políticas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      textConfirm: 'Confirmar Pedido',
                      textCancel: 'Cancelar',
                      confirmTextColor: Colors.white,
                      cancelTextColor: AppColors.grisLetras,
                      buttonColor: AppColors.verdeNavbar,
                      onConfirm: () {
                        controller.sendOrderToFirebase();
                        Get.offAllNamed(AppRoutes.home);
                      },
                      onCancel: () {
                        Get.back();
                      },
                      radius: 10,
                      barrierDismissible: false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    backgroundColor: AppColors.verdeNavbar,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Pagar contra entrega',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
