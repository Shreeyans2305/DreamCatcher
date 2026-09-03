import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { User, Phone, MapPin, Calendar } from 'lucide-react';

export default function Step1BasicInfo({ formData, updateFormData }) {
  const { t } = useLanguage();

  return (
    <div className="space-y-4">
      <div>
        <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
          {t('wizard.full_name')} *
        </label>
        <div className="relative">
          <User className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
          <input
            type="text"
            required
            autoFocus
            value={formData.full_name}
            onChange={(e) => updateFormData({ full_name: e.target.value })}
            placeholder={t('wizard.full_name_placeholder')}
            className="w-full pl-9 pr-3 py-3 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
            {t('wizard.age')} *
          </label>
          <input
            type="number"
            required
            min="10"
            max="30"
            value={formData.age_years}
            onChange={(e) => updateFormData({ age_years: e.target.value })}
            placeholder="15"
            className="w-full px-3 py-3 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
            {t('wizard.village')} *
          </label>
          <div className="relative">
            <MapPin className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
            <input
              type="text"
              required
              value={formData.village_location}
              onChange={(e) => updateFormData({ village_location: e.target.value })}
              placeholder="e.g. Shindewadi / Dhebewadi"
              className="w-full pl-9 pr-3 py-3 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
            />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
            {t('wizard.guardian_phone')} *
          </label>
          <div className="relative">
            <Phone className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
            <input
              type="tel"
              required
              value={formData.guardian_contact_number}
              onChange={(e) => updateFormData({ guardian_contact_number: e.target.value })}
              placeholder="Parent / Guardian 10-digit mobile"
              className="w-full pl-9 pr-3 py-3 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
            />
          </div>
          <p className="text-[11px] text-slate-500 mt-1 font-indic">{t('wizard.guardian_phone_hint')}</p>
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
            {t('wizard.student_phone')}
          </label>
          <div className="relative">
            <Phone className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
            <input
              type="tel"
              value={formData.student_contact_number}
              onChange={(e) => updateFormData({ student_contact_number: e.target.value })}
              placeholder="Student's own phone (if available)"
              className="w-full pl-9 pr-3 py-3 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
