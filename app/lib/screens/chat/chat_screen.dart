import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_tokens.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: DesignTokens.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.assistantTitle,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              l10n.assistantSubtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: DesignTokens.slate600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded, color: DesignTokens.slate600),
            tooltip: l10n.assistantTitle,
            onPressed: () {
              chat.startNewChat();
              _scrollToBottom();
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: DesignTokens.sageBg,
              borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
              border: Border.all(color: DesignTokens.sageBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: DesignTokens.sageText,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Online',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.sageText,
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
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'DreamCatcher is thinking...',
                    style: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textMuted),
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
                      backgroundColor: DesignTokens.blushBg,
                      label: Text(
                        chipText,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.maroon900,
                        ),
                      ),
                      side: const BorderSide(color: DesignTokens.blushBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusPill),
                      ),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
                      style: GoogleFonts.inter(fontSize: 15, color: DesignTokens.textPrimary),
                      decoration: InputDecoration(
                        hintText: l10n.chatInputHint,
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textMuted),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                    color: DesignTokens.maroon900,
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
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 19,
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
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
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
                    Icons.auto_awesome_rounded,
                    color: DesignTokens.lavenderText,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: isUser ? DesignTokens.maroon900 : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: DesignTokens.border),
                    boxShadow: isUser
                        ? [
                            BoxShadow(
                              color: DesignTokens.maroon900.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : DesignTokens.softShadow,
                  ),
                  child: _buildMarkdownMessage(msg.text, isUser),
                ),
              ),
              if (isUser) const SizedBox(width: 6),
            ],
          ),

          // Referenced Opportunities Cards
          if (!isUser &&
              msg.referencedOpportunities != null &&
              msg.referencedOpportunities!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 46, top: 8),
              child: SizedBox(
                height: 82,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: msg.referencedOpportunities!.length.clamp(0, 3),
                  separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final opp = msg.referencedOpportunities![idx];
                    return _buildOpportunityCard(opp);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> opp) {
    final title = opp['title'] as String? ?? 'Opportunity';
    final type = opp['type'] as String? ?? '';
    final deadline = opp['deadline'] as String?;

    return Container(
      width: 210,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignTokens.lavenderBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DesignTokens.lavenderBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: DesignTokens.maroon900.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: DesignTokens.maroon900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (deadline != null) ...[
                const Spacer(),
                const Icon(Icons.schedule_rounded, size: 11, color: DesignTokens.slate600),
                const SizedBox(width: 3),
                Text(
                  deadline,
                  style: GoogleFonts.inter(fontSize: 10, color: DesignTokens.slate600),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DesignTokens.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownMessage(String text, bool isUser) {
    final baseColor = isUser ? Colors.white : DesignTokens.textPrimary;
    final mutedColor = isUser ? Colors.white.withValues(alpha: 0.85) : DesignTokens.textSecondary;

    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: GoogleFonts.inter(
          fontSize: 15,
          height: 1.45,
          color: baseColor,
        ),
        strong: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
        em: GoogleFonts.inter(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          color: baseColor,
        ),
        h1: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
        h2: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
        h3: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
        listBullet: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isUser ? Colors.white : DesignTokens.maroon900,
        ),
        listBulletPadding: const EdgeInsets.only(right: 6),
        code: GoogleFonts.inter(
          fontSize: 13,
          backgroundColor: isUser
              ? Colors.white.withValues(alpha: 0.2)
              : DesignTokens.blush200,
          color: isUser ? Colors.white : DesignTokens.maroon900,
        ),
        codeblockDecoration: BoxDecoration(
          color: isUser
              ? Colors.black.withValues(alpha: 0.15)
              : DesignTokens.cream50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUser
                ? Colors.white.withValues(alpha: 0.2)
                : DesignTokens.border,
          ),
        ),
        blockquote: GoogleFonts.inter(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: mutedColor,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isUser ? Colors.white70 : DesignTokens.primary,
              width: 3,
            ),
          ),
          color: isUser
              ? Colors.white.withValues(alpha: 0.08)
              : DesignTokens.cream50,
        ),
        a: GoogleFonts.inter(
          fontSize: 15,
          color: isUser ? Colors.white : DesignTokens.primary,
          decoration: TextDecoration.underline,
        ),
        pPadding: const EdgeInsets.only(bottom: 6),
        blockSpacing: 8,
      ),
    );
  }
}
