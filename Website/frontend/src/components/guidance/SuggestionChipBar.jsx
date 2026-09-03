import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Lightbulb, ChevronRight } from 'lucide-react';

export default function SuggestionChipBar({ chips, onSelectChip, disabled }) {
  const { t } = useLanguage();

  if (!chips || chips.length === 0) return null;

  return (
    <div className="bg-slate-50 border-t border-slate-200 p-3 sm:p-4">
      <div className="flex items-center gap-1.5 text-xs font-bold text-slate-700 mb-2 font-indic">
        <Lightbulb className="w-3.5 h-3.5 text-amber-500" />
        <span>{t('guidance.chips_title')}:</span>
      </div>
      
      <div className="flex flex-wrap gap-2">
        {chips.map((chip, idx) => (
          <button
            key={idx}
            type="button"
            disabled={disabled}
            onClick={() => onSelectChip(chip)}
            className="text-left bg-white hover:bg-sky-50 text-slate-800 hover:text-[#173F6B] text-xs font-semibold px-3 py-2 rounded-lg border border-slate-200 hover:border-sky-300 shadow-xs transition-all flex items-center gap-2 font-indic disabled:opacity-50 touch-target"
          >
            <span>{chip}</span>
            <ChevronRight className="w-3 h-3 text-slate-400 shrink-0" />
          </button>
        ))}
      </div>
    </div>
  );
}
