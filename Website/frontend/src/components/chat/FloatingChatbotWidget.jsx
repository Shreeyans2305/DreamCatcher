import React, { useState, useRef, useEffect } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { aiAssistantService } from '../../services/aiAssistantService';
import GuidanceMessage from '../guidance/GuidanceMessage';
import { 
  Sparkles, 
  MessageCircle, 
  X, 
  Send, 
  Mic, 
  Languages, 
  Maximize2, 
  Minimize2,
  Bot
} from 'lucide-react';

export default function FloatingChatbotWidget() {
  const { currentLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [activeLanguage, setActiveLanguage] = useState(currentLanguage || 'mr');

  const messagesEndRef = useRef(null);

  // Initialize greeting on first open
  useEffect(() => {
    if (isOpen && messages.length === 0) {
      const initial = aiAssistantService.getInitialGreeting(
        { full_name: 'Visitor / Officer', aspirations: 'Police, Scholarships & Vocational Trades' },
        activeLanguage
      );

      setMessages([
        {
          id: `widget-init-${Date.now()}`,
          sender: 'ai',
          text: initial.reply,
          opportunities: initial.referenced_opportunities || [],
          suggested_actions: initial.suggested_actions || [],
          timestamp: new Date().toISOString()
        }
      ]);
    }
  }, [isOpen, activeLanguage]);

  useEffect(() => {
    if (isOpen) {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages, isTyping, isOpen]);

  const handleSendMessage = async (userText) => {
    const textToSend = userText || inputText;
    if (!textToSend.trim()) return;

    const userMsg = {
      id: `widget-user-${Date.now()}`,
      sender: 'user',
      text: textToSend,
      timestamp: new Date().toISOString()
    };

    setMessages(prev => [...prev, userMsg]);
    setInputText('');
    setIsTyping(true);

    try {
      const aiResponse = await aiAssistantService.sendMessage({
        student: { full_name: 'Visitor / Student', aspirations: textToSend },
        message: textToSend,
        language: activeLanguage
      });

      const aiMsg = {
        id: `widget-ai-${Date.now() + 1}`,
        sender: 'ai',
        text: aiResponse.reply,
        opportunities: aiResponse.referenced_opportunities || [],
        suggested_actions: aiResponse.suggested_actions || [],
        timestamp: new Date().toISOString()
      };

      setMessages(prev => [...prev, aiMsg]);
    } catch (err) {
      console.error('Widget error:', err);
    } finally {
      setIsTyping(false);
    }
  };

  const handleVoiceHint = () => {
    const prompts = {
      mr: 'पोलीस भरतीसाठी शारीरिक चाचणीचे निकष काय आहेत?',
      hi: 'पुलिस कांस्टेबल भर्ती के लिए शारीरिक मापदंड क्या हैं?',
      gu: 'પોલીસ ભરતી માટે શારીરિક કસોટીના નિયમો શું છે?',
      en: 'What scholarships are available after 10th class in Maharashtra?'
    };
    handleSendMessage(prompts[activeLanguage] || prompts.mr);
  };

  return (
    <div className="fixed bottom-5 right-5 z-50">
      
      {/* Floating Launcher Button */}
      {!isOpen && (
        <button
          type="button"
          onClick={() => setIsOpen(true)}
          className="bg-[#222222] hover:bg-[#111111] text-white p-3.5 sm:px-5 sm:py-3.5 rounded-full shadow-xl flex items-center gap-2.5 cursor-pointer hover:scale-105 active:scale-95 transition-all border border-amber-400/30 group"
          title="Open AI Guidance Counselor"
        >
          <div className="relative">
            <Bot className="w-5 h-5 text-amber-300 group-hover:rotate-12 transition-transform" />
            <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-emerald-500 rounded-full animate-ping" />
            <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-emerald-500 rounded-full" />
          </div>
          <span className="font-extrabold text-xs tracking-tight hidden sm:inline">
            Ask AI Counselor ✨
          </span>
        </button>
      )}

      {/* Floating Chat Modal (Mobile App Layout Parity) */}
      {isOpen && (
        <div 
          className={`bg-white border border-[#DECBC7] rounded-3xl shadow-2xl flex flex-col overflow-hidden transition-all duration-300 animate-in fade-in zoom-in-95 ${
            isExpanded 
              ? 'w-[95vw] sm:w-[650px] h-[85vh] max-h-[800px]' 
              : 'w-[92vw] sm:w-[420px] h-[580px]'
          }`}
        >
          
          {/* Header */}
          <div className="bg-[#222222] text-white px-4 py-3 flex items-center justify-between shrink-0">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-full bg-amber-400/20 border border-amber-400/40 flex items-center justify-center text-amber-300">
                <Sparkles className="w-4 h-4" />
              </div>
              <div>
                <h3 className="text-xs sm:text-sm font-extrabold font-serif-zen tracking-tight leading-tight">
                  DreamCatcher AI Counselor
                </h3>
                <span className="text-[10px] text-emerald-400 flex items-center gap-1 font-medium">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 inline-block" />
                  Vertex AI / RAG Online
                </span>
              </div>
            </div>

            <div className="flex items-center gap-1">
              {/* Language Pills */}
              <div className="flex bg-white/10 rounded-md p-0.5 text-[10px] font-bold">
                {['mr', 'hi', 'en'].map(code => (
                  <button
                    key={code}
                    type="button"
                    onClick={() => setActiveLanguage(code)}
                    className={`px-1.5 py-0.5 rounded cursor-pointer transition-colors ${
                      activeLanguage === code ? 'bg-white text-neutral-900 shadow-2xs' : 'text-white/70 hover:text-white'
                    }`}
                  >
                    {code.toUpperCase()}
                  </button>
                ))}
              </div>

              {/* Expand Toggle */}
              <button
                type="button"
                onClick={() => setIsExpanded(prev => !prev)}
                className="p-1.5 hover:bg-white/10 rounded-lg text-neutral-400 hover:text-white transition-colors cursor-pointer"
                title={isExpanded ? 'Collapse' : 'Expand'}
              >
                {isExpanded ? <Minimize2 className="w-4 h-4" /> : <Maximize2 className="w-4 h-4" />}
              </button>

              {/* Close Button */}
              <button
                type="button"
                onClick={() => setIsOpen(false)}
                className="p-1.5 hover:bg-white/10 rounded-lg text-neutral-400 hover:text-white transition-colors cursor-pointer"
                title="Close"
              >
                <X className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* Messages Stream */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3.5 bg-[#FAF7F2]/50 text-xs">
            {messages.map((msg) => (
              <GuidanceMessage
                key={msg.id}
                message={msg}
                student={{ preferred_language: activeLanguage }}
                onSelectChip={(chip) => handleSendMessage(chip)}
              />
            ))}

            {isTyping && (
              <div className="flex items-center gap-2 text-xs text-[#8C8275] pl-10 animate-pulse">
                <Sparkles className="w-3.5 h-3.5 text-[#A83E28] animate-spin" />
                <span>AI Counselor is typing...</span>
              </div>
            )}

            <div ref={messagesEndRef} />
          </div>

          {/* Input Bar */}
          <form
            onSubmit={(e) => {
              e.preventDefault();
              handleSendMessage();
            }}
            className="p-3 bg-white border-t border-[#DECBC7] flex items-center gap-2 shrink-0"
          >
            <button
              type="button"
              onClick={handleVoiceHint}
              className="p-2 rounded-full bg-[#FAF7F2] hover:bg-neutral-100 border border-[#DECBC7] text-[#A83E28] transition-colors cursor-pointer shrink-0 shadow-2xs"
              title="Voice Prompt Hint"
            >
              <Mic className="w-4 h-4" />
            </button>

            <input
              type="text"
              value={inputText}
              disabled={isTyping}
              onChange={(e) => setInputText(e.target.value)}
              placeholder={activeLanguage === 'mr' ? 'प्रश्न विचारा (उदा. पोलीस भरती)...' : activeLanguage === 'hi' ? 'सवाल पूछें (उदा. पुलिस भर्ती)...' : 'Ask any career or scholarship question...'}
              className="flex-1 bg-[#FAF7F2] border border-[#DECBC7] rounded-full px-3.5 py-2 text-xs text-neutral-900 focus:outline-none focus:ring-2 focus:ring-black"
            />

            <button
              type="submit"
              disabled={!inputText.trim() || isTyping}
              className="p-2 rounded-full bg-[#222222] hover:bg-black text-white disabled:opacity-40 transition-colors cursor-pointer shrink-0 shadow-sm"
            >
              <Send className="w-4 h-4" />
            </button>
          </form>

        </div>
      )}

    </div>
  );
}
