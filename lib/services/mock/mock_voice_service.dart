import 'dart:async';
import '../voice/voice_service.dart';

class MockVoiceService implements VoiceService {
  @override
  Future<void> startRecording() async {}

  @override
  Future<List<int>> stopRecording() async {
    // Retornar array vacío como placeholder
    return <int>[];
  }

  @override
  Future<String> transcribe(List<int> audioBytes) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Transcripción mock (sin audio real)';
  }
}
