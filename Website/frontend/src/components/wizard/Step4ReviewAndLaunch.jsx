import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { CheckCircle2, Sparkles, MapPin, Phone, GraduationCap, Award, Globe, Save } from 'lucide-react';

export default function Step4ReviewAndLaunch({ formData }) {
  const { t } = useLanguage();
  const { activeCamp } = useCampOperations();

  return (
    <div className="space-y-4">
      
      {/* Verification Notice */}
      <div className="bg-sky-50 border border-sky-200 rounded-lg p-3 text-xs text-sky-900 flex items-start gap-2">
        <CheckCircle2 className="w-4 h-4 text-[#173F6B] shrink-0 mt-0.5" />
        <span className="font-indic">
          Please verify the captured student information before launching the AI counselor session.
        </span>
      </div>

      {/* Summary Review Card */}
      <div className="bg-slate-50 rounded-xl border border-slate-200 p-4 space-y-3 text-xs">
        
        <div className="flex items-center justify-between border-b border-slate-200 pb-2.5">
          <div>
            <span className="text-[10px] uppercase font-bold text-slate-400 block">Student Name</span>
            <span className="text-base font-bold text-slate-900 font-indic">{formData.full_name}</span>
          </div>
          <span className="text-xs bg-amber-100 text-amber-900 font-bold px-2 py-0.5 rounded border border-amber-300 font-indic">
            Age: {formData.age_years} Yrs
          </span>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <span className="text-[10px] uppercase font-bold text-slate-400 block">Village & Camp</span>
            <span className="font-semibold text-slate-800 font-indic flex items-center gap-1 mt-0.5">
              <MapPin className="w-3.5 h-3.5 text-slate-400" />
              {formData.village_location} ({activeCamp?.village_town})
            </span>
          </div>
          <div>
            <span className="text-[10px] uppercase font-bold text-slate-400 block">Guardian Mobile</span>
            <span className="font-semibold text-slate-800 flex items-center gap-1 mt-0.5">
              <Phone className="w-3.5 h-3.5 text-slate-400" />
              {formData.guardian_contact_number}
            </span>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 border-t border-slate-200 pt-2.5">
          <div>
            <span className="text-[10px] uppercase font-bold text-slate-400 block">Education Level</span>
            <span className="font-semibold text-slate-800 font-indic flex items-center gap-1 mt-0.5">
              <GraduationCap className="w-3.5 h-3.5 text-slate-400" />
              {formData.education_level_label}
            </span>
          </div>
          <div>
            <span className="text-[10px] uppercase font-bold text-slate-400 block">Category</span>
            <span className="font-semibold text-slate-800 font-indic flex items-center gap-1 mt-0.5">
              <Award className="w-3.5 h-3.5 text-amber-600" />
              {formData.category_label}
            </span>
          </div>
        </div>

        <div className="border-t border-slate-200 pt-2.5">
          <span className="text-[10px] uppercase font-bold text-slate-400 block">Aspirations & Guidance Language</span>
          <p className="font-medium text-slate-800 font-indic mt-0.5">
            {formData.aspirations}
          </p>
          <span className="inline-block mt-1 bg-sky-100 text-sky-800 text-[10px] font-bold px-2 py-0.5 rounded uppercase">
            AI Session Language: {formData.preferred_language.toUpperCase()}
          </span>
        </div>

      </div>

    </div>
  );
}
