// lib/features/notifications/presentation/controllers/notification_controller.dart
//
// Controller para notificaciones. Gestiona estados loading/error y la lista
// usando NotificationServiceLocal. Evita múltiples notifyListeners redundantes.

import 'package:flutter/foundation.dart';

import '../../../../models/notification_item.dart';
import '../../../../services/notifications/notification_service_local.dart';

class NotificationController extends ChangeNotifier {
  final NotificationServiceLocal service;

  NotificationController({required this.service});

  List<NotificationItem> _items = <NotificationItem>[];
  bool _loading = false;
  String? _error;

  List<NotificationItem> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  /// Carga las notificaciones. Notifica solo antes y al final (no dentro del try repetidamente).
  Future<void> loadNotifications() async {
    _setLoading(true);
    try {
      final fetched = await service.getNotifications();
      _items = fetched;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = <NotificationItem>[];
    } finally {
      _setLoading(false);
    }
  }

  /// Internal helper to set loading and notify once.
  void _setLoading(bool value) {
    if (_loading == value) return;
    _loading = value;
    notifyListeners();
  }

  /// Añadir notificación y recargar lista
  Future<void> addNotification(NotificationItem it) async {
    _setLoading(true);
    try {
      await service.add(it);
      _items = await service.getNotifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Eliminar notificación por id
  Future<void> removeNotification(String id) async {
    _setLoading(true);
    try {
      await service.remove(id);
      _items = await service.getNotifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Marcar una notificación como leída/no leída
  Future<void> markRead(String id, bool read) async {
    _setLoading(true);
    try {
      await service.markRead(id, read);
      _items = await service.getNotifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Marcar todas leídas
  Future<void> markAllRead() async {
    _setLoading(true);
    try {
      await service.markAllRead();
      _items = await service.getNotifications();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Limpiar todas las notificaciones
  Future<void> clearAll() async {
    _setLoading(true);
    try {
      await service.clearAll();
      _items = <NotificationItem>[];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
