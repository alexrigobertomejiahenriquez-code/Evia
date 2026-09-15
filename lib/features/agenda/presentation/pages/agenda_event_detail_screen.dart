import 'package:flutter/material.dart';

import '../../../../widgets/common/app_scaffold.dart';
import '../../domain/models/agenda_event.dart';
import 'agenda_event_form_screen.dart';

class AgendaEventDetailScreen extends StatefulWidget {
  final AgendaEvent event;
  final Future<void> Function(
    AgendaEvent previousEvent,
    AgendaEvent updatedEvent,
  ) onSave;
  final Future<void> Function(AgendaEvent event) onDelete;
  final Future<void> Function(AgendaEvent event, bool completed) onToggleTask;

  const AgendaEventDetailScreen({
    super.key,
    required this.event,
    required this.onSave,
    required this.onDelete,
    required this.onToggleTask,
  });

  @override
  State<AgendaEventDetailScreen> createState() =>
      _AgendaEventDetailScreenState();
}

class _AgendaEventDetailScreenState extends State<AgendaEventDetailScreen> {
  late AgendaEvent _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<AgendaEvent>(
      MaterialPageRoute(builder: (_) => AgendaEventFormScreen(event: _event)),
    );
    if (updated == null) return;

    await widget.onSave(_event, updated);
    if (!mounted) return;
    setState(() => _event = updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: Text('¿Deseas eliminar "${_event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await widget.onDelete(_event);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _toggleTask() async {
    await widget.onToggleTask(_event, !_event.isCompleted);
    if (!mounted) return;
    setState(() {
      _event = _event.markTaskCompleted(
        !_event.isCompleted,
        updatedAt: DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Detalle agenda',
      actions: [
        IconButton(
          onPressed: _edit,
          icon: const Icon(Icons.edit),
          tooltip: 'Editar',
        ),
        IconButton(
          onPressed: _confirmDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Eliminar',
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_event.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(_event.type.label)),
              Chip(label: Text(_event.status.label)),
              if (_event.reminder != null)
                Chip(label: Text(_event.reminder!.label)),
            ],
          ),
          const SizedBox(height: 16),
          _buildRow(context, 'Fecha', _formatDate(_event.date)),
          _buildRow(
            context,
            'Hora',
            _event.allDay ? 'Todo el día' : _formatTimeRange(_event),
          ),
          _buildRow(
            context,
            'Descripción',
            _event.description.isEmpty ? 'Sin descripción' : _event.description,
          ),
          _buildRow(
            context,
            'Ubicación',
            _event.location?.isEmpty ?? true
                ? 'Sin ubicación'
                : _event.location!,
          ),
          _buildRow(context, 'Categoría', _event.type.label),
          _buildRow(context, 'Estado', _event.status.label),
          _buildRow(
            context,
            'Proyecto',
            _event.relations.projectName == null ||
                    _event.relations.projectName!.isEmpty
                ? 'Sin proyecto relacionado'
                : _event.relations.projectName!,
          ),
          _buildRow(
            context,
            'Cliente',
            _event.relations.clientName == null ||
                    _event.relations.clientName!.isEmpty
                ? 'Sin cliente relacionado'
                : _event.relations.clientName!,
          ),
          _buildRow(
            context,
            'Recordatorio',
            _event.reminder == null
                ? 'Sin recordatorio'
                : '${_event.reminder!.label}\nLa programación nativa aún no está activa; se sincroniza con Avisos cuando la app se abre.',
          ),
          _buildRow(
            context,
            'Notas',
            _event.notes.isEmpty ? 'Sin notas' : _event.notes,
          ),
          const SizedBox(height: 24),
          if (_event.isTask)
            ElevatedButton.icon(
              onPressed: _toggleTask,
              icon: Icon(_event.isCompleted ? Icons.undo : Icons.check_circle),
              label: Text(
                _event.isCompleted ? 'Marcar pendiente' : 'Completar tarea',
              ),
            ),
          if (_event.isTask) const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _edit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  String _formatTimeRange(AgendaEvent event) {
    final start = _formatMinutes(event.startMinutes);
    if (event.endMinutes == null) return start;
    return '$start - ${_formatMinutes(event.endMinutes!)}';
  }

  String _formatMinutes(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
