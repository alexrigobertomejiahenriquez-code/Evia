import 'dart:async';
import '../ia/ia_service.dart';

class MockIaService implements IaService {
  @override
  Future<String> ask(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return 'Respuesta mock a: "'
        '\$prompt". (Esta es una respuesta simulada. Integra la IA real más tarde.)';
  }
}
