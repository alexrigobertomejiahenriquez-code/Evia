import 'dart:async';
import 'voice_service.dart';

class MockVoiceService implements VoiceService {
  bool _recording = false;

  @override
  Future<void> startRecording() async {
    _recording = true;
  }

  @override
  Future<List<int>> stopRecording() async {
    _recording = false;
    // Retornar array vacío como placeholder
    return <int>[];
  }

  @override
  Future<String> transcribe(List<int> audioBytes) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Transcripción mock (sin audio real)';
  }
}
