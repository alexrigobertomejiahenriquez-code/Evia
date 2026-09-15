import 'package:flutter/material.dart';

enum AgendaEventType { event, task, reminder, appointment, lesson }

enum AgendaEventStatus { pending, completed, cancelled }

enum AgendaReminderPreset {
  fiveMinutes,
  tenMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  oneDay,
  custom,
}

extension AgendaEventTypeX on AgendaEventType {
  String get label {
    switch (this) {
      case AgendaEventType.event:
        return 'Evento';
      case AgendaEventType.task:
        return 'Tarea';
      case AgendaEventType.reminder:
        return 'Recordatorio';
      case AgendaEventType.appointment:
        return 'Cita';
      case AgendaEventType.lesson:
        return 'Clase';
    }
  }

  IconData get icon {
    switch (this) {
      case AgendaEventType.event:
        return Icons.event;
      case AgendaEventType.task:
        return Icons.check_circle_outline;
      case AgendaEventType.reminder:
        return Icons.alarm;
      case AgendaEventType.appointment:
        return Icons.handshake_outlined;
      case AgendaEventType.lesson:
        return Icons.school_outlined;
    }
  }
}

extension AgendaEventStatusX on AgendaEventStatus {
  String get label {
    switch (this) {
      case AgendaEventStatus.pending:
        return 'Pendiente';
      case AgendaEventStatus.completed:
        return 'Completada';
      case AgendaEventStatus.cancelled:
        return 'Cancelada';
    }
  }
}

extension AgendaReminderPresetX on AgendaReminderPreset {
  String get label {
    switch (this) {
      case AgendaReminderPreset.fiveMinutes:
        return '5 minutos antes';
      case AgendaReminderPreset.tenMinutes:
        return '10 minutos antes';
      case AgendaReminderPreset.fifteenMinutes:
        return '15 minutos antes';
      case AgendaReminderPreset.thirtyMinutes:
        return '30 minutos antes';
      case AgendaReminderPreset.oneHour:
        return '1 hora antes';
      case AgendaReminderPreset.oneDay:
        return '1 día antes';
      case AgendaReminderPreset.custom:
        return 'Hora personalizada';
    }
  }

  int? get defaultMinutesBefore {
    switch (this) {
      case AgendaReminderPreset.fiveMinutes:
        return 5;
      case AgendaReminderPreset.tenMinutes:
        return 10;
      case AgendaReminderPreset.fifteenMinutes:
        return 15;
      case AgendaReminderPreset.thirtyMinutes:
        return 30;
      case AgendaReminderPreset.oneHour:
        return 60;
      case AgendaReminderPreset.oneDay:
        return 60 * 24;
      case AgendaReminderPreset.custom:
        return null;
    }
  }
}

class AgendaRelations {
  final String? projectId;
  final String? projectName;
  final String? clientId;
  final String? clientName;
  final String? paymentId;
  final String? classId;
  final String? taskId;
  final String? documentId;
  final String? appointmentId;

  const AgendaRelations({
    this.projectId,
    this.projectName,
    this.clientId,
    this.clientName,
    this.paymentId,
    this.classId,
    this.taskId,
    this.documentId,
    this.appointmentId,
  });

  AgendaRelations copyWith({
    String? projectId,
    String? projectName,
    String? clientId,
    String? clientName,
    String? paymentId,
    String? classId,
    String? taskId,
    String? documentId,
    String? appointmentId,
  }) {
    return AgendaRelations(
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      paymentId: paymentId ?? this.paymentId,
      classId: classId ?? this.classId,
      taskId: taskId ?? this.taskId,
      documentId: documentId ?? this.documentId,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }

  Map<String, dynamic> toJson() => {
        'projectId': projectId,
        'projectName': projectName,
        'clientId': clientId,
        'clientName': clientName,
        'paymentId': paymentId,
        'classId': classId,
        'taskId': taskId,
        'documentId': documentId,
        'appointmentId': appointmentId,
      };

  factory AgendaRelations.fromJson(Map<String, dynamic> json) {
    return AgendaRelations(
      projectId: json['projectId'] as String?,
      projectName: json['projectName'] as String?,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      paymentId: json['paymentId'] as String?,
      classId: json['classId'] as String?,
      taskId: json['taskId'] as String?,
      documentId: json['documentId'] as String?,
      appointmentId: json['appointmentId'] as String?,
    );
  }
}

class AgendaReminder {
  final AgendaReminderPreset preset;
  final int? customMinutesBefore;
  final DateTime? customTriggerAt;

  const AgendaReminder({
    required this.preset,
    this.customMinutesBefore,
    this.customTriggerAt,
  });

  int? get minutesBefore => preset == AgendaReminderPreset.custom
      ? customMinutesBefore
      : preset.defaultMinutesBefore;

  String get label => preset.label;

  DateTime resolveTriggerAt(DateTime eventStart) {
    if (preset == AgendaReminderPreset.custom && customTriggerAt != null) {
      return customTriggerAt!.toLocal();
    }

    final minutes = minutesBefore;
    if (minutes == null) {
      throw FormatException(
        'El recordatorio personalizado requiere fecha y hora o minutos.',
      );
    }
    return eventStart.subtract(Duration(minutes: minutes));
  }

