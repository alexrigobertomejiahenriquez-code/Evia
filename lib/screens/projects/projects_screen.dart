// lib/screens/projects/projects_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../models/project.dart';
import '../../services/projects/project_service.dart';
import 'project_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  late final ProjectService _projectService;
  List<Project> _projects = [];
  bool _loading = false;
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _projectService = MockProjectService();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _loading = true);
    try {
      final projects = await _projectService.getAllProjects();
      setState(() => _projects = projects);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openProjectForm({Project? project}) async {
    final result = await Navigator.of(context).push<Project>(
      MaterialPageRoute(
        builder: (context) => ProjectFormScreen(project: project),
      ),
    );
    if (result != null) {
      if (project != null) {
        await _projectService.updateProject(result);
      } else {
        await _projectService.createProject(result);
      }
      _loadProjects();
    }
  }

  void _openProjectDetail(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailScreen(
          project: project,
          onEdit: () => _openProjectForm(project: project),
          onDelete: _deleteProject,
        ),
      ),
    );
  }

  Future<void> _deleteProject(Project project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content: Text('¿Eliminar "${project.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed == true) {
      await _projectService.deleteProject(project.id);
      _loadProjects();
      if (mounted) Navigator.pop(context);
    }
  }

  List<Project> _getFilteredProjects() {
    if (_selectedStatus == 'all') return _projects;
    return _projects.where((p) => p.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredProjects();

    return AppScaffold(
      title: 'Proyectos',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openProjectForm(),
          tooltip: 'Nuevo proyecto',
        ),
      ],
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildStatusChip('all', 'Todos'),
                  _buildStatusChip('planning', 'Planificación'),
                  _buildStatusChip('in_progress', 'En Progreso'),
                  _buildStatusChip('completed', 'Completado'),
                  _buildStatusChip('on_hold', 'En Pausa'),
                ].map((w) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0), child: w)).toList(),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          'Sin proyectos${_selectedStatus != 'all' ? ' en este estado' : ''}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildProjectCard(filtered[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String value, String label) {
    final isSelected = _selectedStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedStatus = value),
    );
  }

  Widget _buildProjectCard(Project project) {
    final statusColors = {
      'planning': Colors.blue,
      'in_progress': Colors.orange,
      'completed': Colors.green,
      'on_hold': Colors.grey,
    };
    final statusLabels = {
      'planning': 'Planificación',
      'in_progress': 'En Progreso',
      'completed': 'Completado',
      'on_hold': 'En Pausa',
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColors[project.status] ?? Colors.grey,
          child: Icon(Icons.folder_open, color: Colors.white),
        ),
        title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Chip(
              label: Text(statusLabels[project.status] ?? 'Desconocido', style: const TextStyle(fontSize: 12)),
              backgroundColor: statusColors[project.status]?.withOpacity(0.3),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _openProjectDetail(project),
        ),
        onTap: () => _openProjectDetail(project),
      ),
    );
  }
}
