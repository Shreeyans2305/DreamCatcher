import React from 'react';
import { useCampOperations } from '../../context/CampOperationsContext';
import { useLanguage } from '../../context/LanguageContext';
import { MapPin, Calendar, Users, CheckCircle2, Radio } from 'lucide-react';

export default function CampCard({ camp, onSelectIntake }) {
  const { activeCampId, setActiveCamp } = useCampOperations();
  const { t } = useLanguage();

  const isActive = activeCampId === camp.camp_id;

  const statusConfig = {
    upcoming: { bg: 'bg-blue-50 text-blue-800 border-blue-200', label: t('camps.filter_upcoming') },
    ongoing: { bg: 'bg-emerald-50 text-emerald-800 border-emerald-200', label: t('camps.filter_ongoing') },
    completed: { bg: 'bg-neutral-100 text-neutral-700 border-black/[0.04]', label: t('camps.filter_completed') }
  };

  const statusInfo = statusConfig[camp.status] || statusConfig.upcoming;

  return (
    <div className={`card-soft p-5 bg-white flex flex-col justify-between ${
      isActive 
        ? 'ring-2 ring-[#111111] shadow-md' 
        : ''
    }`}>
      <div>
        {/* Top Meta Bar */}
        <div className="flex items-start justify-between gap-2 mb-3">
          <span className={`text-[11px] font-bold px-3 py-1 rounded-full border ${statusInfo.bg}`}>
            {statusInfo.label}
          </span>
          {isActive && (
            <span className="flex items-center gap-1.5 text-xs font-bold text-neutral-900 bg-neutral-100 border border-black/[0.05] px-2.5 py-0.5 rounded-full">
              <Radio className="w-3 h-3 text-emerald-600 animate-pulse" />
              <span>{t('camps.active_badge')}</span>
            </span>
          )}
        </div>

        {/* Camp Title */}
        <h3 className="font-bold text-base text-neutral-900 mb-3 line-clamp-1">
          {camp.camp_name}
        </h3>

        {/* Location & Schedule Details */}
        <div className="space-y-2 text-xs text-neutral-500 mb-4 font-normal">
          <div className="flex items-center gap-2">
            <MapPin className="w-4 h-4 text-neutral-400 shrink-0" />
            <span>{camp.village_town}, {camp.district}, {camp.state}</span>
          </div>
          <div className="flex items-center gap-2">
            <Calendar className="w-4 h-4 text-neutral-400 shrink-0" />
            <span>{camp.scheduled_date} ({camp.start_time} - {camp.end_time})</span>
          </div>
          <div className="flex items-center gap-2">
            <Users className="w-4 h-4 text-neutral-400 shrink-0" />
            <span className="font-bold text-neutral-900">{camp.students_enrolled || 0}</span>
            <span>{t('camps.students_count')}</span>
          </div>
        </div>
      </div>

      {/* Action Footer (Pill Buttons) */}
      <div className="flex items-center gap-2 pt-3 border-t border-black/[0.04]">
        {!isActive ? (
          <button
            onClick={() => setActiveCamp(camp.camp_id)}
            className="btn-pill-secondary flex-1 py-2 text-xs font-semibold"
          >
            {t('camps.set_active')}
          </button>
        ) : (
          <button
            onClick={() => onSelectIntake(camp)}
            className="btn-pill-black flex-1 py-2 text-xs font-semibold gap-1.5 shadow-sm"
          >
            <CheckCircle2 className="w-3.5 h-3.5 text-white" />
            <span>{t('nav.intake')}</span>
          </button>
        )}
      </div>

    </div>
  );
}
