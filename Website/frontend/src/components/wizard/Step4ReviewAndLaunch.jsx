import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { CheckCircle2, MapPin, Phone, GraduationCap, Award } from 'lucide-react';

export default function Step4ReviewAndLaunch({ formData }) {
  const { t } = useLanguage();
  const { activeCamp } = useCampOperations();

  return (
    <div className="space-y-4">
      
      {/* Verification Notice */}
      <div className="bg-emerald-50 border border-emerald-200 rounded-[14px] p-3.5 text-xs text-emerald-900 flex items-start gap-2.5">
        <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
        <span>
          Please verify the captured student information before launching the AI counselor session.
        </span>
      </div>

      {/* Summary Review Card */}
      <div className="bg-[#F7F6F4]/60 rounded-[16px] border border-black/[0.05] p-4 sm:p-5 space-y-3.5 text-xs">
        
        <div className="flex items-center justify-between border-b border-black/[0.05] pb-3">
          <div>
            <span className="text-[10px] uppercase font-bold text-neutral-400 block">Student Name</span>
            <span className="text-base font-bold text-neutral-900">{formData.full_name}</span>
          </div>
          <span className="text-xs bg-neutral-100 text-neutral-800 font-bold px-2.5 py-1 rounded-full border border-black/[0.04]">
            Age: {formData.age_years} Yrs
          </span>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <span className="text-[10px] uppercase font-bold text-neutral-400 block">Village & Camp</span>
            <span className="font-semibold text-neutral-800 flex items-center gap-1 mt-0.5">
              <MapPin className="w-3.5 h-3.5 text-neutral-400" />
              {formData.village_location} ({activeCamp?.village_town})
            </span>
          </div>
          <div>
            <span className="text-[10px] uppercase font-bold text-neutral-400 block">Guardian Mobile</span>
            <span className="font-semibold text-neutral-800 flex items-center gap-1 mt-0.5">
              <Phone className="w-3.5 h-3.5 text-neutral-400" />
              {formData.guardian_contact_number}
            </span>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 border-t border-black/[0.05] pt-3">
          <div>
            <span className="text-[10px] uppercase font-bold text-neutral-400 block">Education Level</span>
            <span className="font-semibold text-neutral-800 flex items-center gap-1 mt-0.5">
              <GraduationCap className="w-3.5 h-3.5 text-neutral-400" />
              {formData.education_level_label}
            </span>
          </div>
          <div>
            <span className="text-[10px] uppercase font-bold text-neutral-400 block">Category</span>
            <span className="font-semibold text-neutral-800 flex items-center gap-1 mt-0.5">
              <Award className="w-3.5 h-3.5 text-amber-600" />
              {formData.category_label}
            </span>
          </div>
        </div>

        <div className="border-t border-black/[0.05] pt-3">
          <span className="text-[10px] uppercase font-bold text-neutral-400 block">Aspirations & Guidance Language</span>
          <p className="font-medium text-neutral-800 mt-0.5">
            {formData.aspirations}
          </p>
          <span className="inline-block mt-2 bg-neutral-100 text-neutral-800 text-[10px] font-bold px-2.5 py-1 rounded-full uppercase border border-black/[0.04]">
            AI Session Language: {formData.preferred_language.toUpperCase()}
          </span>
        </div>

      </div>

    </div>
  );
}
