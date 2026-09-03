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
  User, 
  MapPin, 
  GraduationCap, 
  Award, 
  Globe, 
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
        <div className="bg-white rounded-xl p-8 border border-slate-200 shadow-xs max-w-md mx-auto">
          <Sparkles className="w-10 h-10 text-amber-500 mx-auto mb-3" />
          <h2 className="text-lg font-bold text-slate-900 font-indic mb-2">No Active Student Selected</h2>
          <p className="text-xs text-slate-600 font-indic mb-5">
            Select a student from the Student Registry or complete a new Quick-Intake to launch the AI Counselor.
          </p>
          <button
            onClick={onNewStudentIntake}
            className="w-full py-2.5 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-lg transition-colors font-indic"
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
    <div className="max-w-5xl mx-auto py-4 px-4 sm:px-6">
      
      {/* Top Student Context Bar */}
      <div className="bg-[#173F6B] text-white rounded-xl p-4 mb-4 shadow-sm border border-[#0D2E50]">
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
          
          <div className="flex items-center gap-3">
            <button
              onClick={onBackToDirectory}
              className="p-1.5 hover:bg-[#0D2E50] rounded-lg text-sky-200 transition-colors"
              title="Back to Directory"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-bold text-base font-indic">{student.full_name}</span>
                <span className="bg-amber-400 text-slate-950 text-[10px] font-bold px-2 py-0.5 rounded uppercase">
                  {student.preferred_language.toUpperCase()} Guidance
                </span>
              </div>
              <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-xs text-sky-100 mt-0.5 font-indic">
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
            className="self-start md:self-auto bg-amber-500 hover:bg-amber-600 text-slate-950 px-4 py-2 rounded-lg text-xs font-bold shadow flex items-center gap-1.5 transition-colors font-indic touch-target"
          >
            <CheckCircle2 className="w-4 h-4 text-slate-950" />
            <span>{t('guidance.conclude_session')}</span>
          </button>

        </div>
      </div>

      {/* Main Guidance Studio Card */}
      <div className="bg-white rounded-2xl shadow-md border border-slate-200 overflow-hidden flex flex-col h-[680px]">
        
        {/* Messages Feed */}
        <div className="flex-1 overflow-y-auto p-4 sm:p-6 space-y-4 bg-slate-50/50">
          {messages.map((msg) => (
            <GuidanceMessage key={msg.id} message={msg} student={student} />
          ))}

          {/* Typing Indicator */}
          {isTyping && (
            <div className="flex items-center gap-2 text-xs text-slate-500 font-medium pl-11">
              <Sparkles className="w-3.5 h-3.5 text-amber-500 animate-spin" />
              <span className="font-indic">AI Counselor is analyzing pathways and scholarships...</span>
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

        {/* Chat Input Bar */}
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSendMessage();
          }}
          className="bg-white p-3 sm:p-4 border-t border-slate-200 flex items-center gap-2"
        >
          <input
            type="text"
            value={inputText}
            disabled={isTyping}
            onChange={(e) => setInputText(e.target.value)}
            placeholder={t('guidance.input_placeholder')}
            className="flex-1 px-4 py-3 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] focus:border-transparent font-medium font-indic"
          />

          <button
            type="submit"
            disabled={!inputText.trim() || isTyping}
            className="px-5 py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white font-bold rounded-xl shadow flex items-center justify-center gap-1.5 transition-colors disabled:opacity-40 touch-target font-indic"
          >
            <Send className="w-4 h-4 text-amber-400" />
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
