import 'package:flutter/material.dart';

import '../../../../services/notifications/notification_service_local.dart';
import '../../../../widgets/common/app_scaffold.dart';
import '../../data/agenda_reminder_service_local.dart';
import '../../data/agenda_repository_local.dart';
import '../../domain/models/agenda_event.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../widgets/agenda_event_card.dart';
import 'agenda_event_detail_screen.dart';
import 'agenda_event_form_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late final AgendaRepository _repository;
  late final AgendaReminderServiceLocal _reminderService;
  List<AgendaEvent> _events = const <AgendaEvent>[];
  DateTime _selectedDate = AgendaEvent.normalizeDate(DateTime.now());
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _repository = AgendaRepositoryLocal();
    _reminderService = AgendaReminderServiceLocal(
      notificationService: NotificationServiceLocal(),
    );
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _loading = true);
    try {
      final events = await _repository.getEvents();
      await _reminderService.syncDueReminders(events);
      if (!mounted) return;
      setState(() => _events = events);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openForm({AgendaEvent? event}) async {
    final result = await Navigator.of(context).push<AgendaEvent>(
      MaterialPageRoute(builder: (_) => AgendaEventFormScreen(event: event)),
    );
    if (result == null) return;

    await _repository.saveEvent(result);
    await _reminderService.syncEvent(result, previousEvent: event);
    await _loadEvents();
  }

  Future<void> _openDetail(AgendaEvent event) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AgendaEventDetailScreen(
          event: event,
          onSave: (previousEvent, updated) async {
            await _repository.saveEvent(updated);
            await _reminderService.syncEvent(updated, previousEvent: previousEvent);
            await _loadEvents();
          },
          onDelete: (target) async {
            await _repository.deleteEvent(target.id);
            await _reminderService.clearReminderStateForEvent(target.id);
            await _loadEvents();
          },
          onToggleTask: (target, completed) async {
            final updated = target.markTaskCompleted(completed, updatedAt: DateTime.now());
            await _repository.saveEvent(updated);
            await _reminderService.syncEvent(updated, previousEvent: target);
            await _loadEvents();
          },
        ),
      ),
    );
    if (mounted) {
      await _loadEvents();
    }
  }

  Future<void> _toggleTask(AgendaEvent event) async {
    final updated = event.markTaskCompleted(!event.isCompleted, updatedAt: DateTime.now());
    await _repository.saveEvent(updated);
    await _reminderService.syncEvent(updated, previousEvent: event);
    await _loadEvents();
  }

  Future<void> _pickSelectedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = AgendaEvent.normalizeDate(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = AgendaEvent.normalizeDate(DateTime.now());
    final selected = _events.where((event) => event.occursOn(_selectedDate)).toList();
    final todayEvents = _events.where((event) => event.occursOn(today)).toList();
    final upcoming = _events.where((event) => event.startDateTime.isAfter(today.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1)))).toList();
    final previous = _events.where((event) => event.startDateTime.isBefore(today)).toList().reversed.toList();
    final pendingTasks = _events.where((event) => event.isTask && !event.isCompleted).toList();
    final completedTasks = _events.where((event) => event.isTask && event.isCompleted).toList();

    return AppScaffold(
      title: 'Agenda',
      actions: [
        IconButton(
          tooltip: 'Seleccionar fecha',
          onPressed: _pickSelectedDate,
          icon: const Icon(Icons.calendar_month),
        ),
        IconButton(
          tooltip: 'Nuevo evento',
          onPressed: () => _openForm(),
          icon: const Icon(Icons.add),
        ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEvents,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.today),
                      title: const Text('Fecha seleccionada'),
                      subtitle: Text(_formatDate(_selectedDate)),
                      trailing: TextButton(
                        onPressed: _pickSelectedDate,
                        child: const Text('Cambiar'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_events.isEmpty)
                    _buildEmptyState()
                  else ...[
                    _buildSection('En la fecha seleccionada', selected),
                    _buildSection('Eventos de hoy', todayEvents),
                    _buildSection('Próximos', upcoming),
                    _buildSection('Anteriores', previous),
                    _buildSection('Tareas pendientes', pendingTasks),
                    _buildSection('Tareas completadas', completedTasks),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 72, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text('Aún no hay elementos en tu agenda.', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Crea eventos, tareas, recordatorios, citas o clases y mantén tus avisos sincronizados.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Crear primer evento'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<AgendaEvent> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Card(
            child: ListTile(
              title: Text('Sin elementos', style: Theme.of(context).textTheme.bodyLarge),
            ),
          )
        else
          ...items.map(
            (event) => AgendaEventCard(
              event: event,
              onTap: () => _openDetail(event),
              onToggleTask: event.isTask ? () => _toggleTask(event) : null,
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
