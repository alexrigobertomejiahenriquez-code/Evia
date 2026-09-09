// lib/services/drawing/drawing_service.dart

import '../../models/drawing_point.dart';

abstract class DrawingService {
  Future<List<PlaneDrawing>> getAllDrawings();
  Future<PlaneDrawing?> getDrawingById(String id);
  Future<PlaneDrawing> saveDrawing(PlaneDrawing drawing);
  Future<bool> deleteDrawing(String id);
}

class MockDrawingService implements DrawingService {
  final List<PlaneDrawing> _drawings = [];

  @override
  Future<List<PlaneDrawing>> getAllDrawings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_drawings);
  }

  @override
  Future<PlaneDrawing?> getDrawingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _drawings.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<PlaneDrawing> saveDrawing(PlaneDrawing drawing) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _drawings.indexWhere((d) => d.id == drawing.id);
    if (index >= 0) {
      _drawings[index] = drawing;
    } else {
      _drawings.add(drawing);
    }
    return drawing;
  }

  @override
  Future<bool> deleteDrawing(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _drawings.removeWhere((d) => d.id == id);
    return true;
  }
}
