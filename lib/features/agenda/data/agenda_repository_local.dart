import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/notification_item.dart';
import '../../../services/notifications/notification_service_local.dart';
import '../domain/models/agenda_event.dart';
import '../domain/repositories/agenda_repository.dart';

class AgendaRepositoryLocal implements AgendaRepository {
  static const String storageKey = 'evia_agenda_events';

  final NotificationServiceLocal _notificationService;

  AgendaRepositoryLocal({NotificationServiceLocal? notificationService})
      : _notificationService = notificationService ?? NotificationServiceLocal();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<AgendaEvent>> getEvents() async {
    final prefs = await _prefs;
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return <AgendaEvent>[];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((e) => AgendaEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      items.sort(_compareEvents);
      return items;
    } catch (_) {
      await prefs.remove(storageKey);
      return <AgendaEvent>[];
    }
  }

  @override
  Future<AgendaEvent?> getEventById(String id) async {
    final items = await getEvents();
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<void> saveEvent(AgendaEvent event) async {
    final prefs = await _prefs;
    final items = await getEvents();
    final index = items.indexWhere((i) => i.id == event.id);

    if (index >= 0) {
      items[index] = event;
    } else {
      items.add(event);
    }

    items.sort(_compareEvents);
    final encoded = items.map((e) => e.toJson()).toList();
    await prefs.setString(storageKey, jsonEncode(encoded));

    await _syncReminderForEvent(event);
  }

  @override
  Future<void> deleteEvent(String id) async {
    final prefs = await _prefs;
    final items = await getEvents();
    items.removeWhere((i) => i.id == id);
    items.sort(_compareEvents);
    await prefs.setString(storageKey, jsonEncode(items.map((e) => e.toJson()).toList()));

    await _removeAgendaRemindersForEvent(id);
  }

  @override
  Future<void> markTaskCompleted(String id, {bool completed = true}) async {
    final prefs = await _prefs;
    final items = await getEvents();
    final idx = items.indexWhere((i) => i.id == id);
    if (idx < 0) return;

    final current = items[idx];
    items[idx] = current.copyWith(
      estado: completed ? 'completado' : 'pendiente',
      fechaActualizacion: DateTime.now(),
    );

    items.sort(_compareEvents);
    await prefs.setString(storageKey, jsonEncode(items.map((e) => e.toJson()).toList()));

    if (completed) {
      await _removeAgendaRemindersForEvent(id);
    }
  }

  Future<void> _syncReminderForEvent(AgendaEvent event) async {
    await _removeAgendaRemindersForEvent(event.id);

    final recordatorio = event.recordatorio;
    if (recordatorio == null || recordatorio.isEmpty || event.estado == 'completado') {
      return;
    }

    final id = _reminderId(event.id, recordatorio);
    final notifications = await _notificationService.getNotifications();
    final exists = notifications.any((n) => n.id == id);
    if (exists) return;

    final date = _calculateReminderDate(event.fecha, event.horaInicio, recordatorio);
    await _notificationService.add(
      NotificationItem(
        id: id,
        title: 'Recordatorio: ${event.titulo}',
        body: 'Evento de tipo ${event.tipo}. Recordatorio local configurado en EVIA.',
        date: date,
        read: false,
      ),
    );
  }

  Future<void> _removeAgendaRemindersForEvent(String eventId) async {
    final notifications = await _notificationService.getNotifications();
    final reminderPrefix = 'agenda_reminder_${eventId}_';
    final remaining = notifications.where((n) => !n.id.startsWith(reminderPrefix)).toList();
    if (remaining.length == notifications.length) return;
    await _notificationService.saveNotifications(remaining);
  }

  static String _reminderId(String eventId, String recordatorio) =>
      'agenda_reminder_${eventId}_$recordatorio';

  static int _compareEvents(AgendaEvent a, AgendaEvent b) {
    final aDate = DateTime(a.fecha.year, a.fecha.month, a.fecha.day);
    final bDate = DateTime(b.fecha.year, b.fecha.month, b.fecha.day);
    final byDate = aDate.compareTo(bDate);
    if (byDate != 0) return byDate;

    final aMinutes = a.todoElDia ? -1 : (a.horaInicio.hour * 60 + a.horaInicio.minute);
    final bMinutes = b.todoElDia ? -1 : (b.horaInicio.hour * 60 + b.horaInicio.minute);
    final byTime = aMinutes.compareTo(bMinutes);
    if (byTime != 0) return byTime;

    final byUpdated = a.fechaActualizacion.compareTo(b.fechaActualizacion);
    if (byUpdated != 0) return byUpdated;

    return a.id.compareTo(b.id);
  }

  static DateTime _calculateReminderDate(DateTime fecha, TimeOfDay horaInicio, String recordatorio) {
    final base = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      horaInicio.hour,
      horaInicio.minute,
    );

    final minutes = switch (recordatorio) {
      '5m' => 5,
      '10m' => 10,
      '15m' => 15,
      '30m' => 30,
      '1h' => 60,
      '1d' => 60 * 24,
      'custom' => 0,
      _ => 0,
    };

    return base.subtract(Duration(minutes: minutes));
  }
}
