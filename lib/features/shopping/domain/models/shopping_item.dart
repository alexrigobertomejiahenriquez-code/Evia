// lib/features/shopping/domain/models/shopping_item.dart

import 'package:flutter/foundation.dart';

class ShoppingItem {
  final String id;
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final DateTime fecha;
  final bool completado;

  ShoppingItem({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.fecha,
    this.completado = false,
  });

  double get total => cantidad * precioUnitario;

  ShoppingItem copyWith({
    String? id,
    String? nombre,
    int? cantidad,
    double? precioUnitario,
    DateTime? fecha,
    bool? completado,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      fecha: fecha ?? this.fecha,
      completado: completado ?? this.completado,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'fecha': fecha.toIso8601String(),
        'completado': completado,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      nombre: map['nombre'] as String,
      cantidad: (map['cantidad'] as num).toInt(),
      precioUnitario: (map['precioUnitario'] as num).toDouble(),
      fecha: DateTime.parse(map['fecha'] as String),
      completado: map['completado'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, nombre: $nombre, cantidad: $cantidad, precioUnitario: $precioUnitario, fecha: $fecha, completado: $completado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
