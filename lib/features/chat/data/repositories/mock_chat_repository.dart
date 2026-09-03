import 'dart:math';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

/// Mock ChatRepository simulating AI career advisor responses with 300-1500ms delay.
class MockChatRepository implements ChatRepository {
  final Random _random = Random();
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: 'msg_001',
      text:
          'Namaste Priya! I can guide you on polytechnic courses, government scholarships, and solar technician training in Madhya Pradesh. What would you like to explore today?',
      sender: MessageSender.assistant,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      suggestedReplies: [
        'Tell me about Solar Technician courses',
        'Which scholarships can I get for Class 12?',
        'How to apply for Polytechnic Diploma?',
      ],
    ),
  ];

  Future<void> _simulateDelay() async {
    final int delayMs = 300 + _random.nextInt(1201);
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Future<List<ChatMessage>> getConversationHistory() async {
    await _simulateDelay();
    return List.unmodifiable(_messages);
  }

  @override
  Future<ChatMessage> sendMessage(String text, {String languageCode = 'en'}) async {
    await _simulateDelay();

    final userMsg = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    final String botResponseText;
    final List<String> suggestions;

    final lower = text.toLowerCase();
    if (lower.contains('solar') || lower.contains('सौर')) {
      botResponseText = languageCode == 'hi'
          ? 'सूर्य मित्र योजना के तहत 600 घंटे का निःशुल्क सोलर ट्रेनिंग कार्यक्रम उपलब्ध है। इसमें रहने और भोजन की सुविधा भी मिलती है। क्या आप पात्रता विवरण देखना चाहते हैं?'
          : 'Under the Surya Mitra initiative, you can take a 600-hour residential solar PV technician program with 100% tuition and hostel waiver. Would you like to view admission requirements?';
      suggestions = ['View Surya Mitra eligibility', 'Show nearby training centers'];
    } else if (lower.contains('scholarship') || lower.contains('छात्रवृत्ति')) {
      botResponseText = languageCode == 'hi'
          ? 'आपकी पारिवारिक आय और ओबीसी श्रेणी के आधार पर आप पोस्ट-मैट्रिक छात्रवृत्ति योजना और प्रगति छात्रवृत्ति योजना (बालिकाओं के लिए ₹50,000/वर्ष) के लिए पात्र हैं।'
          : 'Based on your OBC category and family income under ₹1.5L, you qualify for Post-Matric Scholarship Scheme and the Pragati Scheme (₹50,000/yr for girls). Shall I guide you to apply on NSP portal?';
      suggestions = ['Show Post-Matric Scholarship', 'Documents required for NSP'];
    } else {
      botResponseText = languageCode == 'hi'
          ? 'शानदार सवाल! एक ग्रामीण छात्र के रूप में आपके लिए पॉलिटेक्निक डिप्लोमा और कृषि तकनीक के कई सरकारी मार्ग उपलब्ध हैं।'
          : 'That is a great direction to explore. With your Science and Mathematics background, you have strong government pathways in rural technical colleges and skill centers.';
      suggestions = ['Check Polytechnic exams', 'Free vocational certificates'];
    }

    final botMsg = ChatMessage(
      id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
      text: botResponseText,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      suggestedReplies: suggestions,
    );
    _messages.add(botMsg);

    return botMsg;
  }
}
