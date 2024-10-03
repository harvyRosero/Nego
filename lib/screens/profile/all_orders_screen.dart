import 'package:agro/controllers/profile/all_orders_controller.dart';
import 'package:agro/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
              return OrderCard(
                order: Map<String, dynamic>.from(order),
                products: order['products'] ?? [],
              );
            },
          );
        }
      }),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final List<dynamic> products;

  const OrderCard({Key? key, required this.order, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime orderDate =
        DateTime.parse(order['createdAt'] ?? DateTime.now().toIso8601String());

    final Map<String, Color> stateColors = {
      'Pedido recibido': AppColors.naranjaAdvertencia,
      'En camino': AppColors.verdeNavbar,
      'Entregado': AppColors.azulClaro,
    };

    final Map<String, IconData> stateIcons = {
      'Pedido recibido': Icons.new_releases,
      'En camino': Icons.local_shipping,
      'Entregado': Icons.check_circle,
    };

    final String state = order['state'];
    final Color color = stateColors[state] ?? Colors.grey;
    final IconData icon = stateIcons[state] ?? Icons.info;

    return Card(
      elevation: 3.0,
      color: AppColors.blanco,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        childrenPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primera fila: Pedido y fecha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Cliente - ${order['userName']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColors.verdeNavbar,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  timeago.format(orderDate, locale: 'es'),
                  style: const TextStyle(fontSize: 13.0, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            // Segunda fila: Barrio y Ciudad
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18.0, color: AppColors.grisLetras),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    'Barrio: ${order['barrio']}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: AppColors.grisLetras,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            // Tercera fila: Estado del pedido

            Row(
              children: [
                const Icon(Icons.location_city,
                    size: 18.0, color: AppColors.grisLetras),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    'Ciudad: ${order['ciudad']}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: AppColors.grisLetras,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6.0),

            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8.0),
                Text(
                  state,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            )
          ],
        ),
        children: [
          const Divider(),
          _buildInfoSection(
            context: context,
            title: 'Información Personal',
            rows: [
              _buildInfoRow(Icons.person, 'Nombre', order['userName']),
              _buildInfoRow(Icons.email, 'Gmail', order['gmail']),
              _buildInfoRow(Icons.phone, 'Celular', order['celular']),
            ],
          ),
          _buildInfoSection(
            context: context,
            title: 'Dirección de Entrega',
            rows: [
              _buildInfoRow(Icons.home, 'Dirección', order['direccion']),
              _buildInfoRow(Icons.location_city, 'Barrio', order['barrio']),
              _buildInfoRow(Icons.location_city, 'Ciudad', order['ciudad']),
              _buildInfoRow(Icons.info, 'Detalles', order['detallesUbicacion']),
            ],
          ),
          _buildProductsSection(products),
          const SizedBox(height: 8.0),
          _buildTotalAmount(),
          _buildStateRow(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      {required BuildContext context,
      required String title,
      required List<Widget> rows}) {
    return _buildCard(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        ...rows,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.verdeNavbar),
        const SizedBox(width: 8.0),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection(List<dynamic> products) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 1,
    );

    return _buildCard(
      children: [
        const Text(
          'Productos',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12.0),
        products.isEmpty
            ? const Center(child: Text('No hay productos en este pedido'))
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: CachedNetworkImageProvider(
                              product['imagen'] ?? ''),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['nombre'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                'Cantidad: X${product['cantidad']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (product['promo'] != 0.0)
                                Text(
                                  'Promo: ${currencyFormat.format(product['promo'])}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              Text(
                                'Precio: ${currencyFormat.format(product['precio'])}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grisLetras),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      color: AppColors.blanco,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es',
      symbol: 'COP',
      decimalDigits: 1,
    );

    return Text(
      'Total: ${currencyFormat.format(order['totalSum'])}',
      style: const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }

  Widget _buildStateRow() {
    final Map<String, Color> stateColors = {
      'Pedido recibido': AppColors.naranjaAdvertencia,
      'En camino': AppColors.verdeNavbar,
      'Entregado': AppColors.azulClaro,
    };

    final Map<String, IconData> stateIcons = {
      'Pedido recibido': Icons.new_releases,
      'En camino': Icons.local_shipping,
      'Entregado': Icons.check_circle,
    };

    final String state = order['state'];
    final Color color = stateColors[state] ?? Colors.grey;
    final IconData icon = stateIcons[state] ?? Icons.info;

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8.0),
        Text(
          state,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
