import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { GraduationCap, Award } from 'lucide-react';

export default function Step2AcademicCategory({ formData, updateFormData }) {
  const { t } = useLanguage();

  const educationOptions = [
    { value: 'grade_8_9', label: t('wizard.grade_8_9') },
    { value: 'grade_10', label: t('wizard.grade_10') },
    { value: 'grade_11_12_sci', label: t('wizard.grade_11_12_sci') },
    { value: 'grade_11_12_arts', label: t('wizard.grade_11_12_arts') },
    { value: 'grade_11_12_comm', label: t('wizard.grade_11_12_comm') },
    { value: 'grade_iti', label: t('wizard.grade_iti') },
    { value: 'grade_dropout', label: t('wizard.grade_dropout') }
  ];

  const categoryOptions = [
    { value: 'cat_sc', label: t('wizard.cat_sc') },
    { value: 'cat_st', label: t('wizard.cat_st') },
    { value: 'cat_obc', label: t('wizard.cat_obc') },
    { value: 'cat_ews', label: t('wizard.cat_ews') },
    { value: 'cat_general', label: t('wizard.cat_general') }
  ];

  const handleEduSelect = (option) => {
    updateFormData({
      education_level: option.value,
      education_level_label: option.label
    });
  };

  const handleCatSelect = (option) => {
    updateFormData({
      category: option.value,
      category_label: option.label
    });
  };

  return (
    <div className="space-y-6">
      
      {/* Education Level Selection */}
      <div>
        <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-2 flex items-center gap-1.5">
          <GraduationCap className="w-4 h-4 text-neutral-900" />
          <span>{t('wizard.class_grade')} *</span>
        </label>
        
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
          {educationOptions.map((opt) => {
            const isSelected = formData.education_level === opt.value;
            return (
              <button
                key={opt.value}
                type="button"
                onClick={() => handleEduSelect(opt)}
                className={`text-left p-3 rounded-[14px] text-xs font-semibold transition-all touch-target cursor-pointer ${
                  isSelected
                    ? 'bg-[#111111] text-white shadow-xs'
                    : 'bg-white text-neutral-700 border border-black/[0.06] hover:bg-neutral-50'
                }`}
              >
                {opt.label}
              </button>
            );
          })}
        </div>
      </div>

      {/* Caste / Category Selection */}
      <div>
        <div className="flex items-center justify-between mb-1">
          <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider flex items-center gap-1.5">
            <Award className="w-4 h-4 text-neutral-900" />
            <span>{t('wizard.category')} *</span>
          </label>
        </div>
        <p className="text-[11px] text-neutral-500 mb-2.5 font-normal">{t('wizard.category_hint')}</p>
        
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
          {categoryOptions.map((cat) => {
            const isSelected = formData.category === cat.value;
            return (
              <button
                key={cat.value}
                type="button"
                onClick={() => handleCatSelect(cat)}
                className={`text-left p-3 rounded-[14px] text-xs font-semibold transition-all touch-target cursor-pointer ${
                  isSelected
                    ? 'bg-[#111111] text-white shadow-xs'
                    : 'bg-white text-neutral-700 border border-black/[0.06] hover:bg-neutral-50'
                }`}
              >
                {cat.label}
              </button>
            );
          })}
        </div>
      </div>

    </div>
  );
}