  AgendaReminder copyWith({
    AgendaReminderPreset? preset,
    int? customMinutesBefore,
    DateTime? customTriggerAt,
  }) {
    return AgendaReminder(
      preset: preset ?? this.preset,
      customMinutesBefore: customMinutesBefore ?? this.customMinutesBefore,
      customTriggerAt: customTriggerAt ?? this.customTriggerAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'preset': preset.name,
        'customMinutesBefore': customMinutesBefore,
        'customTriggerAt': customTriggerAt?.toLocal().toIso8601String(),
      };

  factory AgendaReminder.fromJson(Map<String, dynamic> json) {
    return AgendaReminder(
      preset: AgendaReminderPreset.values.firstWhere(
        (value) => value.name == json['preset'],
        orElse: () => AgendaReminderPreset.custom,
      ),
      customMinutesBefore: (json['customMinutesBefore'] as num?)?.toInt(),
      customTriggerAt: json['customTriggerAt'] == null
          ? null
          : DateTime.parse(json['customTriggerAt'] as String).toLocal(),
    );
  }
}

class AgendaEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int startMinutes;
  final int? endMinutes;
  final bool allDay;
  final AgendaEventType type;
  final String? location;
  final AgendaEventStatus status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AgendaReminder? reminder;
  final AgendaRelations relations;

  AgendaEvent({
    required this.id,
    required String title,
    String description = '',
    required DateTime date,
    required this.startMinutes,
    this.endMinutes,
    this.allDay = false,
    this.type = AgendaEventType.event,
    this.location,
    this.status = AgendaEventStatus.pending,
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.reminder,
    this.relations = const AgendaRelations(),
  })  : title = title.trim(),
        description = description.trim(),
        date = normalizeDate(date),
        createdAt = (createdAt ?? DateTime.now()).toLocal(),
        updatedAt = (updatedAt ?? DateTime.now()).toLocal() {
    validate();
  }

  static DateTime normalizeDate(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  bool get isTask => type == AgendaEventType.task;
  bool get isCompleted => status == AgendaEventStatus.completed;

  int get safeStartMinutes => allDay ? 0 : startMinutes;

  DateTime get startDateTime {
    final minutes = allDay ? 0 : startMinutes;
    return DateTime(
      date.year,
      date.month,
      date.day,
      minutes ~/ 60,
      minutes % 60,
    );
  }

  DateTime? get endDateTime {
    if (endMinutes == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      endMinutes! ~/ 60,
      endMinutes! % 60,
    );
  }

  AgendaEvent markTaskCompleted(bool completed, {DateTime? updatedAt}) {
    return copyWith(
      status:
          completed ? AgendaEventStatus.completed : AgendaEventStatus.pending,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool occursOn(DateTime other) {
    final normalized = normalizeDate(other);
    return normalized.year == date.year &&
        normalized.month == date.month &&
        normalized.day == date.day;
  }

  String? get reminderNotificationId {
    if (reminder == null) return null;
    final triggerAt = reminder!.resolveTriggerAt(startDateTime);
    return 'agenda_reminder_${id}_${triggerAt.millisecondsSinceEpoch}_${reminder!.preset.name}';
  }

  void validate() {
    if (title.isEmpty) {
      throw FormatException('El título es obligatorio.');
    }
    if (startMinutes < 0 || startMinutes > 1439) {
      throw FormatException('La hora de inicio es inválida.');
    }
    if (endMinutes != null && (endMinutes! < 0 || endMinutes! > 1439)) {
      throw FormatException('La hora final es inválida.');
    }
    if (!allDay && endMinutes != null && endMinutes! < startMinutes) {
      throw FormatException(
        'La hora final no puede ser anterior a la hora inicial.',
      );
    }
    if (allDay && endMinutes != null && endMinutes! < 0) {
      throw FormatException(
        'El evento de todo el día no admite hora final inválida.',
      );
    }
    if (reminder != null) {
      final triggerAt = reminder!.resolveTriggerAt(startDateTime);
      if (triggerAt.isAfter(startDateTime)) {
        throw FormatException(
          'El recordatorio no puede ocurrir después del inicio del evento.',
        );
      }
    }
  }

  AgendaEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    int? startMinutes,
    Object? endMinutes = _sentinel,
    bool? allDay,
    AgendaEventType? type,
    Object? location = _sentinel,
    AgendaEventStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? reminder = _sentinel,
    AgendaRelations? relations,
  }) {
    return AgendaEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: identical(endMinutes, _sentinel)
          ? this.endMinutes
          : endMinutes as int?,
      allDay: allDay ?? this.allDay,
      type: type ?? this.type,
      location:
          identical(location, _sentinel) ? this.location : location as String?,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminder: identical(reminder, _sentinel)
          ? this.reminder
          : reminder as AgendaReminder?,
      relations: relations ?? this.relations,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toLocal().toIso8601String(),
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'allDay': allDay,
        'type': type.name,
        'location': location,
        'status': status.name,
        'notes': notes,
        'createdAt': createdAt.toLocal().toIso8601String(),
        'updatedAt': updatedAt.toLocal().toIso8601String(),
        'reminder': reminder?.toJson(),
        'relations': relations.toJson(),
      };

  factory AgendaEvent.fromJson(Map<String, dynamic> json) {
    return AgendaEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String).toLocal(),
      startMinutes: (json['startMinutes'] as num).toInt(),
      endMinutes: (json['endMinutes'] as num?)?.toInt(),
      allDay: json['allDay'] as bool? ?? false,
      type: AgendaEventType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => AgendaEventType.event,
      ),
      location: json['location'] as String?,
      status: AgendaEventStatus.values.firstWhere(
        (value) => value.name == json['status'],
        orElse: () => AgendaEventStatus.pending,
      ),
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['updatedAt'] as String).toLocal(),
      reminder: json['reminder'] == null
          ? null
          : AgendaReminder.fromJson(
              Map<String, dynamic>.from(json['reminder'] as Map),
            ),
      relations: json['relations'] == null
          ? const AgendaRelations()
          : AgendaRelations.fromJson(
              Map<String, dynamic>.from(json['relations'] as Map),
            ),
    );
  }
}

const Object _sentinel = Object();
