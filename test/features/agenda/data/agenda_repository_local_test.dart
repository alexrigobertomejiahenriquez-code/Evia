import 'package:evia/features/agenda/data/agenda_repository_local.dart';
import 'package:evia/features/agenda/domain/models/agenda_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  AgendaEvent buildEvent(
    String id, {
    required DateTime date,
    required int startMinutes,
    String title = 'Evento',
    AgendaEventType type = AgendaEventType.event,
    AgendaEventStatus status = AgendaEventStatus.pending,
    AgendaReminder? reminder,
  }) {
    return AgendaEvent(
      id: id,
      title: title,
      date: date,
      startMinutes: startMinutes,
      type: type,
      status: status,
      reminder: reminder,
    );
  }

  test('guardar y cargar eventos preserva orden y misma fecha', () async {
    final repository = AgendaRepositoryLocal();
    final first = buildEvent(
      '1',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      title: 'A',
    );
    final second = buildEvent(
      '2',
      date: DateTime(2026, 9, 15),
      startMinutes: 10 * 60,
      title: 'B',
    );
    final third = buildEvent(
      '3',
      date: DateTime(2026, 9, 14),
      startMinutes: 12 * 60,
      title: 'C',
    );

    await repository.saveEvent(second);
    await repository.saveEvent(third);
    await repository.saveEvent(first);

    final items = await repository.getEvents();

    expect(items.map((event) => event.id).toList(), ['3', '1', '2']);
  });

  test('editar evento existente actualiza sus datos', () async {
    final repository = AgendaRepositoryLocal();
    final original = buildEvent(
      '1',
      date: DateTime(2026, 9, 15),
      startMinutes: 8 * 60,
      title: 'Original',
    );
    await repository.saveEvent(original);

    await repository.saveEvent(
      original.copyWith(title: 'Actualizado', updatedAt: DateTime(2026, 9, 16)),
    );

    final loaded = await repository.getEventById('1');
    expect(loaded, isNotNull);
    expect(loaded!.title, 'Actualizado');
  });

  test('eliminar evento lo remueve del almacenamiento', () async {
    final repository = AgendaRepositoryLocal();
    await repository.saveEvent(
      buildEvent('1', date: DateTime(2026, 9, 15), startMinutes: 8 * 60),
    );
    await repository.saveEvent(
      buildEvent('2', date: DateTime(2026, 9, 16), startMinutes: 9 * 60),
    );

    await repository.deleteEvent('1');

    final items = await repository.getEvents();
    expect(items.length, 1);
    expect(items.single.id, '2');
  });

  test('búsqueda encuentra eventos por título y cliente', () async {
    final repository = AgendaRepositoryLocal();
    await repository.saveEvent(
      AgendaEvent(
        id: '1',
        title: 'Cita con Carlos',
        date: DateTime(2026, 9, 15),
        startMinutes: 15 * 60,
        relations: const AgendaRelations(clientName: 'Carlos'),
      ),
    );

    final results = await repository.searchEvents('carlos');
    expect(results.length, 1);
    expect(results.single.id, '1');
  });

  test('datos corruptos limpian storage y no bloquean', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AgendaRepositoryLocal.storageKey, 'not-json');

    final repository = AgendaRepositoryLocal();
    final items = await repository.getEvents();

    expect(items, isEmpty);
    expect(prefs.getString(AgendaRepositoryLocal.storageKey), isNull);
  });

  test(
    'entradas corruptas parciales se descartan conservando el resto',
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AgendaRepositoryLocal.storageKey,
        '[{"id":"1","title":"Válido","date":"2026-09-15T00:00:00.000","startMinutes":480}, {"id":2}]',
      );

      final repository = AgendaRepositoryLocal();
      final items = await repository.getEvents();

      expect(items.length, 1);
      expect(items.single.id, '1');
    },
  );
}
