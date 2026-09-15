import 'package:evia/features/agenda/domain/models/agenda_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgendaEvent', () {
    test('crear evento válido con descripción opcional vacía', () {
      final event = AgendaEvent(
        id: '1',
        title: 'Pago de luz',
        description: '',
        date: DateTime(2026, 9, 15),
        startMinutes: 8 * 60,
      );

      expect(event.title, 'Pago de luz');
      expect(event.description, isEmpty);
      expect(event.startDateTime, DateTime(2026, 9, 15, 8));
    });

    test('editar evento con copyWith conserva id y actualiza datos', () {
      final event = AgendaEvent(
        id: '1',
        title: 'Reunión',
        date: DateTime(2026, 9, 15),
        startMinutes: 9 * 60,
      );

      final updated = event.copyWith(
        title: 'Reunión final',
        endMinutes: 10 * 60,
        updatedAt: DateTime(2026, 9, 16),
      );

      expect(updated.id, '1');
      expect(updated.title, 'Reunión final');
      expect(updated.endMinutes, 600);
      expect(updated.updatedAt, DateTime(2026, 9, 16));
    });

    test('tarea puede marcarse pendiente y completada', () {
      final task = AgendaEvent(
        id: 'task-1',
        title: 'Comprar cemento',
        date: DateTime(2026, 9, 15),
        startMinutes: 7 * 60,
        type: AgendaEventType.task,
      );

      final completed = task.markTaskCompleted(
        true,
        updatedAt: DateTime(2026, 9, 16),
      );
      final pendingAgain = completed.markTaskCompleted(
        false,
        updatedAt: DateTime(2026, 9, 17),
      );

      expect(completed.status, AgendaEventStatus.completed);
      expect(pendingAgain.status, AgendaEventStatus.pending);
    });

    test('evento todo el día usa medianoche local y sin hora final', () {
      final event = AgendaEvent(
        id: '2',
        title: 'Feriado',
        date: DateTime(2026, 12, 24, 18),
        startMinutes: 0,
        allDay: true,
      );

      expect(event.date, DateTime(2026, 12, 24));
      expect(event.startDateTime, DateTime(2026, 12, 24));
      expect(event.endDateTime, isNull);
    });

    test('evento sin hora final es válido', () {
      final event = AgendaEvent(
        id: '3',
        title: 'Llamada',
        date: DateTime(2026, 9, 15),
        startMinutes: 13 * 60 + 30,
      );

      expect(event.endMinutes, isNull);
    });

    test(
      'medianoche, cambio de mes y cambio de año se conservan correctamente',
      () {
        final monthEnd = AgendaEvent(
          id: 'month',
          title: 'Cierre mensual',
          date: DateTime(2026, 1, 31),
          startMinutes: 23 * 60 + 59,
        );
        final yearEnd = AgendaEvent(
          id: 'year',
          title: 'Cierre anual',
          date: DateTime(2026, 12, 31),
          startMinutes: 0,
        );

        expect(monthEnd.startDateTime, DateTime(2026, 1, 31, 23, 59));
        expect(yearEnd.startDateTime, DateTime(2026, 12, 31));
        expect(yearEnd.occursOn(DateTime(2026, 12, 31, 23, 30)), isTrue);
      },
    );

    test('recordatorio resuelve fecha y hora correctas', () {
      final event = AgendaEvent(
        id: '4',
        title: 'Clase',
        date: DateTime(2026, 9, 15),
        startMinutes: 10 * 60,
        reminder: const AgendaReminder(preset: AgendaReminderPreset.oneHour),
      );

      expect(
        event.reminder!.resolveTriggerAt(event.startDateTime),
        DateTime(2026, 9, 15, 9),
      );
      expect(event.reminderNotificationId, contains('agenda_reminder_4_'));
    });

    test('hora final anterior falla', () {
      expect(
        () => AgendaEvent(
          id: '5',
          title: 'Inválido',
          date: DateTime(2026, 9, 15),
          startMinutes: 10 * 60,
          endMinutes: 9 * 60,
        ),
        throwsFormatException,
      );
    });
  });
}
