import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home/notifications_controller.dart';

class NotificationsScreenWidget extends StatelessWidget {
  final Function(ScrollNotification) onScroll;

  NotificationsScreenWidget({super.key, required this.onScroll});

  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        onScroll(scrollInfo);
        return false;
      },
      child: Obx(
        () => controller.notifications.isEmpty
            ? _buildEmptyState(context)
            : RefreshIndicator(
                color: AppColors.verdeNavbar,
                onRefresh: controller.loadNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20.0),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return Dismissible(
                      key: Key(notification['title'] ?? index.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        controller.removeNotification(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notificación eliminada'),
                          ),
                        );
                      },
                      child: Card(
                        color: AppColors.blanco,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications,
                            color: AppColors.verdeNavbar,
                            size: 40.0,
                          ),
                          title: Text(
                            notification['title'] ?? 'Título',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            notification['body'] ??
                                'Contenido de la notificación',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 100.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24.0),
            const Text(
              "¡Bienvenido!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeNavbar,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Aún no tienes notificaciones. \nAquí aparecerán las notificaciones importantes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                size: 40,
              ),
              onPressed: controller.loadNotifications,
            )
          ],
        ),
      ),
    );
  }
}
