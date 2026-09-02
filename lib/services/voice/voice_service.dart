abstract class VoiceService {
  /// Recibe bytes de audio y devuelve la transcripción.
  Future<String> transcribe(List<int> audioBytes);

  /// Inicia la grabación (placeholder).
  Future<void> startRecording();

  /// Para la grabación (placeholder) y devuelve los bytes.
  Future<List<int>> stopRecording();
}
