import '../models/chat_message.dart';

/// Abstract repository interface for career-guidance AI chatbot.
abstract class ChatRepository {
  Future<List<ChatMessage>> getConversationHistory();
  Future<ChatMessage> sendMessage(String text, {String languageCode = 'en'});
}
