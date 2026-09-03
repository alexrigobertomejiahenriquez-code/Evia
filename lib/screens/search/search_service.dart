import 'dart:async';
import 'search_model.dart';

class MockSearchService {
  final List<SearchResult> _items = [
    // Asistente IA
    SearchResult(title: 'Asistente IA', subtitle: 'Chat con EVIA', category: 'Asistente IA', route: 'assistant'),
    // eBook
    SearchResult(title: 'Guía de materiales - eBook', subtitle: 'Manual sobre materiales de construcción', category: 'eBook', route: 'ebook'),
    // Proyectos
    SearchResult(title: 'Proyecto Centro Comercial', subtitle: 'Detalles y planificaciones', category: 'Proyectos', route: 'projects'),
    // Planos
    SearchResult(title: 'Plano planta baja', subtitle: 'Plano arquitectónico - planta baja', category: 'Planos', route: 'plans'),
    // Cotizar
    SearchResult(title: 'Cotizar - Reforma cocina', subtitle: 'Solicitar cotización para reforma', category: 'Cotizar', route: 'quote'),
    // Agenda
    SearchResult(title: 'Reunión equipo obra', subtitle: 'Agenda del proyecto', category: 'Agenda', route: 'agenda'),
    // Documentos
    SearchResult(title: 'Acta entrega', subtitle: 'Documento de entrega final', category: 'Documentos', route: 'documents'),
    // Herramientas
    SearchResult(title: 'Calculadora de hormigón', subtitle: 'Herramienta para cálculos', category: 'Herramientas', route: 'tools'),
    // Avisos
    SearchResult(title: 'Aviso: corte de agua', subtitle: 'Notificación importante', category: 'Avisos', route: 'notifications'),
    // Compras
    SearchResult(title: 'Comprar ladrillos', subtitle: 'Materiales para la obra', category: 'Compras', route: 'purchases'),
    // Aprendizaje de idiomas
    SearchResult(title: 'Curso de inglés técnico', subtitle: 'Aprende vocabulario técnico', category: 'Aprendizaje', route: 'learning'),
  ];

  Future<List<SearchResult>> query(String q) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (q.trim().isEmpty) return [];
    final lower = q.toLowerCase();
    return _items.where((it) {
      return it.title.toLowerCase().contains(lower) || it.subtitle.toLowerCase().contains(lower) || it.category.toLowerCase().contains(lower);
    }).toList();
  }
}
