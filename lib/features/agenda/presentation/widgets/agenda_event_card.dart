import 'package:flutter/material.dart';

import '../../domain/models/agenda_event.dart';

class AgendaEventCard extends StatelessWidget {
  final AgendaEvent event;
  final VoidCallback onTap;
  final VoidCallback? onToggleTask;

  const AgendaEventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.onToggleTask,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = event.isCompleted
        ? colorScheme.tertiaryContainer
        : event.isTask
            ? colorScheme.secondaryContainer
            : colorScheme.primaryContainer;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(event.type.icon, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          event.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: event.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_subtitleText()),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(label: Text(event.type.label)),
                Chip(label: Text(event.status.label)),
                if (event.reminder != null) Chip(label: Text(event.reminder!.label)),
              ],
            ),
          ],
        ),
        trailing: event.isTask
            ? IconButton(
                tooltip: event.isCompleted ? 'Marcar pendiente' : 'Completar tarea',
                onPressed: onToggleTask,
                icon: Icon(event.isCompleted ? Icons.undo : Icons.check_circle),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  String _subtitleText() {
    final dateText = '${event.date.day.toString().padLeft(2, '0')}/${event.date.month.toString().padLeft(2, '0')}/${event.date.year}';
    if (event.allDay) {
      return 'Todo el día • $dateText';
    }
    final start = _formatMinutes(event.startMinutes);
    final end = event.endMinutes == null ? '' : ' - ${_formatMinutes(event.endMinutes!)}';
    final location = event.location == null || event.location!.isEmpty ? '' : ' • ${event.location}';
    return '$dateText • $start$end$location';
  }

  String _formatMinutes(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
