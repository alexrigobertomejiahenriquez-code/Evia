// lib/services/notifications/notification_service_local.dart
//
// Servicio local de notificaciones usando SharedPreferences y JSON.
// Compatible con NotificationItem (lib/models/notification_item.dart).

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/notification_item.dart';

class NotificationServiceLocal {
  static const String _storageKey = 'evia_notifications';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<List<NotificationItem>> getNotifications() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return <NotificationItem>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => NotificationItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      // Datos corruptos o parse error: limpiar almacenamiento y devolver vacío
      await prefs.remove(_storageKey);
      return <NotificationItem>[];
    }
  }

  Future<void> saveNotifications(List<NotificationItem> items) async {
    final prefs = await _prefs;
    final encoded = items.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  Future<void> add(NotificationItem item) async {
    final items = await getNotifications();
    items.insert(0, item); // agregar al inicio (más reciente primero)
    await saveNotifications(items);
  }

  Future<void> remove(String id) async {
    final items = await getNotifications();
    items.removeWhere((i) => i.id == id);
    await saveNotifications(items);
  }

  Future<void> markRead(String id, bool read) async {
    final items = await getNotifications();
    final idx = items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(read: read);
      await saveNotifications(items);
    }
  }

  Future<void> markAllRead() async {
    final items = await getNotifications();
    if (items.isEmpty) return;
    final updated = items.map((i) => i.copyWith(read: true)).toList();
    await saveNotifications(updated);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_storageKey);
  }
}
