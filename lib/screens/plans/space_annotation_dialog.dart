// lib/screens/plans/space_annotation_dialog.dart

import 'package:flutter/material.dart';

class SpaceAnnotationDialog extends StatefulWidget {
  final int spaceNumber;

  const SpaceAnnotationDialog({super.key, required this.spaceNumber});

  @override
  State<SpaceAnnotationDialog> createState() => _SpaceAnnotationDialogState();
}

class _SpaceAnnotationDialogState extends State<SpaceAnnotationDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _measCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _measCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _measCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Espacio #${widget.spaceNumber}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del Espacio',
              hintText: 'ej: Sala, Cocina, Dormitorio',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _measCtrl,
            decoration: const InputDecoration(
              labelText: 'Medidas',
              hintText: 'ej: 4x5 m, 300 cm²',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameCtrl.text.isNotEmpty) {
              Navigator.pop(context, {
                'name': _nameCtrl.text,
                'measurements': _measCtrl.text.isEmpty ? 'No especificadas' : _measCtrl.text,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ingresa el nombre del espacio')),
              );
            }
          },
          child: const Text('Añadir'),
        ),
      ],
    );
  }
}
