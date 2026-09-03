import 'package:flutter/foundation.dart';
import '../data/api_client.dart';
import 'auth_provider.dart';
import 'opportunities_provider.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? actionSuggestions;
  final List<Map<String, dynamic>>? referencedOpportunities;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actionSuggestions,
    this.referencedOpportunities,
  });
}

class ChatProvider extends ChangeNotifier {
  final DreamCatcherApiClient _apiClient;
  final AuthProvider _authProvider;
  final OpportunitiesProvider _oppsProvider;

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _sessionId;

  ChatProvider(this._apiClient, this._authProvider, this._oppsProvider) {
    _initWelcomeMessage();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  String? get sessionId => _sessionId;

  void _initWelcomeMessage() {
    final student = _authProvider.currentStudent;
    final name = student?.name.split(' ').first ?? 'there';
    final district = student?.location?.district ?? 'your district';

    final aspiration = student?.aspirations.isNotEmpty == true
        ? student!.aspirations.first.aspirationText
        : null;

    String welcomeText = 'Namaste, $name! 🙏 I am your DreamCatcher AI Career Counselor, powered by Vertex AI.';
    if (aspiration != null) {
      welcomeText += ' I see your ambition is to become **$aspiration**. I can help you find government scholarships, free vocational courses, and entrance exams.';
    } else {
      welcomeText += ' Ask me about scholarships, admission deadlines, or courses available near $district.';
    }

    _messages.add(
      ChatMessage(
        id: 'msg_0',
        text: welcomeText,
        isUser: false,
        timestamp: DateTime.now(),
        actionSuggestions: [
          'Which scholarships can I get?',
          'How do I prepare for technical exams?',
          'Find courses near my district',
        ],
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMsg);
    _isTyping = true;
    notifyListeners();

    try {
      final student = _authProvider.currentStudent;
      if (student != null) {
        final res = await _apiClient.sendAssistantMessage(
          studentId: student.id,
          message: text.trim(),
          language: student.preferredLanguage,
          sessionId: _sessionId,
        );

        final reply = res['reply'] as String? ?? 'I am here to guide you.';
        final suggestions = (res['suggested_actions'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            ['Show matched opportunities', 'What skills should I learn next?'];

        // Track session ID for multi-turn context
        final newSessionId = res['session_id'] as String?;
        if (newSessionId != null) {
          _sessionId = newSessionId;
        }

        // Parse referenced opportunities
        final refs = (res['referenced_opportunities'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList();

        _messages.add(
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
            actionSuggestions: suggestions,
            referencedOpportunities: refs,
          ),
        );
      } else {
        // Fallback if no student is active
        final reply = await _generateProfileAwareResponse(text.trim());
        _messages.add(
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
            text: reply,
            isUser: false,
            timestamp: DateTime.now(),
            actionSuggestions: [
              'Show matched opportunities',
              'What skills should I learn next?',
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error from AI Assistant endpoint: $e. Using local reasoning.');
      final fallbackReply = await _generateProfileAwareResponse(text.trim());
      _messages.add(
        ChatMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
          text: fallbackReply,
          isUser: false,
          timestamp: DateTime.now(),
          actionSuggestions: [
            'Which scholarships can I get?',
            'What skills should I build next?',
          ],
        ),
      );
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  /// Start a fresh conversation — clears messages and resets session
  void startNewChat() {
    _messages.clear();
    _sessionId = null;
    _initWelcomeMessage();
    notifyListeners();
  }

  // =========================================================================
  // Profile-Aware Local Fallback Response Generator
  // =========================================================================
  Future<String> _generateProfileAwareResponse(String query) async {
    final student = _authProvider.currentStudent;
    final name = student?.name ?? 'student';
    final lower = query.toLowerCase();

    final skillNames = student?.skills.map((s) => s.skill?.canonicalName ?? '').where((s) => s.isNotEmpty).toList() ?? [];
    final interestNames = student?.interests.map((i) => i.interest?.name ?? '').where((i) => i.isNotEmpty).toList() ?? [];
    final aspiration = student?.aspirations.isNotEmpty == true ? student!.aspirations.first.aspirationText : null;
    final state = student?.location?.state ?? 'India';

    if (lower.contains('scholarship') || lower.contains('money') || lower.contains('fee')) {
      final matchedCount = _oppsProvider.totalMatchedCount;
      return 'Based on your background in $state, we identified **$matchedCount potential scholarships & support programs** matching your profile! Check the Opportunities tab to view AICTE Pragati, Post-Matric, and state government fee waivers that match your criteria.';
    }

    if (lower.contains('skill') || lower.contains('learn') || lower.contains('study')) {
      if (skillNames.isNotEmpty) {
        return 'You already noted experience in **${skillNames.join(', ')}**. For students aiming at high-growth roles in rural and semi-urban hubs, adding **Drone Pilot certification** or **Renewable Energy (Solar) Maintenance** can boost employment chances by over 40%!';
      }
      return 'Building practical hands-on skills in digital tools, agricultural technology, or electrical maintenance will give you an advantage for regional technical diplomas.';
    }

    if (lower.contains('exam') || lower.contains('entrance') || lower.contains('admission')) {
      return 'Several government entrance examinations offer fee waivers and reserved quotas for students from rural districts. You can view all upcoming entrance tests with their registration deadlines in the Opportunities tab under the "Exams" filter.';
    }

    if (aspiration != null && (lower.contains('job') || lower.contains('career') || lower.contains('drone') || lower.contains('goal'))) {
      return 'To achieve your goal of becoming an **$aspiration**, the recommended pathway is:\n1. Complete your secondary/diploma certification.\n2. Apply for recognized state vocational courses.\n3. Take advantage of district government stipends and free toolkits.';
    }

    // Default contextual response
    return 'Thank you for asking, $name. With your interest in ${interestNames.isNotEmpty ? interestNames.first : "technical education"}, there are multiple government-backed pathways open for you. Would you like me to guide you through applying for the top-matching opportunity right now?';
  }
}
