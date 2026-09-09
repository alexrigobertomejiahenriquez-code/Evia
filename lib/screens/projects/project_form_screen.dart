// lib/screens/projects/project_form_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../models/project.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _budgetCtrl;
  late TextEditingController _tagsCtrl;
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedStatus = 'planning';

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _nameCtrl = TextEditingController(text: project?.name ?? '');
    _descCtrl = TextEditingController(text: project?.description ?? '');
    _addressCtrl = TextEditingController(text: project?.address ?? '');
    _budgetCtrl = TextEditingController(text: project?.estimatedBudget?.toString() ?? '');
    _tagsCtrl = TextEditingController(text: project?.tags.join(', ') ?? '');
    _startDate = project?.startDate;
    _endDate = project?.endDate;
    _selectedStatus = project?.status ?? 'planning';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _addressCtrl.dispose();
    _budgetCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  void _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _saveProject() {
    if (_nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre es requerido')));
      return;
    }

    final tags = _tagsCtrl.text.isEmpty ? [] : _tagsCtrl.text.split(',').map((t) => t.trim()).toList();
    final budget = _budgetCtrl.text.isEmpty ? null : double.tryParse(_budgetCtrl.text);

    final project = Project(
      id: widget.project?.id ?? '',
      name: _nameCtrl.text,
      description: _descCtrl.text,
      createdAt: widget.project?.createdAt ?? DateTime.now(),
      startDate: _startDate,
      endDate: _endDate,
      status: _selectedStatus,
      address: _addressCtrl.text.isEmpty ? null : _addressCtrl.text,
      estimatedBudget: budget,
      tags: tags,
    );

    Navigator.pop(context, project);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.project != null ? 'Editar Proyecto' : 'Nuevo Proyecto',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del Proyecto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Dirección (opcional)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _budgetCtrl,
              decoration: const InputDecoration(labelText: 'Presupuesto Estimado (opcional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: const [
                DropdownMenuItem(value: 'planning', child: Text('Planificación')),
                DropdownMenuItem(value: 'in_progress', child: Text('En Progreso')),
                DropdownMenuItem(value: 'completed', child: Text('Completado')),
                DropdownMenuItem(value: 'on_hold', child: Text('En Pausa')),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value ?? 'planning'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha Inicio: ${_formatDate(_startDate)}'),
                      ElevatedButton(
                        onPressed: () => _selectDate(true),
                        child: const Text('Seleccionar'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha Fin: ${_formatDate(_endDate)}'),
                      ElevatedButton(
                        onPressed: () => _selectDate(false),
                        child: const Text('Seleccionar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsCtrl,
              decoration: const InputDecoration(labelText: 'Etiquetas (separadas por coma, opcional)'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProject,
                child: Text(widget.project != null ? 'Actualizar' : 'Crear'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) => date != null ? '${date.day}/${date.month}/${date.year}' : 'No seleccionada';
}
