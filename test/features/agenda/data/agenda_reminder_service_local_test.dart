import 'package:evia/features/agenda/data/agenda_reminder_service_local.dart';
import 'package:evia/features/agenda/domain/models/agenda_event.dart';
import 'package:evia/services/notifications/notification_service_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  AgendaEvent buildEvent({
    required String id,
    required DateTime date,
    required int startMinutes,
    required AgendaReminder reminder,
    AgendaEventType type = AgendaEventType.event,
    AgendaEventStatus status = AgendaEventStatus.pending,
  }) {
    return AgendaEvent(
      id: id,
      title: 'Evento $id',
      date: date,
      startMinutes: startMinutes,
      reminder: reminder,
      type: type,
      status: status,
    );
  }

  test('sincroniza recordatorio vencido en avisos y evita duplicados', () async {
    final service = AgendaReminderServiceLocal(
      notificationService: NotificationServiceLocal(),
    );
    final event = buildEvent(
      id: '1',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      reminder: const AgendaReminder(preset: AgendaReminderPreset.fiveMinutes),
    );

    final now = DateTime(2026, 9, 15, 8);
    await service.syncDueReminders([event], now: now);
    await service.syncDueReminders([event], now: now);

    final notifications = await NotificationServiceLocal().getNotifications();
    expect(notifications.length, 1);
    expect(notifications.single.id, event.reminderNotificationId);
  });

  test('no genera aviso si el recordatorio aún no vence', () async {
    final service = AgendaReminderServiceLocal(
      notificationService: NotificationServiceLocal(),
    );
    final event = buildEvent(
      id: '2',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      reminder: const AgendaReminder(preset: AgendaReminderPreset.oneHour),
    );

    await service.syncDueReminders([event], now: DateTime(2026, 9, 15, 6, 30));

    final notifications = await NotificationServiceLocal().getNotifications();
    expect(notifications, isEmpty);
  });

  test('tarea completada no dispara recordatorio', () async {
    final service = AgendaReminderServiceLocal(
      notificationService: NotificationServiceLocal(),
    );
    final task = buildEvent(
      id: '3',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      reminder: const AgendaReminder(preset: AgendaReminderPreset.tenMinutes),
      type: AgendaEventType.task,
      status: AgendaEventStatus.completed,
    );

    await service.syncDueReminders([task], now: DateTime(2026, 9, 15, 8));

    final notifications = await NotificationServiceLocal().getNotifications();
    expect(notifications, isEmpty);
  });

  test('recordatorio personalizado conserva fecha y hora', () async {
    final reminder = AgendaReminder(
      preset: AgendaReminderPreset.custom,
      customTriggerAt: DateTime(2026, 9, 14, 17, 45),
    );
    final event = buildEvent(
      id: '4',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      reminder: reminder,
    );

    expect(reminder.resolveTriggerAt(event.startDateTime), DateTime(2026, 9, 14, 17, 45));
  });

  test('cambiar configuración limpia estado previo del recordatorio', () async {
    final notifications = NotificationServiceLocal();
    final service = AgendaReminderServiceLocal(notificationService: notifications);
    final original = buildEvent(
      id: '5',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      reminder: const AgendaReminder(preset: AgendaReminderPreset.fiveMinutes),
    );
    final updated = buildEvent(
      id: '5',
      date: DateTime(2026, 9, 15),
      startMinutes: 10 * 60,
      reminder: const AgendaReminder(preset: AgendaReminderPreset.oneHour),
    );

    await service.syncEvent(original, now: DateTime(2026, 9, 15, 8));
    expect((await notifications.getNotifications()).length, 1);

    await service.syncEvent(updated, previousEvent: original, now: DateTime(2026, 9, 15, 9, 30));
    final stored = await notifications.getNotifications();

    expect(stored.length, 1);
    expect(stored.single.id, updated.reminderNotificationId);
  });
}
