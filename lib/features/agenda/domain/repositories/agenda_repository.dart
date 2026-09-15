import '../models/agenda_event.dart';

abstract class AgendaRepository {
  Future<List<AgendaEvent>> getEvents();
  Future<AgendaEvent?> getEventById(String id);
  Future<void> saveEvent(AgendaEvent event);
  Future<void> deleteEvent(String id);
  Future<void> markTaskCompleted(String id, {bool completed = true});
}
