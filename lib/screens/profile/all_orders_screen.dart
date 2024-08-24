import 'package:agro/controllers/profile/all_orders_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllOrdersScreen extends StatelessWidget {
  AllOrdersScreen({super.key});

  final AllOrdersController allOrdersController =
      Get.put(AllOrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pedidos'),
      ),
      body: Obx(() {
        if (allOrdersController.filteredOrdersList.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron pedidos.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: allOrdersController.filteredOrdersList.length,
            itemBuilder: (context, index) {
              final order = allOrdersController.filteredOrdersList[index];
              DateTime orderDate = DateTime.parse(
                  order['createdAt'] ?? DateTime.now().toIso8601String());
              return Card(
                color: AppColors.grisClaro2,
                elevation: 6,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                shadowColor: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderDate(orderDate),
                      Text(
                        'Pedido ID: ${order['documentId']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Usuario: ${order['userName']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Fecha: ${order['createdAt']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              'Total: \$ ${order['totalSum']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Acción al presionar el botón (e.g., ver detalles)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          icon: const Icon(Icons.visibility, size: 20),
                          label: const Text('Ver Detalles'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildOrderDate(DateTime orderDate) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        timeago.format(orderDate, locale: 'es'),
        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
    );
  }
}
