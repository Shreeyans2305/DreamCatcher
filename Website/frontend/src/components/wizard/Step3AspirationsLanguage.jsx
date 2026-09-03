import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Globe, Sparkles } from 'lucide-react';

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
    <div className="space-y-6">
      
      {/* Student Preferred AI Guidance Language */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1 flex items-center gap-1.5">
          <Globe className="w-4 h-4 text-neutral-900" />
          <span>{t('wizard.guidance_language')} *</span>
        </label>
        <p className="text-[11px] text-neutral-500 mb-2.5 font-normal">{t('wizard.guidance_language_hint')}</p>
        
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
          {languageOptions.map((lang) => {
            const isSelected = formData.preferred_language === lang.code;
            return (
              <button
                key={lang.code}
                type="button"
                onClick={() => updateFormData({ preferred_language: lang.code })}
                className={`p-3 rounded-[14px] text-center transition-all cursor-pointer ${
                  isSelected
                    ? 'bg-[#111111] text-white shadow-xs font-bold'
                    : 'bg-white text-neutral-700 border border-black/[0.06] hover:bg-neutral-50 font-medium'
                }`}
              >
                <div className="text-sm">{lang.nativeLabel}</div>
                <div className={`text-[10px] uppercase ${isSelected ? 'text-neutral-300' : 'text-neutral-400'}`}>
                  {lang.label}
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Primary Aspirations / Career Interests */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1 flex items-center gap-1.5">
          <Sparkles className="w-4 h-4 text-amber-500" />
          <span>{t('wizard.aspirations')} *</span>
        </label>
        <textarea
          required
          rows={3}
          value={formData.aspirations}
          onChange={(e) => updateFormData({ aspirations: e.target.value })}
          placeholder={t('wizard.aspirations_placeholder')}
          className="w-full px-4 py-3 text-sm border border-neutral-200 rounded-[14px] focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
        />

        {/* Quick Suggestion Pills */}
        <div className="mt-2.5 flex flex-wrap gap-1.5">
          {careerQuickPills.map((pill) => (
            <button
              key={pill}
              type="button"
              onClick={() => handlePillClick(pill)}
              className="text-[11px] bg-neutral-100 hover:bg-neutral-200 text-neutral-700 px-3 py-1 rounded-full border border-black/[0.04] font-medium transition-colors cursor-pointer"
            >
              + {pill}
            </button>
          ))}
        </div>
      </div>

      {/* Consent Checkbox */}
      <div className="pt-2 border-t border-black/[0.04]">
        <label className="flex items-start gap-2.5 cursor-pointer">
          <input
            type="checkbox"
            checked={formData.consent}
            onChange={(e) => updateFormData({ consent: e.target.checked })}
            className="mt-1 h-4 w-4 rounded border-neutral-300 text-black focus:ring-black"
          />
          <span className="text-xs text-neutral-600 font-medium">
            {t('wizard.consent')}
          </span>
        </label>
      </div>

    </div>
  );
}
