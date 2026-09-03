enum MessageSender { user, assistant, system }

/// Represents a multilingual conversation message with the AI Career Advisor.
class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<String>? suggestedReplies;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.suggestedReplies,
  });

  bool get isUser => sender == MessageSender.user;

  @override
  String toString() => 'ChatMessage(id: $id, sender: ${sender.name}, text: $text)';
}
