// lib/services/projects/project_service.dart

import 'package:uuid/uuid.dart';
import '../../models/project.dart';

abstract class ProjectService {
  Future<List<Project>> getAllProjects();
  Future<Project?> getProjectById(String id);
  Future<Project> createProject(Project project);
  Future<Project> updateProject(Project project);
  Future<bool> deleteProject(String id);
}

class MockProjectService implements ProjectService {
  final List<Project> _projects = [];

  MockProjectService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _projects.addAll([
      Project(
        id: '1',
        name: 'Reforma Cocina',
        description: 'Modernización completa de la cocina con electrodomésticos nuevos',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        status: 'in_progress',
        address: 'Calle Principal 123',
        estimatedBudget: 5000.0,
        tags: ['cocina', 'renovación', 'residencial'],
      ),
      Project(
        id: '2',
        name: 'Construcción Casa Nueva',
        description: 'Construcción de vivienda unifamiliar de 200m²',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 180)),
        status: 'planning',
        address: 'Sector Las Flores',
        estimatedBudget: 50000.0,
        tags: ['construcción', 'vivienda', 'obra nueva'],
      ),
      Project(
        id: '3',
        name: 'Remodelación Baño',
        description: 'Cambio de sanitarios y azulejos',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().subtract(const Duration(days: 5)),
        status: 'completed',
        address: 'Calle Secundaria 456',
        estimatedBudget: 2000.0,
        tags: ['baño', 'remodelación', 'completado'],
      ),
    ]);
  }

  @override
  Future<List<Project>> getAllProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_projects);
  }

  @override
  Future<Project?> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Project> createProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newProject = project.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );
    _projects.add(newProject);
    return newProject;
  }

  @override
  Future<Project> updateProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      _projects[index] = project;
    }
    return project;
  }

  @override
  Future<bool> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _projects.removeWhere((p) => p.id == id);
    return true;
  }
}
