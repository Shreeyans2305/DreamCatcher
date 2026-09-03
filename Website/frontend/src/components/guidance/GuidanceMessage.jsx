import React, { useState } from 'react';
import { Volume2, VolumeX, Sparkles, User, Award, ArrowRight } from 'lucide-react';

export default function GuidanceMessage({ message, student }) {
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const isAi = message.sender === 'ai';

  const handleAudioPlayback = () => {
    if ('speechSynthesis' in window) {
      if (isPlayingAudio) {
        window.speechSynthesis.cancel();
        setIsPlayingAudio(false);
      } else {
        const cleanText = message.text.replace(/[*#]/g, '');
        const utterance = new SpeechSynthesisUtterance(cleanText);
        const langCode = student?.preferred_language || 'mr';
        if (langCode === 'hi') utterance.lang = 'hi-IN';
        else if (langCode === 'mr') utterance.lang = 'mr-IN';
        else if (langCode === 'gu') utterance.lang = 'gu-IN';
        else utterance.lang = 'en-IN';

        utterance.onend = () => setIsPlayingAudio(false);
        utterance.onerror = () => setIsPlayingAudio(false);

        setIsPlayingAudio(true);
        window.speechSynthesis.speak(utterance);
      }
    } else {
      alert('Text-to-speech audio simulation not supported on this browser.');
    }
  };

  return (
    <div className={`flex gap-3 ${isAi ? 'justify-start' : 'justify-end'}`}>
      
      {/* AI Avatar */}
      {isAi && (
        <div className="w-8 h-8 rounded-[12px] bg-[#111111] text-white flex items-center justify-center shrink-0 mt-1 shadow-xs">
          <Sparkles className="w-4 h-4 text-white" />
        </div>
      )}

      {/* Message Bubble */}
      <div className={`max-w-2xl rounded-[18px] p-4 sm:p-5 shadow-xs transition-all ${
        isAi 
          ? 'bg-white border border-black/[0.04] text-neutral-900' 
          : 'bg-[#111111] text-white rounded-tr-sm shadow-sm'
      }`}>
        
        {/* Content with Markdown-style bold rendering */}
        <div className="text-sm whitespace-pre-wrap leading-relaxed">
          {message.text.split('\n').map((paragraph, i) => {
            if (paragraph.startsWith('**') && paragraph.endsWith('**')) {
              return (
                <div key={i} className="font-bold text-base mb-2">
                  {paragraph.replace(/\*\*/g, '')}
                </div>
              );
            }
            return <p key={i} className="mb-2 last:mb-0">{paragraph}</p>;
          })}
        </div>

        {/* AI Pathway & Scheme Highlights */}
        {isAi && message.metadata && (
          <div className="mt-3 pt-3 border-t border-black/[0.05] space-y-2">
            
            {message.metadata.pathway && (
              <div className="flex items-center gap-2 text-xs font-bold text-neutral-900 bg-[#F7F6F4] px-3 py-1.5 rounded-full border border-black/[0.04]">
                <Award className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>Recommended Route: {message.metadata.pathway}</span>
              </div>
            )}

            {message.metadata.schemes?.length > 0 && (
              <div className="space-y-1">
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Matched Govt Scholarships:</span>
                <div className="flex flex-wrap gap-1.5">
                  {message.metadata.schemes.map((scheme, idx) => (
                    <div key={idx} className="text-xs text-emerald-800 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200 font-medium flex items-center gap-1">
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 shrink-0" />
                      <span>{scheme}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {message.metadata.nextStep && (
              <div className="text-[11px] text-neutral-700 bg-neutral-100 px-3 py-1.5 rounded-[12px] border border-black/[0.04] flex items-start gap-1.5">
                <ArrowRight className="w-3.5 h-3.5 text-neutral-900 mt-0.5 shrink-0" />
                <span><strong>Action:</strong> {message.metadata.nextStep}</span>
              </div>
            )}

          </div>
        )}

        {/* Footer: Audio Read-aloud & Timestamp */}
        {isAi && (
          <div className="mt-2 pt-2 flex items-center justify-between border-t border-black/[0.04] text-[10px] text-neutral-400">
            <button
              onClick={handleAudioPlayback}
              className={`flex items-center gap-1 font-semibold px-2.5 py-1 rounded-full transition-colors cursor-pointer ${
                isPlayingAudio ? 'bg-amber-100 text-amber-900' : 'hover:bg-neutral-100 text-neutral-700'
              }`}
            >
              {isPlayingAudio ? <VolumeX className="w-3.5 h-3.5 text-amber-700" /> : <Volume2 className="w-3.5 h-3.5 text-neutral-800" />}
              <span>{isPlayingAudio ? 'Stop Audio' : 'Read Aloud (ऑडिओ ऐका)'}</span>
            </button>
            <span>{new Date(message.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
          </div>
        )}

      </div>

      {/* User Avatar */}
      {!isAi && (
        <div className="w-8 h-8 rounded-[12px] bg-neutral-200 text-neutral-800 flex items-center justify-center shrink-0 mt-1 shadow-xs font-bold text-xs">
          <User className="w-4 h-4" />
        </div>
      )}

    </div>
  );
}
