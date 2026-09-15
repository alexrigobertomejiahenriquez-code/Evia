// lib/models/agenda_event.dart

class AgendaEvent {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final String? horaInicio; // formato "HH:mm"
  final String? horaFinal; // formato "HH:mm", opcional
  final bool todoElDia;
  final String tipo; // 'Evento', 'Tarea', 'Recordatorio', 'Cita', 'Clase'
  final String? ubicacion;
  final String estado; // 'pendiente', 'completado', 'cancelado'
  final String? notas;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final String? recordatorio; // '5m', '10m', '15m', '30m', '1h', '1d', 'custom'
  final String? proyectoId;
  final String? clienteId;

  const AgendaEvent({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    this.horaInicio,
    this.horaFinal,
    this.todoElDia = false,
    this.tipo = 'Evento',
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
    String? horaInicio,
    String? horaFinal,
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
    'horaInicio': horaInicio,
    'horaFinal': horaFinal,
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

  factory AgendaEvent.fromJson(Map<String, dynamic> json) {
    return AgendaEvent(
      id: json['id'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      fecha: DateTime.tryParse(json['fecha'] as String? ?? '') ?? DateTime.now(),
      horaInicio: json['horaInicio'] as String?,
      horaFinal: json['horaFinal'] as String?,
      todoElDia: json['todoElDia'] as bool? ?? false,
      tipo: json['tipo'] as String? ?? 'Evento',
      ubicacion: json['ubicacion'] as String?,
      estado: json['estado'] as String? ?? 'pendiente',
      notas: json['notas'] as String?,
      fechaCreacion: DateTime.tryParse(json['fechaCreacion'] as String? ?? '') ?? DateTime.now(),
      fechaActualizacion: DateTime.tryParse(json['fechaActualizacion'] as String? ?? '') ?? DateTime.now(),
      recordatorio: json['recordatorio'] as String?,
      proyectoId: json['proyectoId'] as String?,
      clienteId: json['clienteId'] as String?,
    );
  }

  @override
  String toString() => 'AgendaEvent(id: $id, titulo: $titulo, fecha: $fecha, estado: $estado)';

  @override
  bool operator ==(Object other) => identical(this, other) || (other is AgendaEvent && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
