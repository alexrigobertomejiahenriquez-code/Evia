import 'dart:async';
import '../ia/ia_service.dart';

class MockIaService implements IaService {
  final Map<String, String> _responses = {
    'hola': '¡Hola! Soy EVIA, tu asistente personal. ¿En qué puedo ayudarte?',
    'ayuda': 'Puedo ayudarte con: proyectos, planos, cotizaciones, agenda, documentos, búsqueda y más. ¿Qué necesitas?',
    'qué puedes hacer': 'Puedo ayudarte a crear y gestionar proyectos, diseñar planos, generar cotizaciones, organizar tu agenda, gestionar documentos, y mucho más.',
    'proyectos': 'Accede a la sección de Proyectos para crear, editar y gestionar todos tus proyectos.',
    'plano': 'Puedes dibujar planos directamente en la app. Abre la sección de Planos para comenzar.',
    'cotizar': 'En la sección Cotizar puedes crear cotizaciones detalladas con materiales, mano de obra y cálculos automáticos.',
    'agenda': 'En la Agenda puedes organizar tus eventos, establecer recordatorios y planificar tu tiempo.',
    'documento': 'Gestiona documentos, cartas, constancias y más en la sección de Documentos.',
    'compras': 'En Compras puedes organizar tus pedidos, inventario y proveedores.',
    'ebook': 'Consulta nuestros eBooks con información técnica, guías y referencias.',
  };

  String _findBestMatch(String prompt) {
    final lower = prompt.toLowerCase();
    for (final keyword in _responses.keys) {
      if (lower.contains(keyword)) {
        return _responses[keyword]!;
      }
    }
    return _getDefaultResponse(prompt);
  }

  String _getDefaultResponse(String prompt) {
    final responses = [
      'Interesante pregunta. Puedo ayudarte con eso en EVIA.',
      'Entendido. Cuéntame más detalles para ayudarte mejor.',
      'Buena idea. ¿Necesitas ayuda con proyectos, planos, cotizaciones o documentos?',
      'Anotado. ¿Hay algo más en lo que pueda asistirte?',
      'Perfecto. Estoy aquí para facilitar tu trabajo.',
    ];
    return responses[prompt.length % responses.length];
  }

  @override
  Future<String> ask(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _findBestMatch(prompt);
  }
}
