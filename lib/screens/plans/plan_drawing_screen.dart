// lib/screens/plans/plan_drawing_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../models/drawing_point.dart';
import 'drawing_canvas_widget.dart';
import 'space_annotation_dialog.dart';

class PlanDrawingScreen extends StatefulWidget {
  final PlaneDrawing drawing;

  const PlanDrawingScreen({super.key, required this.drawing});

  @override
  State<PlanDrawingScreen> createState() => _PlanDrawingScreenState();
}

class _PlanDrawingScreenState extends State<PlanDrawingScreen> {
  late TextEditingController _titleCtrl;
  late List<DrawingLine> _lines;
  late Map<int, String> _spaces;
  late Map<int, String> _measurements;
  int _nextSpaceNumber = 1;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.drawing.title);
    _lines = List.from(widget.drawing.lines);
    _spaces = Map.from(widget.drawing.spaces);
    _measurements = Map.from(widget.drawing.measurements);
    _nextSpaceNumber = (_spaces.keys.isEmpty ? 0 : _spaces.keys.reduce((a, b) => a > b ? a : b)) + 1;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _addSpaceAnnotation() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => SpaceAnnotationDialog(
        spaceNumber: _nextSpaceNumber,
      ),
    );
    if (result != null) {
      setState(() {
        _spaces[_nextSpaceNumber] = result['name'] ?? '';
        _measurements[_nextSpaceNumber] = result['measurements'] ?? '';
        _nextSpaceNumber++;
      });
    }
  }

  void _save() {
    final updatedDrawing = PlaneDrawing(
      id: widget.drawing.id,
      title: _titleCtrl.text.isEmpty ? 'Plano' : _titleCtrl.text,
      createdAt: widget.drawing.createdAt,
      lines: _lines,
      spaces: _spaces,
      measurements: _measurements,
    );
    Navigator.pop(context, updatedDrawing);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dibujar Plano',
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _save,
          tooltip: 'Guardar',
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre del Plano',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: DrawingCanvasWidget(
              initialLines: _lines,
              onDrawingChanged: (lines) => _lines = lines,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Espacios y Medidas', style: TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: _addSpaceAnnotation,
                      icon: const Icon(Icons.add),
                      label: const Text('Añadir Espacio'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_spaces.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: _spaces.length,
                      itemBuilder: (context, index) {
                        final spaceNum = _spaces.keys.elementAt(index);
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('$spaceNum')),
                            title: Text(_spaces[spaceNum]!),
                            subtitle: Text('${_measurements[spaceNum]}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, size: 18),
                              onPressed: () {
                                setState(() {
                                  _spaces.remove(spaceNum);
                                  _measurements.remove(spaceNum);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text('Sin espacios definidos', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
