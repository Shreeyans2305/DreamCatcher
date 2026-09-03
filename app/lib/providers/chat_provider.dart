import 'package:flutter/foundation.dart';
import 'auth_provider.dart';
import 'opportunities_provider.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? actionSuggestions;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actionSuggestions,
  });
}

class ChatProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final OpportunitiesProvider _oppsProvider;

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatProvider(this._authProvider, this._oppsProvider) {
    _initWelcomeMessage();
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  void _initWelcomeMessage() {
    final student = _authProvider.currentStudent;
    final name = student?.name ?? 'there';
    final district = student?.location?.district ?? 'your district';

    final aspiration = student?.aspirations.isNotEmpty == true
        ? student!.aspirations.first.aspirationText
        : null;

    String welcomeText = 'Namaste, $name! 🙏 I am your DreamCatcher AI Career Counselor.';
    if (aspiration != null) {
      welcomeText += ' I noticed your dream is to become **$aspiration**. I can help you find suitable scholarships, entrance exams, and vocational programs.';
    } else {
      welcomeText += ' Tell me what career or scholarship you are exploring, or ask any question about opportunities in $district.';
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

    // Simulate natural response latency
    await Future.delayed(const Duration(milliseconds: 700));

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

    _isTyping = false;
    notifyListeners();
  }

  // =========================================================================
  // Profile-Aware Response Generator
  // TODO: replace with real LLM endpoint (e.g., Vertex AI / DreamCatcher RAG stream)
  // Structure: swap this single function with a streaming or POST call to the backend LLM service.
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
