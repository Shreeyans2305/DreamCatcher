import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Lightbulb, ChevronRight } from 'lucide-react';

export default function SuggestionChipBar({ chips, onSelectChip, disabled }) {
  const { t } = useLanguage();

  if (!chips || chips.length === 0) return null;

  return (
    <div className="bg-[#F7F6F4]/80 border-t border-black/[0.05] p-3 sm:p-4">
      <div className="flex items-center gap-1.5 text-xs font-semibold text-neutral-600 mb-2">
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
            className="bg-white hover:bg-neutral-100 text-neutral-800 text-xs font-semibold px-3.5 py-1.5 rounded-full border border-black/[0.06] shadow-xs transition-all flex items-center gap-1.5 disabled:opacity-50 cursor-pointer"
          >
            <span>{chip}</span>
            <ChevronRight className="w-3 h-3 text-neutral-400 shrink-0" />
          </button>
        ))}
      </div>
    </div>
  );
}
