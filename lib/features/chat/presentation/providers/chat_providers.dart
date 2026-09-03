import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/repositories/mock_chat_repository.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

/// Active ChatRepository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final useMock = ref.watch(useMockRepositoriesProvider);
  if (useMock) {
    return MockChatRepository();
  }
  return MockChatRepository();
});

/// Async notifier for chat conversation
class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    state = const AsyncValue.loading();
    try {
      final messages = await _repository.getConversationHistory();
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String text, {String languageCode = 'en'}) async {
    final currentList = state.value ?? [];
    // Optimistically show user message
    final optimisticUserMsg = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    state = AsyncValue.data([...currentList, optimisticUserMsg]);

    try {
      await _repository.sendMessage(text, languageCode: languageCode);
      final refreshed = await _repository.getConversationHistory();
      state = AsyncValue.data(refreshed);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatMessage>>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repo);
});
