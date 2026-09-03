import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { User, Phone, MapPin } from 'lucide-react';

export default function Step1BasicInfo({ formData, updateFormData }) {
  const { t } = useLanguage();

  return (
    <div className="space-y-4">
      <div>
        <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
          {t('wizard.full_name')} *
        </label>
        <div className="relative">
          <User className="w-4 h-4 text-neutral-400 absolute left-3.5 top-3" />
          <input
            type="text"
            required
            autoFocus
            value={formData.full_name}
            onChange={(e) => updateFormData({ full_name: e.target.value })}
            placeholder={t('wizard.full_name_placeholder')}
            className="w-full pl-10 pr-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
          />
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
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
            className="w-full px-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
          />
        </div>

        <div>
          <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
            {t('wizard.village')} *
          </label>
          <div className="relative">
            <MapPin className="w-4 h-4 text-neutral-400 absolute left-3.5 top-3" />
            <input
              type="text"
              required
              value={formData.village_location}
              onChange={(e) => updateFormData({ village_location: e.target.value })}
              placeholder="e.g. Shindewadi / Dhebewadi"
              className="w-full pl-10 pr-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
            />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
            {t('wizard.guardian_phone')} *
          </label>
          <div className="relative">
            <Phone className="w-4 h-4 text-neutral-400 absolute left-3.5 top-3" />
            <input
              type="tel"
              required
              value={formData.guardian_contact_number || ''}
              onChange={(e) => updateFormData({ guardian_contact_number: e.target.value })}
              placeholder="Parent / Guardian 10-digit mobile"
              className="w-full pl-10 pr-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
            />
          </div>
          <p className="text-[11px] text-neutral-500 mt-1">{t('wizard.guardian_phone_hint')}</p>
        </div>

        <div>
          <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
            {t('wizard.student_phone')}
          </label>
          <div className="relative">
            <Phone className="w-4 h-4 text-neutral-400 absolute left-3.5 top-3" />
            <input
              type="tel"
              value={formData.student_contact_number || ''}
              onChange={(e) => updateFormData({ student_contact_number: e.target.value })}
              placeholder="Student's own phone (if available)"
              className="w-full pl-10 pr-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
