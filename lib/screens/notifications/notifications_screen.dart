// lib/screens/notifications/notifications_screen.dart
//
// Pantalla de notificaciones que utiliza NotificationController y NotificationServiceLocal.
// Añade confirmación antes de borrar todas, maneja loading/error/empty states,
// y libera el controller en dispose().

import 'package:flutter/material.dart';

import '../../widgets/common/app_scaffold.dart';
import '../../models/notification_item.dart';
import '../../services/notifications/notification_service_local.dart';
import '../../features/notifications/presentation/controllers/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationServiceLocal _service;
  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _service = NotificationServiceLocal();
    _controller = NotificationController(service: _service);
    _controller.addListener(_onChange);
    _controller.loadNotifications();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChange);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmClearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Deseas eliminar todas las notificaciones? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) {
      await _controller.clearAll();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificaciones eliminadas')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.loading) {
      return const AppScaffold(title: 'Avisos', child: Center(child: CircularProgressIndicator()));
    }

    if (_controller.error != null) {
      return AppScaffold(
        title: 'Avisos',
        child: Center(child: Text('Error: ${_controller.error}')),
      );
    }

    final items = _controller.items;

    return AppScaffold(
      title: 'Avisos',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text('Notificaciones', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  tooltip: 'Marcar todas leídas',
                  onPressed: items.isEmpty ? null : () => _controller.markAllRead(),
                  icon: const Icon(Icons.mark_email_read),
                ),
                IconButton(
                  tooltip: 'Borrar todas',
                  onPressed: items.isEmpty ? null : _confirmClearAll,
                  icon: const Icon(Icons.delete_sweep),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('Sin notificaciones', style: Theme.of(context).textTheme.bodyLarge))
                : RefreshIndicator(
                    onRefresh: () => _controller.loadNotifications(),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final it = items[index];
                        return ListTile(
                          leading: Icon(it.read ? Icons.mark_email_read : Icons.mark_email_unread),
                          title: Text(it.title),
                          subtitle: Text(it.body),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              icon: Icon(it.read ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => _controller.markRead(it.id, !it.read),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever),
                              onPressed: () => _controller.removeNotification(it.id),
                            ),
                          ]),
                          onTap: () => _controller.markRead(it.id, true),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
