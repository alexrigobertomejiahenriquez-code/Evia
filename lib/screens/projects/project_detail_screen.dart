// lib/screens/projects/project_detail_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final Function(Project) onDelete;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabels = {
      'planning': 'Planificación',
      'in_progress': 'En Progreso',
      'completed': 'Completado',
      'on_hold': 'En Pausa',
    };

    return AppScaffold(
      title: project.name,
      actions: [
        IconButton(icon: const Icon(Icons.edit), onPressed: onEdit, tooltip: 'Editar'),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(project),
          tooltip: 'Eliminar',
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Descripción', project.description),
            const SizedBox(height: 16),
            _buildSection('Estado', statusLabels[project.status] ?? project.status),
            if (project.address != null) ...[const SizedBox(height: 16), _buildSection('Dirección', project.address!)],
            if (project.estimatedBudget != null) ...[const SizedBox(height: 16), _buildSection('Presupuesto Estimado', '\$${project.estimatedBudget?.toStringAsFixed(2)}')] else [],
            if (project.startDate != null) ...[const SizedBox(height: 16), _buildSection('Fecha Inicio', _formatDate(project.startDate!))],
            if (project.endDate != null) ...[const SizedBox(height: 16), _buildSection('Fecha Fin', _formatDate(project.endDate!))],
            if (project.tags.isNotEmpty) ...[const SizedBox(height: 16), _buildTagsSection()],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Etiquetas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: project.tags.map((tag) => Chip(label: Text(tag))).toList(),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
