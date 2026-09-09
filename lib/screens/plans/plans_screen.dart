// lib/screens/plans/plans_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../models/drawing_point.dart';
import '../../services/drawing/drawing_service.dart';
import 'plan_drawing_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  late final DrawingService _drawingService;
  List<PlaneDrawing> _drawings = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _drawingService = MockDrawingService();
    _loadDrawings();
  }

  Future<void> _loadDrawings() async {
    setState(() => _loading = true);
    try {
      final drawings = await _drawingService.getAllDrawings();
      setState(() => _drawings = drawings);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _createNewDrawing() async {
    final result = await Navigator.of(context).push<PlaneDrawing>(
      MaterialPageRoute(
        builder: (context) => PlanDrawingScreen(
          drawing: PlaneDrawing(
            id: const Uuid().v4(),
            title: 'Nuevo Plano',
            createdAt: DateTime.now(),
          ),
        ),
      ),
    );
    if (result != null) {
      await _drawingService.saveDrawing(result);
      _loadDrawings();
    }
  }

  void _openDrawing(PlaneDrawing drawing) async {
    final result = await Navigator.of(context).push<PlaneDrawing>(
      MaterialPageRoute(
        builder: (context) => PlanDrawingScreen(drawing: drawing),
      ),
    );
    if (result != null) {
      await _drawingService.saveDrawing(result);
      _loadDrawings();
    }
  }

  Future<void> _deleteDrawing(PlaneDrawing drawing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Plano'),
        content: Text('¿Eliminar "${drawing.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed == true) {
      await _drawingService.deleteDrawing(drawing.id);
      _loadDrawings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Planos',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _createNewDrawing,
          tooltip: 'Nuevo plano',
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _drawings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.draw, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Sin planos todavía', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _createNewDrawing,
                        child: const Text('Crear Primer Plano'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _drawings.length,
                  itemBuilder: (context, index) {
                    final drawing = _drawings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.draw),
                        title: Text(drawing.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${drawing.createdAt.day}/${drawing.createdAt.month}/${drawing.createdAt.year}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDrawing(drawing),
                        ),
                        onTap: () => _openDrawing(drawing),
                      ),
                    );
                  },
                ),
    );
  }
}
