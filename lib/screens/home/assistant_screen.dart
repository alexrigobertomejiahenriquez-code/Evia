import 'package:flutter/material.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../services/ia/ia_service.dart';
import '../../services/mock/mock_ia_service.dart';

class ChatMessage {
  final String text;
  final bool fromUser;
  ChatMessage({required this.text, required this.fromUser});
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final IaService _ia = MockIaService(); // Mantener MockIaService como implementación actual.
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromUser: true));
      _loading = true;
      _ctrl.clear();
    });
    _scrollToEnd();

    try {
      final response = await _ia.ask(text);
      setState(() {
        _messages.add(ChatMessage(text: response, fromUser: false));
      });
      _scrollToEnd();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error al obtener respuesta: $e', fromUser: false));
      });
      _scrollToEnd();
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _scrollToEnd() {
    // Pequeño delay para permitir que la UI se actualice antes de scrollear.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    setState(() {
      _messages.clear();
    });
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final alignment = msg.fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = msg.fromUser ? Colors.blue.shade700 : Colors.grey.shade200;
    final textColor = msg.fromUser ? Colors.white : Colors.black87;
    final radius = msg.fromUser
        ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12))
        : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: radius,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Text(
              msg.text,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Asistente IA',
      actions: [
        IconButton(
          tooltip: 'Nueva conversación',
          onPressed: _messages.isEmpty ? null : _clearConversation,
          icon: const Icon(Icons.delete_forever),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'Empieza la conversación con EVIA',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: _buildMessageBubble(msg),
                      );
                    },
                  ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('EVIA está escribiendo...'),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      textInputAction: TextInputAction.send,
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    onPressed: _loading ? null : _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
