// lib/services/agenda/agenda_repository.dart

import '../../models/agenda_event.dart';

abstract class AgendaRepository {
  Future<List<AgendaEvent>> getEvents();
  Future<AgendaEvent?> getEventById(String id);
  Future<void> saveEvent(AgendaEvent event);
  Future<void> deleteEvent(String id);
  Future<List<AgendaEvent>> getEventsByDate(DateTime date);
  Future<List<AgendaEvent>> getUpcomingEvents(int days);
  Future<List<AgendaEvent>> getPastEvents();
  Future<List<AgendaEvent>> getPendingTasks();
  Future<List<AgendaEvent>> getCompletedTasks();
}
