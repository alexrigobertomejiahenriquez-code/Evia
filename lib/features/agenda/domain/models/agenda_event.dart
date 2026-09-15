import 'package:flutter/material.dart';

class AgendaEvent {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final TimeOfDay horaInicio;
  final TimeOfDay? horaFinal;
  final bool todoElDia;
  final String tipo;
  final String? ubicacion;
  final String estado;
  final String? notas;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final String? recordatorio;
  final String? proyectoId;
  final String? clienteId;

  const AgendaEvent({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    required this.horaInicio,
    this.horaFinal,
    this.todoElDia = false,
    required this.tipo,
    this.ubicacion,
    this.estado = 'pendiente',
    this.notas,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    this.recordatorio,
    this.proyectoId,
    this.clienteId,
  });

  AgendaEvent copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    TimeOfDay? horaInicio,
    TimeOfDay? horaFinal,
    bool? todoElDia,
    String? tipo,
    String? ubicacion,
    String? estado,
    String? notas,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    String? recordatorio,
    String? proyectoId,
    String? clienteId,
    bool clearDescripcion = false,
    bool clearHoraFinal = false,
    bool clearUbicacion = false,
    bool clearNotas = false,
    bool clearRecordatorio = false,
    bool clearProyectoId = false,
    bool clearClienteId = false,
  }) {
    return AgendaEvent(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: clearDescripcion ? null : (descripcion ?? this.descripcion),
      fecha: fecha ?? this.fecha,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFinal: clearHoraFinal ? null : (horaFinal ?? this.horaFinal),
      todoElDia: todoElDia ?? this.todoElDia,
      tipo: tipo ?? this.tipo,
      ubicacion: clearUbicacion ? null : (ubicacion ?? this.ubicacion),
      estado: estado ?? this.estado,
      notas: clearNotas ? null : (notas ?? this.notas),
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      recordatorio: clearRecordatorio ? null : (recordatorio ?? this.recordatorio),
      proyectoId: clearProyectoId ? null : (proyectoId ?? this.proyectoId),
      clienteId: clearClienteId ? null : (clienteId ?? this.clienteId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
        'horaInicio': _timeToJson(horaInicio),
        'horaFinal': horaFinal == null ? null : _timeToJson(horaFinal!),
        'todoElDia': todoElDia,
        'tipo': tipo,
        'ubicacion': ubicacion,
        'estado': estado,
        'notas': notas,
        'fechaCreacion': fechaCreacion.toIso8601String(),
        'fechaActualizacion': fechaActualizacion.toIso8601String(),
        'recordatorio': recordatorio,
        'proyectoId': proyectoId,
        'clienteId': clienteId,
      };

  factory AgendaEvent.fromJson(Map<String, dynamic> map) {
    final now = DateTime.now();
    final fecha = _parseDateTime(map['fecha']) ?? now;
    final fechaCreacion = _parseDateTime(map['fechaCreacion']) ?? now;
    final fechaActualizacion = _parseDateTime(map['fechaActualizacion']) ?? fechaCreacion;

    return AgendaEvent(
      id: _asString(map['id']) ?? '${now.microsecondsSinceEpoch}',
      titulo: _asString(map['titulo']) ?? 'Sin título',
      descripcion: _asString(map['descripcion']),
      fecha: DateTime(fecha.year, fecha.month, fecha.day),
      horaInicio: _parseTimeOfDay(map['horaInicio']) ?? const TimeOfDay(hour: 0, minute: 0),
      horaFinal: _parseTimeOfDay(map['horaFinal']),
      todoElDia: map['todoElDia'] as bool? ?? false,
      tipo: _asString(map['tipo']) ?? 'Evento',
      ubicacion: _asString(map['ubicacion']),
      estado: _asString(map['estado']) ?? 'pendiente',
      notas: _asString(map['notas']),
      fechaCreacion: fechaCreacion,
      fechaActualizacion: fechaActualizacion,
      recordatorio: _asString(map['recordatorio']),
      proyectoId: _asString(map['proyectoId']),
      clienteId: _asString(map['clienteId']),
    );
  }

  static Map<String, dynamic> _timeToJson(TimeOfDay time) => {
        'hour': time.hour,
        'minute': time.minute,
      };

  static TimeOfDay? _parseTimeOfDay(dynamic value) {
    if (value is! Map) return null;
    final hour = (value['hour'] as num?)?.toInt();
    final minute = (value['minute'] as num?)?.toInt();
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return value.toString();
  }
}
