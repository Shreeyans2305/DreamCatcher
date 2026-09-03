import React, { useState, useEffect, useRef } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { dummyAiEngine } from '../../services/dummyAiEngine';
import GuidanceMessage from './GuidanceMessage';
import SuggestionChipBar from './SuggestionChipBar';
import CaseSummaryModal from './CaseSummaryModal';
import { 
  Sparkles, 
  Send, 
  CheckCircle2, 
  ArrowLeft 
} from 'lucide-react';

export default function CounselingStudio({ student, onBackToDirectory, onNewStudentIntake }) {
  const { t } = useLanguage();
  const { addCaseNoteToStudent } = useCampOperations();

  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const [chips, setChips] = useState([]);
  const [summaryModalNote, setSummaryModalNote] = useState(null);

  const messagesEndRef = useRef(null);

  // Initialize session greeting & chips
  useEffect(() => {
    if (student) {
      const greeting = dummyAiEngine.generateInitialGreeting(student);
      const initialChips = dummyAiEngine.getSuggestedChips(student);
      setChips(initialChips);

      setMessages([
        {
          id: `msg-${Date.now()}`,
          sender: 'ai',
          text: greeting,
          timestamp: new Date().toISOString()
        }
      ]);
    }
  }, [student]);

  // Auto scroll to bottom
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  if (!student) {
    return (
      <div className="max-w-4xl mx-auto py-12 px-4 text-center">
        <div className="card-soft p-8 max-w-md mx-auto bg-white space-y-4">
          <div className="w-12 h-12 rounded-[16px] bg-amber-50 text-amber-600 flex items-center justify-center mx-auto">
            <Sparkles className="w-6 h-6" />
          </div>
          <h2 className="text-lg font-black text-neutral-900 tracking-tight">No Active Student Selected</h2>
          <p className="text-xs text-neutral-500 font-normal leading-relaxed">
            Select a student from the Student Registry or complete a new Quick-Intake to launch the AI Counselor.
          </p>
          <button
            onClick={onNewStudentIntake}
            className="btn-pill-black w-full py-2.5 text-xs font-semibold"
          >
            Start Student Intake
          </button>
        </div>
      </div>
    );
  }

  const handleSendMessage = async (userText) => {
    const textToSend = userText || inputText;
    if (!textToSend.trim()) return;

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
      const aiResponse = await dummyAiEngine.generateGuidanceResponse(textToSend, student, messages);
      const aiMsg = {
        id: `msg-${Date.now() + 1}`,
        sender: 'ai',
        text: aiResponse.text,
        metadata: {
          pathway: aiResponse.pathway,
          schemes: aiResponse.schemes,
          nextStep: aiResponse.nextStep
        },
        timestamp: new Date().toISOString()
      };
      setMessages(prev => [...prev, aiMsg]);
    } catch (e) {
      console.error(e);
    } finally {
      setIsTyping(false);
    }
  };

  const handleConcludeSession = () => {
    const generatedCaseNote = dummyAiEngine.synthesizeCaseNote(student, messages);
    setSummaryModalNote(generatedCaseNote);
  };

  const handleSaveCaseNote = (finalNote) => {
    addCaseNoteToStudent(student.student_record_id, finalNote);
    setSummaryModalNote(null);
  };

  return (
    <div className="max-w-5xl mx-auto py-6 px-4 sm:px-6 space-y-4">
      
      {/* Top Student Context Bar */}
      <div className="card-soft p-4 sm:p-5 bg-white">
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
                <span className="font-bold text-base text-neutral-900">{student.full_name}</span>
                <span className="bg-neutral-100 text-neutral-800 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase border border-black/[0.04]">
                  {student.preferred_language.toUpperCase()} Guidance
                </span>
              </div>
              <div className="flex flex-wrap items-center gap-x-2 gap-y-1 text-xs text-neutral-500 mt-0.5 font-normal">
                <span>Age: {student.age_years} Yrs</span>
                <span>•</span>
                <span>{student.education_level_label}</span>
                <span>•</span>
                <span>{student.category_label}</span>
                <span>•</span>
                <span>{student.village_location}</span>
              </div>
            </div>
          </div>

          <button
            onClick={handleConcludeSession}
            className="btn-pill-black self-start md:self-auto px-4 py-2 text-xs font-semibold gap-1.5 shadow-sm"
          >
            <CheckCircle2 className="w-3.5 h-3.5 text-white" />
            <span>{t('guidance.conclude_session')}</span>
          </button>

        </div>
      </div>

      {/* Main Guidance Studio Card */}
      <div className="card-soft bg-white overflow-hidden flex flex-col h-[680px]">
        
        {/* Messages Feed */}
        <div className="flex-1 overflow-y-auto p-4 sm:p-6 space-y-4 bg-[#F7F6F4]/40">
          {messages.map((msg) => (
            <GuidanceMessage key={msg.id} message={msg} student={student} />
          ))}

          {/* Typing Indicator */}
          {isTyping && (
            <div className="flex items-center gap-2 text-xs text-neutral-500 font-medium pl-11">
              <Sparkles className="w-3.5 h-3.5 text-black animate-spin" />
              <span>AI Counselor is analyzing pathways and scholarships...</span>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* Suggestion Chips */}
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
          className="bg-white p-3 sm:p-4 border-t border-black/[0.05] flex items-center gap-2"
        >
          <div className="relative flex-1 flex items-center bg-[#F7F6F4] rounded-full p-1 border border-black/[0.06] focus-within:ring-2 focus-within:ring-black">
            <input
              type="text"
              value={inputText}
              disabled={isTyping}
              onChange={(e) => setInputText(e.target.value)}
              placeholder={t('guidance.input_placeholder')}
              className="flex-1 bg-transparent px-4 py-2 text-sm text-neutral-900 placeholder:text-neutral-400 focus:outline-none font-medium"
            />
          </div>

          <button
            type="submit"
            disabled={!inputText.trim() || isTyping}
            className="btn-pill-black px-5 py-3 text-xs font-semibold gap-1.5 disabled:opacity-40 shrink-0"
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
          student={student}
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
