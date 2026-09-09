// lib/models/drawing_point.dart

import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingLine {
  final List<DrawingPoint> points;
  final Paint paint;

  DrawingLine({required this.points, required this.paint});
}

class PlaneDrawing {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<DrawingLine> lines;
  final Map<int, String> spaces; // número -> nombre del espacio
  final Map<int, String> measurements; // número -> medidas

  PlaneDrawing({
    required this.id,
    required this.title,
    required this.createdAt,
    this.lines = const [],
    this.spaces = const {},
    this.measurements = const {},
  });
}
