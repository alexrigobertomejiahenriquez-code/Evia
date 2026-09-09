// lib/screens/plans/drawing_canvas_widget.dart

import 'package:flutter/material.dart';
import '../../models/drawing_point.dart';

class DrawingCanvasWidget extends StatefulWidget {
  final Function(List<DrawingLine>) onDrawingChanged;
  final List<DrawingLine> initialLines;

  const DrawingCanvasWidget({
    super.key,
    required this.onDrawingChanged,
    this.initialLines = const [],
  });

  @override
  State<DrawingCanvasWidget> createState() => _DrawingCanvasWidgetState();
}

class _DrawingCanvasWidgetState extends State<DrawingCanvasWidget> {
  late List<DrawingLine> _lines;
  late Paint _paint;
  bool _isDrawing = false;

  @override
  void initState() {
    super.initState();
    _lines = List.from(widget.initialLines);
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _onPanStart(DragStartDetails details) {
    _isDrawing = true;
    final points = [DrawingPoint(offset: details.localPosition, paint: Paint()..color = _paint.color..strokeWidth = _paint.strokeWidth)];
    _lines.add(DrawingLine(points: points, paint: _paint));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing || _lines.isEmpty) return;
    _lines.last.points.add(DrawingPoint(offset: details.localPosition, paint: Paint()..color = _paint.color..strokeWidth = _paint.strokeWidth));
    widget.onDrawingChanged(_lines);
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    _isDrawing = false;
  }

  void _clear() {
    setState(() {
      _lines.clear();
      widget.onDrawingChanged(_lines);
    });
  }

  void _undo() {
    if (_lines.isNotEmpty) {
      setState(() {
        _lines.removeLast();
        widget.onDrawingChanged(_lines);
      });
    }
  }

  void _setColor(Color color) {
    setState(() {
      _paint = Paint()
        ..color = color
        ..strokeWidth = _paint.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
    });
  }

  void _setStrokeWidth(double width) {
    setState(() {
      _paint = Paint()
        ..color = _paint.color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          color: Colors.grey[200],
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _clear,
                tooltip: 'Limpiar',
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _undo,
                tooltip: 'Deshacer',
              ),
              const Spacer(),
              // Color selector
              ...[
                Colors.black,
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
              ].map((color) => GestureDetector(
                    onTap: () => _setColor(color),
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: _paint.color == color ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(width: 16),
              // Stroke width selector
              PopupMenuButton<double>(
                initialValue: _paint.strokeWidth,
                onSelected: _setStrokeWidth,
                itemBuilder: (BuildContext context) => [1.0, 2.0, 4.0, 6.0, 8.0]
                    .map((width) => PopupMenuItem(
                          value: width,
                          child: Text('${width.toInt()}px'),
                        ))
                    .toList(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${_paint.strokeWidth.toInt()}px', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        // Canvas
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: DrawingPainter(_lines),
              size: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> lines;

  DrawingPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Grid (optional)
    _drawGrid(canvas, size);

    // Drawing lines
    for (final line in lines) {
      for (int i = 0; i < line.points.length - 1; i++) {
        canvas.drawLine(
          line.points[i].offset,
          line.points[i + 1].offset,
          line.paint,
        );
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    const gridSize = 50.0;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => oldDelegate.lines != lines;
}
