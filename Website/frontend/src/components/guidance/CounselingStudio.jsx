import React, { useState, useEffect, useRef } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { aiAssistantService } from '../../services/aiAssistantService';
import { dummyAiEngine } from '../../services/dummyAiEngine';
import GuidanceMessage from './GuidanceMessage';
import SuggestionChipBar from './SuggestionChipBar';
import CaseSummaryModal from './CaseSummaryModal';
import { 
  Sparkles, 
  Send, 
  CheckCircle2, 
  ArrowLeft,
  Mic,
  Languages,
  UserCheck,
  Compass
} from 'lucide-react';

const DEMO_STUDENT_NEEL = {
  student_record_id: 'stu-demo-neel-10th',
  full_name: 'Neel',
  age_years: 17,
  education_level: 'grade_10',
  education_level_label: 'Class 10th (Secondary)',
  category: 'cat_obc',
  category_label: 'OBC (Other Backward Class)',
  preferred_language: 'mr',
  aspirations: 'Police / Defense',
  village_location: 'Vile Parle (SBMP)',
  guardian_contact_number: '1234567890'
};

export default function CounselingStudio({ student: initialStudent, onBackToDirectory, onNewStudentIntake }) {
  const { t, currentLanguage, changeLanguage } = useLanguage();
  const { addCaseNoteToStudent, selectedStudentForGuidance } = useCampOperations();

  const currentStudentObj = initialStudent || selectedStudentForGuidance || null;
  const [activeStudent, setActiveStudent] = useState(currentStudentObj);
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [chips, setChips] = useState([]);
  const [summaryModalNote, setSummaryModalNote] = useState(null);
  const [activeLanguage, setActiveLanguage] = useState(currentStudentObj?.preferred_language || currentLanguage || 'en');

  const messagesEndRef = useRef(null);

  // Sync if prop or context changes
  useEffect(() => {
    const studentToUse = initialStudent || selectedStudentForGuidance;
    if (studentToUse) {
      setActiveStudent(studentToUse);
      setActiveLanguage(studentToUse.preferred_language || currentLanguage || 'en');
    }
  }, [initialStudent, selectedStudentForGuidance, currentLanguage]);

  // Initialize session greeting & chips
  useEffect(() => {
    const studentToUse = activeStudent || DEMO_STUDENT_NEEL;
    const initial = aiAssistantService.getInitialGreeting(studentToUse, activeLanguage);
    setChips(initial.suggested_actions || []);

    setMessages([
      {
        id: `msg-${Date.now()}`,
        sender: 'ai',
        text: initial.reply,
        opportunities: initial.referenced_opportunities || [],
        suggested_actions: initial.suggested_actions || [],
        timestamp: new Date().toISOString()
      }
    ]);
  }, [activeStudent, activeLanguage]);

  // Auto scroll to bottom
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  const handleSendMessage = async (userText) => {
    const textToSend = userText || inputText;
    if (!textToSend.trim()) return;

    const studentToUse = activeStudent || DEMO_STUDENT_NEEL;

    const userMsg = {
      id: `msg-${Date.now()}`,
      sender: 'user',
      text: textToSend,
      timestamp: new Date().toISOString()
    };

    setMessages(prev => [...prev, userMsg]);
    setInputText('');
    setIsTyping(true);

    try {
      const aiResponse = await aiAssistantService.sendMessage({
        student: studentToUse,
        message: textToSend,
        language: activeLanguage
      });

      const aiMsg = {
        id: `msg-${Date.now() + 1}`,
        sender: 'ai',
        text: aiResponse.reply,
        opportunities: aiResponse.referenced_opportunities || [],
        suggested_actions: aiResponse.suggested_actions || [],
        timestamp: new Date().toISOString()
      };

      setMessages(prev => [...prev, aiMsg]);
      if (aiResponse.suggested_actions && aiResponse.suggested_actions.length > 0) {
        setChips(aiResponse.suggested_actions);
      }
    } catch (e) {
      console.error('AI assistant error:', e);
    } finally {
      setIsTyping(false);
    }
  };

  const handleVoiceHint = () => {
    const prompts = {
      mr: 'पोलीस भरतीसाठी शारीरिक चाचणीचे निकष काय आहेत?',
      hi: 'पुलिस कांस्टेबल भर्ती के लिए शारीरिक मापदंड क्या हैं?',
      gu: 'પોલીસ ભરતી માટે શારીરિક કસોટીના નિયમો શું છે?',
      en: 'What are the eligibility criteria for Police Bharti after 10th?'
    };
    const samplePrompt = prompts[activeLanguage] || prompts.mr;
    handleSendMessage(samplePrompt);
  };

  const handleConcludeSession = () => {
    const studentToUse = activeStudent || DEMO_STUDENT_NEEL;
    const generatedCaseNote = dummyAiEngine.synthesizeCaseNote(studentToUse, messages);
    setSummaryModalNote(generatedCaseNote);
  };

  const handleSaveCaseNote = (finalNote) => {
    if (activeStudent) {
      addCaseNoteToStudent(activeStudent.student_record_id, finalNote);
    }
    setSummaryModalNote(null);
  };

  const currentStudent = activeStudent || DEMO_STUDENT_NEEL;

  return (
    <div className="max-w-5xl mx-auto py-6 px-4 sm:px-6 space-y-4 animate-in fade-in duration-300">
      
      {/* Top Student Context Bar */}
      <div className="card-soft p-4 sm:p-5 bg-white border border-[#DECBC7] shadow-xs">
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
          
          <div className="flex items-center gap-3">
            <button
              onClick={onBackToDirectory}
              className="p-2 hover:bg-neutral-100 rounded-full text-neutral-600 hover:text-black transition-colors cursor-pointer"
              title="Back to Directory"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-extrabold font-serif-zen text-base sm:text-lg text-neutral-900">
                  {currentStudent.full_name}
                </span>
                <span className="bg-[#A83E28]/10 text-[#A83E28] text-[10px] font-bold px-2 py-0.5 rounded-full uppercase border border-[#A83E28]/20">
                  {currentStudent.aspirations}
                </span>
                {!activeStudent && (
                  <span className="bg-amber-100 text-amber-900 text-[10px] font-bold px-2 py-0.5 rounded-full">
                    Demo Mode
                  </span>
                )}
              </div>
              <div className="flex flex-wrap items-center gap-x-2 gap-y-1 text-xs text-[#5C5245] mt-0.5 font-normal">
                <span>Age: {currentStudent.age_years} Yrs</span>
                <span>•</span>
                <span>{currentStudent.education_level_label || currentStudent.education_level}</span>
                <span>•</span>
                <span>{currentStudent.category_label || currentStudent.category}</span>
                <span>•</span>
                <span>{currentStudent.village_location}</span>
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2 self-start md:self-auto flex-wrap">
            {/* Language Switcher */}
            <div className="flex items-center gap-1 bg-[#FAF7F2] border border-[#DECBC7] rounded-lg p-1 text-xs font-bold text-neutral-700">
              <Languages className="w-3.5 h-3.5 text-[#8C8275] ml-1" />
              {['mr', 'hi', 'en', 'gu'].map((code) => (
                <button
                  key={code}
                  type="button"
                  onClick={() => setActiveLanguage(code)}
                  className={`px-2 py-0.5 rounded cursor-pointer transition-colors text-[11px] ${
                    activeLanguage === code
                      ? 'bg-[#222222] text-white shadow-2xs'
                      : 'hover:bg-neutral-200/60 text-neutral-600'
                  }`}
                >
                  {code === 'mr' ? 'मराठी' : code === 'hi' ? 'हिंदी' : code === 'gu' ? 'ગુજ' : 'EN'}
                </button>
              ))}
            </div>

            <button
              onClick={handleConcludeSession}
              className="btn-pill-black px-4 py-2 text-xs font-semibold gap-1.5 shadow-sm"
            >
              <CheckCircle2 className="w-3.5 h-3.5 text-white" />
              <span>{t('guidance.conclude_session')}</span>
            </button>
          </div>

        </div>
      </div>

      {/* Main Guidance Studio Card */}
      <div className="card-soft bg-white border border-[#DECBC7] overflow-hidden flex flex-col h-[680px] shadow-sm">
        
        {/* Messages Feed */}
        <div className="flex-1 overflow-y-auto p-4 sm:p-6 space-y-4 bg-[#FAF7F2]/40">
          {messages.map((msg) => (
            <GuidanceMessage 
              key={msg.id} 
              message={msg} 
              student={currentStudent} 
              onSelectChip={(chip) => handleSendMessage(chip)}
            />
          ))}

          {/* Typing Indicator */}
          {isTyping && (
            <div className="flex items-center gap-2 text-xs text-[#7A6F62] font-medium pl-11 animate-pulse">
              <Sparkles className="w-3.5 h-3.5 text-[#A83E28] animate-spin" />
              <span>AI Counselor is analyzing government recruitment pathways and scholarships...</span>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* Global Suggestion Chips Bar */}
        <SuggestionChipBar
          chips={chips}
          disabled={isTyping}
          onSelectChip={(chip) => handleSendMessage(chip)}
        />

        {/* Search-bar style Input Bar */}
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSendMessage();
          }}
          className="bg-white p-3 sm:p-4 border-t border-[#DECBC7] flex items-center gap-2"
        >
          {/* Voice Input Hint Button */}
          <button
            type="button"
            onClick={handleVoiceHint}
            className="p-2.5 rounded-full bg-[#FAF7F2] hover:bg-neutral-100 border border-[#DECBC7] text-[#A83E28] hover:text-[#222222] transition-colors cursor-pointer shrink-0 shadow-2xs"
            title="Spoken Query / Voice Hint"
          >
            <Mic className="w-4 h-4" />
          </button>

          <div className="relative flex-1 flex items-center bg-[#FAF7F2] rounded-full p-1 border border-[#DECBC7] focus-within:ring-2 focus-within:ring-black">
            <input
              type="text"
              value={inputText}
              disabled={isTyping}
              onChange={(e) => setInputText(e.target.value)}
              placeholder={activeLanguage === 'mr' ? 'पोलीस भरती, शिष्यवृत्ती किंवा करिअरबद्दल प्रश्न विचारा...' : activeLanguage === 'hi' ? 'पुलिस भर्ती, स्कॉलरशिप या करियर के बारे में पूछें...' : 'Ask about recruitment, scholarships, or physical test criteria...'}
              className="flex-1 bg-transparent px-4 py-2 text-sm text-neutral-900 placeholder:text-neutral-400 focus:outline-none font-medium"
            />
          </div>

          <button
            type="submit"
            disabled={!inputText.trim() || isTyping}
            className="btn-pill-black px-5 py-3 text-xs font-semibold gap-1.5 disabled:opacity-40 shrink-0 shadow-sm"
          >
            <Send className="w-3.5 h-3.5 text-white" />
            <span className="hidden sm:inline">{t('guidance.send')}</span>
          </button>
        </form>

      </div>

      {/* Case Summary Modal */}
      {summaryModalNote && (
        <CaseSummaryModal
          caseNote={summaryModalNote}
          student={currentStudent}
          onSave={handleSaveCaseNote}
          onClose={() => setSummaryModalNote(null)}
          onNewStudent={() => {
            setSummaryModalNote(null);
            onNewStudentIntake();
          }}
        />
      )}

    </div>
  );
}
