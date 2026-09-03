import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/offline_state_view.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/chat_message.dart';
import 'providers/chat_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _textController.text.trim();
    if (text.isEmpty) return;

    final locale = Localizations.localeOf(context).languageCode;
    ref.read(chatMessagesProvider.notifier).sendMessage(text, languageCode: locale);
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chatState = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.chatTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              l10n.chatSubtitle,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => OfflineStateView(
                message: err.toString(),
                onRetry: () => ref.read(chatMessagesProvider.notifier).loadMessages(),
              ),
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _buildMessageItem(context, msg);
                },
              ),
            ),
          ),

          // Bottom Input Bar with large buttons
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: l10n.chatInputPlaceholder,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Voice hint icon button (accessible tap target)
                  IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.mic_none_rounded, color: Colors.blueGrey),
                    tooltip: 'Voice Hint',
                    onPressed: () {
                      // Voice input hint for low-literacy users
                      _sendMessage('What scholarships are available for Class 12?');
                    },
                  ),
                  // Send button (min 48x48)
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                      tooltip: l10n.chatSend,
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, ChatMessage msg) {
    final isUser = msg.isUser;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.smart_toy_outlined, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? primaryColor : const Color(0xFFE8ECEF),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Suggested quick-replies for low-literacy users (tap to ask)
          if (!isUser && msg.suggestedReplies != null && msg.suggestedReplies!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.suggestedReplies!
                    .map(
                      (reply) => ActionChip(
                        label: Text(reply, style: const TextStyle(fontSize: 12.5)),
                        avatar: const Icon(Icons.touch_app_outlined, size: 16),
                        onPressed: () => _sendMessage(reply),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
