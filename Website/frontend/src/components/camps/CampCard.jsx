import React from 'react';
import { useCampOperations } from '../../context/CampOperationsContext';
import { useLanguage } from '../../context/LanguageContext';
import { MapPin, Calendar, Users, Clock, CheckCircle2, Radio } from 'lucide-react';

export default function CampCard({ camp, onSelectIntake }) {
  const { activeCampId, setActiveCamp } = useCampOperations();
  const { t } = useLanguage();

  const isActive = activeCampId === camp.camp_id;

  const statusConfig = {
    upcoming: { bg: 'bg-sky-50 text-sky-800 border-sky-200', label: t('camps.filter_upcoming') },
    ongoing: { bg: 'bg-emerald-50 text-emerald-800 border-emerald-200', label: t('camps.filter_ongoing') },
    completed: { bg: 'bg-slate-100 text-slate-700 border-slate-200', label: t('camps.filter_completed') }
  };

  const statusInfo = statusConfig[camp.status] || statusConfig.upcoming;

  return (
    <div className={`rounded-xl border transition-all p-5 bg-white ${
      isActive 
        ? 'border-2 border-[#173F6B] shadow-md ring-2 ring-[#173F6B]/10' 
        : 'border-slate-200 hover:border-slate-300 shadow-xs'
    }`}>
      
      {/* Top Meta Bar */}
      <div className="flex items-start justify-between gap-2 mb-3">
        <span className={`text-xs font-bold px-2.5 py-1 rounded-full border ${statusInfo.bg}`}>
          {statusInfo.label}
        </span>
        {isActive && (
          <span className="flex items-center gap-1 text-xs font-bold text-amber-700 bg-amber-50 border border-amber-200 px-2 py-0.5 rounded-md">
            <Radio className="w-3 h-3 text-amber-600 animate-pulse" />
            <span className="font-indic">{t('camps.active_badge')}</span>
          </span>
        )}
      </div>

      {/* Camp Title */}
      <h3 className="font-bold text-base text-slate-900 mb-2 font-indic line-clamp-1">
        {camp.camp_name}
      </h3>

      {/* Location & Schedule Details */}
      <div className="space-y-1.5 text-xs text-slate-600 mb-4 font-medium">
        <div className="flex items-center gap-2">
          <MapPin className="w-4 h-4 text-slate-400 shrink-0" />
          <span className="font-indic">{camp.village_town}, {camp.district}, {camp.state}</span>
        </div>
        <div className="flex items-center gap-2">
          <Calendar className="w-4 h-4 text-slate-400 shrink-0" />
          <span>{camp.scheduled_date} ({camp.start_time} - {camp.end_time})</span>
        </div>
        <div className="flex items-center gap-2">
          <Users className="w-4 h-4 text-slate-400 shrink-0" />
          <span className="font-semibold text-slate-900">{camp.students_enrolled || 0}</span>
          <span className="font-indic">{t('camps.students_count')}</span>
        </div>
      </div>

      {/* Action Footer */}
      <div className="flex items-center gap-2 pt-3 border-t border-slate-100">
        {!isActive ? (
          <button
            onClick={() => setActiveCamp(camp.camp_id)}
            className="flex-1 py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 text-xs font-bold rounded-lg transition-colors font-indic touch-target"
          >
            {t('camps.set_active')}
          </button>
        ) : (
          <button
            onClick={() => onSelectIntake(camp)}
            className="flex-1 py-2 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-lg shadow transition-colors flex items-center justify-center gap-1.5 font-indic touch-target"
          >
            <CheckCircle2 className="w-3.5 h-3.5 text-amber-400" />
            <span>{t('nav.intake')}</span>
          </button>
        )}
      </div>

    </div>
  );
}
