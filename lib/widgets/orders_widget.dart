import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:agro/controllers/orders_controller.dart';
import 'package:agro/utils/app_colors.dart';

class OrdersWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;

  const OrdersWidget({Key? key, required this.onScroll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrdersController ordersController = Get.put(OrdersController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Pedidos',
            style: TextStyle(
                color: AppColors.verdeNavbar,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Obx(
            () => ordersController.ordersList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 80.0,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'No se encontraron órdenes',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Parece que no tienes órdenes pendientes en este momento. \nLas órdenes que realices aparecerán aquí.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: ordersController.ordersList.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> order =
                          Map<String, dynamic>.from(
                              ordersController.ordersList[index]);
                      final List<dynamic> products = order['products'] ?? [];

                      return OrderCard(order: order, products: products);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final List<dynamic> products;

  OrderCard({Key? key, required this.order, required this.products})
      : super(key: key);

  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    DateTime orderDate =
        DateTime.parse(order['createdAt'] ?? DateTime.now().toIso8601String());

    return Card(
      elevation: 6.0,
      color: AppColors.grisClaro2,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderDate(orderDate),
            _buildOrderDetails(),
            const SizedBox(height: 16.0),
            const Divider(thickness: 1.2, color: AppColors.grisClaro),
            const SizedBox(height: 16.0),
            _buildProductToggle(),
            const SizedBox(height: 12.0),
            _buildProductList(),
            const SizedBox(height: 16.0),
            const Divider(thickness: 1.2, color: AppColors.gris),
            const SizedBox(height: 16.0),
            _buildTotalAmount(),
            const SizedBox(height: 16.0),
            _buildStateRow(),
            const SizedBox(height: 20.0),
            _buildActionButton(),
          ],
        ),
      ),
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

  Widget _buildOrderDetails() {
    return Column(
      children: [
        _buildOrderDetail('Pedido ID:', order['documentId']),
        _buildOrderDetail('Nombre:', order['userName']),
        _buildOrderDetail('Barrio:', order['barrio']),
        _buildOrderDetail('Dirección:', order['direccion']),
        _buildOrderDetail('Ciudad:', order['ciudad']),
        _buildOrderDetail('Detalles:', order['detallesUbicacion']),
      ],
    );
  }

  Widget _buildOrderDetail(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text('$value'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductToggle() {
    return Obx(
      () => Row(
        children: [
          const Text(
            'Productos:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.showProducts.value = !controller.showProducts.value;
            },
            icon: controller.showProducts.value
                ? const Icon(Icons.arrow_drop_up)
                : const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(
      () {
        if (controller.showProducts.value) {
          return Column(
            children: _buildProductItems(products),
          );
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> _buildProductItems(List<dynamic> products) {
    return products.map((product) {
      final Map<String, dynamic> productData =
          Map<String, dynamic>.from(product);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          leading:
              const Icon(Icons.shopping_cart, color: AppColors.verdeNavbar),
          title: Text(
            productData['nombre'] ?? 'Producto Desconocido',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Cantidad: ${productData['cantidad'] ?? 0}\n',
                  style: const TextStyle(
                      fontSize: 14.0, color: AppColors.grisLetras),
                ),
                TextSpan(
                  text: 'Precio: \$ ${productData['precio'] ?? 0} COP\n',
                  style: const TextStyle(
                      fontSize: 14.0, color: AppColors.grisLetras),
                ),
                TextSpan(
                  text: 'Promo: \$ ${productData['promo'] ?? 0} COP\n',
                  style: const TextStyle(
                      fontSize: 14.0, color: AppColors.grisLetras),
                ),
                TextSpan(
                  text: 'Total: \$ ${productData['total'] ?? 0} COP',
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTotalAmount() {
    return Text(
      'Total: \$${order['totalSum']} COP',
      style: const TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }

  Widget _buildStateRow() {
    final Map<String, Color> stateColors = {
      'Pedido recibido': AppColors.rojoError,
      'Preparando pedido': AppColors.naranjaAdvertencia,
      'En camino': AppColors.verdeNavbar,
      'Entregado': AppColors.azulClaro,
    };

    Color stateColor = stateColors[order['state']] ?? Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Estado:',
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
        ),
        Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: stateColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${order['state']}',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return order['state'] == 'Entregado'
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                controller.sendDataToHistory(order['documentId'], order);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.verdeNavbar,
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 20.0),
                  SizedBox(width: 8.0),
                  Text('Enviar al historial'),
                ],
              ),
            ),
          )
        : Container();
  }
}
