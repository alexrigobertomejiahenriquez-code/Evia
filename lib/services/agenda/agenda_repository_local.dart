// lib/services/agenda/agenda_repository_local.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/agenda_event.dart';
import 'agenda_repository.dart';

class AgendaRepositoryLocal implements AgendaRepository {
  static const String _storageKey = 'evia_agenda_events';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<AgendaEvent>> getEvents() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return <AgendaEvent>[];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final events = decoded
          .map((e) => AgendaEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // Ordenar por fecha (más reciente primero)
      events.sort((a, b) => b.fecha.compareTo(a.fecha));
      return events;
    } catch (_) {
      await prefs.remove(_storageKey);
      return <AgendaEvent>[];
    }
  }

  @override
  Future<AgendaEvent?> getEventById(String id) async {
    final events = await getEvents();
    for (final event in events) {
      if (event.id == id) return event;
    }
    return null;
  }

  @override
  Future<void> saveEvent(AgendaEvent event) async {
    final prefs = await _prefs;
    final events = await getEvents();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index >= 0) {
      events[index] = event;
    } else {
      events.add(event);
    }
    final encoded = events.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  @override
  Future<void> deleteEvent(String id) async {
    final prefs = await _prefs;
    final events = await getEvents();
    events.removeWhere((e) => e.id == id);
    final encoded = events.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  @override
  Future<List<AgendaEvent>> getEventsByDate(DateTime date) async {
    final events = await getEvents();
    final dateOnly = DateTime(date.year, date.month, date.day);
    return events.where((e) {
      final eDate = DateTime(e.fecha.year, e.fecha.month, e.fecha.day);
      return eDate == dateOnly;
    }).toList();
  }

  @override
  Future<List<AgendaEvent>> getUpcomingEvents(int days) async {
    final events = await getEvents();
    final now = DateTime.now();
    final limit = now.add(Duration(days: days));
    return events.where((e) {
      final eDate = DateTime(e.fecha.year, e.fecha.month, e.fecha.day);
      final nowDate = DateTime(now.year, now.month, now.day);
      return eDate.isAfter(nowDate) && eDate.isBefore(limit);
    }).toList();
  }

  @override
  Future<List<AgendaEvent>> getPastEvents() async {
    final events = await getEvents();
    final now = DateTime.now();
    return events.where((e) {
      final eDate = DateTime(e.fecha.year, e.fecha.month, e.fecha.day);
      final nowDate = DateTime(now.year, now.month, now.day);
      return eDate.isBefore(nowDate);
    }).toList();
  }

  @override
  Future<List<AgendaEvent>> getPendingTasks() async {
    final events = await getEvents();
    return events.where((e) => e.tipo == 'Tarea' && e.estado == 'pendiente').toList();
  }

  @override
  Future<List<AgendaEvent>> getCompletedTasks() async {
    final events = await getEvents();
    return events.where((e) => e.tipo == 'Tarea' && e.estado == 'completado').toList();
  }
}
