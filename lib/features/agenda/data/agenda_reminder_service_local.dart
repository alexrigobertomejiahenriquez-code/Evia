import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/notification_item.dart';
import '../../../services/notifications/notification_service_local.dart';
import '../domain/models/agenda_event.dart';

class AgendaReminderSyncResult {
  final bool nativeSchedulingAvailable;
  final List<String> deliveredReminderIds;
  final List<String> warnings;

  const AgendaReminderSyncResult({
    required this.nativeSchedulingAvailable,
    this.deliveredReminderIds = const <String>[],
    this.warnings = const <String>[],
  });
}

class AgendaReminderServiceLocal {
  static const String _deliveredKey = 'evia_agenda_reminder_deliveries';
  final NotificationServiceLocal notificationService;

  AgendaReminderServiceLocal({NotificationServiceLocal? notificationService})
      : notificationService = notificationService ?? NotificationServiceLocal();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<AgendaReminderSyncResult> syncEvent(
    AgendaEvent event, {
    AgendaEvent? previousEvent,
    DateTime? now,
  }) async {
    if (previousEvent != null &&
        previousEvent.reminderNotificationId != event.reminderNotificationId) {
      await clearReminderStateForEvent(event.id);
    }
    return syncDueReminders([event], now: now);
  }

  Future<AgendaReminderSyncResult> syncDueReminders(
    List<AgendaEvent> events, {
    DateTime? now,
  }) async {
    final current = (now ?? DateTime.now()).toLocal();
    final delivered = await _getDeliveredIds();
    final existing = await notificationService.getNotifications();
    final existingIds = existing.map((item) => item.id).toSet();
    final deliveredNow = <String>[];

    for (final event in events) {
      if (event.reminder == null) continue;
      if (event.isTask && event.isCompleted) continue;

      final reminderId = event.reminderNotificationId!;
      final triggerAt = event.reminder!.resolveTriggerAt(event.startDateTime);
      if (triggerAt.isAfter(current)) continue;
      if (delivered.contains(reminderId) || existingIds.contains(reminderId))
        continue;

      final notification = NotificationItem(
        id: reminderId,
        title: event.title,
        body: _buildReminderBody(event),
        date: triggerAt,
      );
      await notificationService.add(notification);
      delivered.add(reminderId);
      deliveredNow.add(reminderId);
    }

    await _saveDeliveredIds(delivered);
    return AgendaReminderSyncResult(
      nativeSchedulingAvailable: false,
      deliveredReminderIds: deliveredNow,
      warnings: events.any((event) => event.reminder != null)
          ? const <String>[
              'La programación nativa de recordatorios aún no está disponible; los avisos se sincronizan cuando la app vuelve a abrirse.',
            ]
          : const <String>[],
    );
  }

  Future<void> clearReminderStateForEvent(String eventId) async {
    final notifications = await notificationService.getNotifications();
    final related = notifications
        .where((item) => item.id.startsWith('agenda_reminder_${eventId}_'))
        .toList();
    for (final item in related) {
      await notificationService.remove(item.id);
    }

    final delivered = await _getDeliveredIds();
    delivered.removeWhere((id) => id.startsWith('agenda_reminder_${eventId}_'));
    await _saveDeliveredIds(delivered);
  }

  Future<Set<String>> _getDeliveredIds() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_deliveredKey);
    if (raw == null || raw.isEmpty) return <String>{};
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) => item.toString()).toSet();
    } catch (_) {
      await prefs.remove(_deliveredKey);
      return <String>{};
    }
  }

  Future<void> _saveDeliveredIds(Set<String> ids) async {
    final prefs = await _prefs;
    await prefs.setString(_deliveredKey, jsonEncode(ids.toList()..sort()));
  }

  String _buildReminderBody(AgendaEvent event) {
    final typeLabel = event.type.label.toLowerCase();
    final when = event.allDay
        ? 'para ${event.date.day.toString().padLeft(2, '0')}/${event.date.month.toString().padLeft(2, '0')}/${event.date.year}'
        : 'a las ${_formatMinutes(event.startMinutes)}';
    return 'Recordatorio de $typeLabel $when.';
  }

  String _formatMinutes(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
