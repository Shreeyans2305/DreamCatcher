import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Career Guide',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
              ),
            ),
            Text(
              'Profile-aware guidance & scholarships',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: DesignTokens.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: DesignTokens.mintBg,
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(color: DesignTokens.mintBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Online',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.mintText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final msg = chat.messages[index];
                return _buildMessageBubble(context, msg, chat);
              },
            ),
          ),

          // Typing Indicator
          if (chat.isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'DreamCatcher is thinking...',
                    style: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                  ),
                ],
              ),
            ),

          // Quick Action Suggestion Chips from latest message
          if (chat.messages.isNotEmpty &&
              chat.messages.last.actionSuggestions != null &&
              chat.messages.last.actionSuggestions!.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: chat.messages.last.actionSuggestions!.map((chipText) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: Colors.white,
                      label: Text(
                        chipText,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: DesignTokens.primary,
                        ),
                      ),
                      side: const BorderSide(color: DesignTokens.primary, width: 1),
                      onPressed: () {
                        chat.sendMessage(chipText);
                        _scrollToBottom();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          // Input Bar (padded for floating nav)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      border: Border.all(color: DesignTokens.border),
                      boxShadow: DesignTokens.softShadow,
                    ),
                    child: TextField(
                      controller: _textController,
                      style: GoogleFonts.inter(fontSize: 16, color: DesignTokens.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask about scholarships or careers...',
                        hintStyle: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          chat.sendMessage(val.trim());
                          _textController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: 'Send Message',
                  child: Material(
                    color: DesignTokens.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final val = _textController.text.trim();
                        if (val.isNotEmpty) {
                          chat.sendMessage(val);
                          _textController.clear();
                          _scrollToBottom();
                        }
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: DesignTokens.minTouchTarget,
                          minHeight: DesignTokens.minTouchTarget,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, ChatProvider chat) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: DesignTokens.lavenderBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school_rounded,
                color: DesignTokens.lavenderText,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? DesignTokens.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                border: isUser
                    ? null
                    : Border.all(color: DesignTokens.border.withValues(alpha: 0.8)),
                boxShadow: isUser ? null : DesignTokens.softShadow,
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.45,
                  color: isUser ? Colors.white : DesignTokens.textPrimary,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 6),
        ],
      ),
    );
  }
}
