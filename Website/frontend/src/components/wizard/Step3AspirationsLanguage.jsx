import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Globe, Sparkles, CheckSquare } from 'lucide-react';

export default function Step3AspirationsLanguage({ formData, updateFormData }) {
  const { t, languageOptions } = useLanguage();

  const careerQuickPills = [
    'Govt Job / MPSC',
    'Police / Defense',
    'ITI Electrician / Wireman',
    'Diploma Computer / IT',
    'GNM / ANM Nursing',
    'Agriculture / Dairy Farm',
    'Solar / Green Energy Tech',
    'Banking / Accounting'
  ];

  const handlePillClick = (pill) => {
    const current = formData.aspirations || '';
    if (!current) {
      updateFormData({ aspirations: pill });
    } else if (!current.includes(pill)) {
      updateFormData({ aspirations: `${current}, ${pill}` });
    }
  };

  return (
    <div className="space-y-5">
      
      {/* Student Preferred AI Guidance Language */}
      <div>
        <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic flex items-center gap-1.5">
          <Globe className="w-4 h-4 text-[#173F6B]" />
          <span>{t('wizard.guidance_language')} *</span>
        </label>
        <p className="text-[11px] text-slate-500 mb-2 font-indic">{t('wizard.guidance_language_hint')}</p>
        
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
          {languageOptions.map((lang) => {
            const isSelected = formData.preferred_language === lang.code;
            return (
              <button
                key={lang.code}
                type="button"
                onClick={() => updateFormData({ preferred_language: lang.code })}
                className={`p-3 rounded-lg border text-center transition-all font-indic touch-target ${
                  isSelected
                    ? 'bg-[#173F6B] text-white border-[#173F6B] shadow-sm font-bold'
                    : 'bg-white text-slate-700 border-slate-200 hover:border-slate-300 hover:bg-slate-50 font-medium'
                }`}
              >
                <div className="text-sm">{lang.nativeLabel}</div>
                <div className={`text-[10px] uppercase ${isSelected ? 'text-sky-200' : 'text-slate-400'}`}>
                  {lang.label}
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Primary Aspirations / Career Interests */}
      <div>
        <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic flex items-center gap-1.5">
          <Sparkles className="w-4 h-4 text-amber-600" />
          <span>{t('wizard.aspirations')} *</span>
        </label>
        <textarea
          required
          rows={3}
          value={formData.aspirations}
          onChange={(e) => updateFormData({ aspirations: e.target.value })}
          placeholder={t('wizard.aspirations_placeholder')}
          className="w-full px-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
        />

        {/* Quick Suggestion Pills */}
        <div className="mt-2 flex flex-wrap gap-1.5">
          {careerQuickPills.map((pill) => (
            <button
              key={pill}
              type="button"
              onClick={() => handlePillClick(pill)}
              className="text-[11px] bg-slate-100 hover:bg-slate-200 text-slate-700 px-2.5 py-1 rounded-md border border-slate-200 font-medium transition-colors"
            >
              + {pill}
            </button>
          ))}
        </div>
      </div>

      {/* Consent Checkbox */}
      <div className="pt-2 border-t border-slate-100">
        <label className="flex items-start gap-2.5 cursor-pointer">
          <input
            type="checkbox"
            checked={formData.consent}
            onChange={(e) => updateFormData({ consent: e.target.checked })}
            className="mt-1 h-4 w-4 rounded border-slate-300 text-[#173F6B] focus:ring-[#173F6B]"
          />
          <span className="text-xs text-slate-700 font-medium font-indic">
            {t('wizard.consent')}
          </span>
        </label>
      </div>

    </div>
  );
}
