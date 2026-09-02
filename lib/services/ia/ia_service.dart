abstract class IaService {
  /// Envía una pregunta/prompt a la IA y recibe una respuesta en texto.
  Future<String> ask(String prompt);
}
