import '../../features/agenda/domain/models/agenda_event.dart';

enum AgendaVoiceIntent { createEvent, listToday, unknown }

class AgendaVoiceParseResult {
  final AgendaVoiceIntent intent;
  final String originalCommand;
  final String normalizedCommand;
  final AgendaEventType? suggestedType;
  final DateTime? suggestedDate;
  final int? suggestedStartMinutes;
  final String? suggestedTitle;

  const AgendaVoiceParseResult({
    required this.intent,
    required this.originalCommand,
    required this.normalizedCommand,
    this.suggestedType,
    this.suggestedDate,
    this.suggestedStartMinutes,
    this.suggestedTitle,
  });
}

abstract class AgendaVoiceParser {
  AgendaVoiceParseResult parse(String command);
}

class HeuristicAgendaVoiceParser implements AgendaVoiceParser {
  const HeuristicAgendaVoiceParser();

  @override
  AgendaVoiceParseResult parse(String command) {
    final normalized = command.trim().toLowerCase();
    if (normalized.contains('qué tengo para hoy') || normalized.contains('que tengo para hoy')) {
      return AgendaVoiceParseResult(
        intent: AgendaVoiceIntent.listToday,
        originalCommand: command,
        normalizedCommand: normalized,
        suggestedDate: AgendaEvent.normalizeDate(DateTime.now()),
      );
    }

    if (normalized.contains('recuérdame') || normalized.contains('agenda una cita')) {
      return AgendaVoiceParseResult(
        intent: AgendaVoiceIntent.createEvent,
        originalCommand: command,
        normalizedCommand: normalized,
        suggestedType: normalized.contains('cita') ? AgendaEventType.appointment : AgendaEventType.reminder,
      );
    }

    return AgendaVoiceParseResult(
      intent: AgendaVoiceIntent.unknown,
      originalCommand: command,
      normalizedCommand: normalized,
    );
  }
}
