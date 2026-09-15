import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/project.dart';
import '../../../../services/projects/project_service.dart';
import '../../../../widgets/common/app_scaffold.dart';
import '../../domain/models/agenda_event.dart';

class AgendaEventFormScreen extends StatefulWidget {
  final AgendaEvent? event;

  const AgendaEventFormScreen({super.key, this.event});

  @override
  State<AgendaEventFormScreen> createState() => _AgendaEventFormScreenState();
}

class _AgendaEventFormScreenState extends State<AgendaEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _clientController = TextEditingController();
  final ProjectService _projectService = MockProjectService();

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _allDay = false;
  AgendaEventType _type = AgendaEventType.event;
  AgendaEventStatus _status = AgendaEventStatus.pending;
  AgendaReminderPreset? _reminderPreset;
  DateTime? _customReminderDateTime;
  List<Project> _projects = const <Project>[];
  String? _selectedProjectId;
  String? _selectedProjectName;
  bool _loadingProjects = true;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    final nowTime = TimeOfDay.now();
    _selectedDate = event?.date ?? AgendaEvent.normalizeDate(DateTime.now());
    _startTime = event == null ? TimeOfDay(hour: nowTime.hour, minute: 0) : _timeOfDayFromMinutes(event.startMinutes);
    _endTime = event?.endMinutes == null ? null : _timeOfDayFromMinutes(event!.endMinutes!);
    _allDay = event?.allDay ?? false;
    _type = event?.type ?? AgendaEventType.event;
    _status = event?.status ?? AgendaEventStatus.pending;
    _titleController.text = event?.title ?? '';
    _descriptionController.text = event?.description ?? '';
    _locationController.text = event?.location ?? '';
    _notesController.text = event?.notes ?? '';
    _clientController.text = event?.relations.clientName ?? '';
    _selectedProjectId = event?.relations.projectId;
    _selectedProjectName = event?.relations.projectName;
    _reminderPreset = event?.reminder?.preset;
    _customReminderDateTime = event?.reminder?.customTriggerAt;
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await _projectService.getAllProjects();
    if (!mounted) return;
    setState(() {
      _projects = projects;
      _loadingProjects = false;
      if (_selectedProjectId != null &&
          !_projects.any((project) => project.id == _selectedProjectId)) {
        _selectedProjectId = null;
        _selectedProjectName = null;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
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

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        if (_endTime != null && _toMinutes(_endTime!) < _toMinutes(picked)) {
          _endTime = null;
        }
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _pickCustomReminderDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _customReminderDateTime ?? _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _customReminderDateTime == null
          ? const TimeOfDay(hour: 8, minute: 0)
          : TimeOfDay.fromDateTime(_customReminderDateTime!),
    );
    if (time == null) return;

    setState(() {
      _customReminderDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    final state = _formKey.currentState;
    if (state == null || !state.validate()) return;

    if (!_allDay && _startTime == null) {
      _showError('Selecciona una hora de inicio.');
      return;
    }

    final startMinutes = _allDay ? 0 : _toMinutes(_startTime!);
    final endMinutes = _allDay || _endTime == null ? null : _toMinutes(_endTime!);
    if (!_allDay && endMinutes != null && endMinutes < startMinutes) {
      _showError('La hora final no puede ser anterior a la hora inicial.');
      return;
    }

    AgendaReminder? reminder;
    if (_reminderPreset != null) {
      if (_reminderPreset == AgendaReminderPreset.custom && _customReminderDateTime == null) {
        _showError('Selecciona la fecha y hora del recordatorio personalizado.');
        return;
      }
      reminder = AgendaReminder(
        preset: _reminderPreset!,
        customTriggerAt: _reminderPreset == AgendaReminderPreset.custom ? _customReminderDateTime : null,
      );
    }

    try {
      final now = DateTime.now();
      final event = AgendaEvent(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        allDay: _allDay,
        type: _type,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        status: _type == AgendaEventType.task ? _status : AgendaEventStatus.pending,
        notes: _notesController.text,
        createdAt: widget.event?.createdAt ?? now,
        updatedAt: now,
        reminder: reminder,
        relations: AgendaRelations(
          projectId: _selectedProjectId,
          projectName: _selectedProjectName,
          clientName: _clientController.text.trim().isEmpty ? null : _clientController.text.trim(),
        ),
      );
      Navigator.of(context).pop(event);
    } on FormatException catch (error) {
      _showError(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return AppScaffold(
      title: isEditing ? 'Editar agenda' : 'Nuevo en agenda',
      actions: [
        TextButton(onPressed: _save, child: const Text('Guardar')),
      ],
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Título *',
                hintText: 'Ej. Reunión con cliente',
              ),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'El título es obligatorio.' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AgendaEventType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Categoría'),
              items: AgendaEventType.values
                  .map((type) => DropdownMenuItem(value: type, child: Text(type.label)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _type = value;
                  if (_type != AgendaEventType.task) {
                    _status = AgendaEventStatus.pending;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Todo el día'),
              value: _allDay,
              onChanged: (value) => setState(() {
                _allDay = value;
                if (value) {
                  _endTime = null;
                }
              }),
            ),
            if (!_allDay) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hora de inicio'),
                subtitle: Text(_startTime == null ? 'Seleccionar' : _startTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickStartTime,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hora final (opcional)'),
                subtitle: Text(_endTime == null ? 'Sin hora final' : _endTime!.format(context)),
                trailing: const Icon(Icons.schedule),
                onTap: _pickEndTime,
              ),
            ],
            if (_type == AgendaEventType.task)
              DropdownButtonFormField<AgendaEventStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Estado de la tarea'),
                items: const [
                  DropdownMenuItem(
                    value: AgendaEventStatus.pending,
                    child: Text('Pendiente'),
                  ),
                  DropdownMenuItem(
                    value: AgendaEventStatus.completed,
                    child: Text('Completada'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AgendaReminderPreset?>(
              value: _reminderPreset,
              decoration: const InputDecoration(labelText: 'Recordatorio'),
              items: [
                const DropdownMenuItem<AgendaReminderPreset?>(value: null, child: Text('Sin recordatorio')),
                ...AgendaReminderPreset.values.map(
                  (preset) => DropdownMenuItem<AgendaReminderPreset?>(
                    value: preset,
                    child: Text(preset.label),
                  ),
                ),
              ],
              onChanged: (value) => setState(() {
                _reminderPreset = value;
                if (value != AgendaReminderPreset.custom) {
                  _customReminderDateTime = null;
                }
              }),
            ),
            if (_reminderPreset == AgendaReminderPreset.custom)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hora personalizada del recordatorio'),
                subtitle: Text(
                  _customReminderDateTime == null
                      ? 'Seleccionar fecha y hora'
                      : '${_formatDate(_customReminderDateTime!)} ${TimeOfDay.fromDateTime(_customReminderDateTime!).format(context)}',
                ),
                trailing: const Icon(Icons.notifications_active_outlined),
                onTap: _pickCustomReminderDateTime,
              ),
            if (_reminderPreset != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Los recordatorios quedan preparados y se convierten en Avisos cuando la app vuelve a abrirse; la programación nativa aún no está activa.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 12),
            if (_loadingProjects)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String?>(
                value: _selectedProjectId,
                decoration: const InputDecoration(labelText: 'Proyecto relacionado'),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('Sin proyecto')),
                  ..._projects.map(
                    (project) => DropdownMenuItem<String?>(
                      value: project.id,
                      child: Text(project.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  final project = _projects.where((item) => item.id == value).firstOrNull;
                  setState(() {
                    _selectedProjectId = value;
                    _selectedProjectName = project?.name;
                  });
                },
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clientController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Cliente relacionado'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notas'),
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Guardar cambios' : 'Crear evento'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  TimeOfDay _timeOfDayFromMinutes(int value) => TimeOfDay(hour: value ~/ 60, minute: value % 60);

  int _toMinutes(TimeOfDay value) => value.hour * 60 + value.minute;

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
