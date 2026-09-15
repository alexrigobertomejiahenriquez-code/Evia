import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/agenda_event.dart';
import '../domain/repositories/agenda_repository.dart';

class AgendaRepositoryLocal implements AgendaRepository {
  static const String storageKey = 'evia_agenda_events';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<List<AgendaEvent>> getEvents() async {
    final prefs = await _prefs;
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return <AgendaEvent>[];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final events = <AgendaEvent>[];
      var dirty = false;

      for (final item in decoded) {
        try {
          events.add(
            AgendaEvent.fromJson(Map<String, dynamic>.from(item as Map)),
          );
        } catch (_) {
          dirty = true;
        }
      }

      events.sort(_sortEvents);
      if (dirty) {
        await _persist(events);
      }
      return events;
    } catch (_) {
      await prefs.remove(storageKey);
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
    final events = await getEvents();
    final index = events.indexWhere((value) => value.id == event.id);
    if (index >= 0) {
      events[index] = event;
    } else {
      events.add(event);
    }
    events.sort(_sortEvents);
    await _persist(events);
  }

  @override
  Future<void> deleteEvent(String id) async {
    final events = await getEvents();
    events.removeWhere((event) => event.id == id);
    await _persist(events);
  }

  @override
  Future<List<AgendaEvent>> searchEvents(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return <AgendaEvent>[];

    final events = await getEvents();
    return events.where((event) {
      final searchable = <String?>[
        event.title,
        event.description,
        event.location,
        event.notes,
        event.relations.projectName,
        event.relations.clientName,
        event.type.label,
        event.status.label,
      ].whereType<String>().join(' ').toLowerCase();
      return searchable.contains(normalized);
    }).toList();
  }

  Future<void> _persist(List<AgendaEvent> events) async {
    final prefs = await _prefs;
    await prefs.setString(
      storageKey,
      jsonEncode(events.map((event) => event.toJson()).toList()),
    );
  }

  static int _sortEvents(AgendaEvent a, AgendaEvent b) {
    final byDate = a.startDateTime.compareTo(b.startDateTime);
    if (byDate != 0) return byDate;
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
  }
}
