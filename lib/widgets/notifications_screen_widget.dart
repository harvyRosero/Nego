import 'package:agro/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agro/controllers/home/notifications_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                      vertical: 20.0, horizontal: 16.0),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    final date = DateTime.tryParse(notification['date'] ?? '');
                    final timeAgo = date != null
                        ? timeago.format(date, locale: 'es')
                        : 'Fecha desconocida';

                    return Dismissible(
                      key: Key(notification['title'] ?? index.toString()),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: const Icon(
                          Icons.delete_forever,
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
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: AppColors.verdeNavbar.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: AppColors.verdeNavbar,
                              size: 30.0,
                            ),
                          ),
                          title: Text(
                            notification['title'] ?? 'Título',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0),
                              Text(
                                notification['body'] ??
                                    'Contenido de la notificación',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
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
              Icons.notifications_off_outlined,
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
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: controller.loadNotifications,
              icon: const Icon(Icons.refresh),
              label: const Text('Recargar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.verdeNavbar,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
