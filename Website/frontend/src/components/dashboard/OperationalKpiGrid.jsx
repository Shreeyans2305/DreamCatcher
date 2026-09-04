import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { Users, CalendarCheck, CloudUpload, Sparkles, AlertCircle } from 'lucide-react';

export default function OperationalKpiGrid({ onNewIntake, onSyncNow }) {
  const { t } = useLanguage();
  const { students, camps, syncQueue } = useCampOperations();

  const totalStudents = students.length;
  const completedCamps = camps.filter(c => c.status === 'completed').length;
  const totalCamps = camps.length;
  const studentsWithNotes = students.filter(s => (s.case_notes || []).length > 0).length;
  const pendingGuidance = totalStudents - studentsWithNotes;

  const distinctLocations = Array.from(
    new Set(camps.map(c => c.village_town || c.district).filter(Boolean))
  );
  const campsLocationSubtext = distinctLocations.length > 0
    ? `${distinctLocations.slice(0, 2).join(' & ')}${distinctLocations.length > 2 ? ` +${distinctLocations.length - 2} hubs` : ''} field schools`
    : 'Scheduled guidance drives in jurisdiction';

  const kpis = [
    {
      title: t('dashboard.kpi_total_students'),
      value: totalStudents,
      subtext: totalStudents > 0
        ? `${studentsWithNotes} fully completed guidance notes`
        : 'Ready for initial student intakes',
      icon: Users,
      iconColor: 'text-[#161616]',
      badgeBg: 'bg-[#161616]/[0.06]',
    },
    {
      title: 'Field Camps Completed',
      value: `${completedCamps} / ${totalCamps}`,
      subtext: campsLocationSubtext,
      icon: CalendarCheck,
      iconColor: 'text-[#DE482B]',
      badgeBg: 'bg-[#DE482B]/10',
    },
    {
      title: 'Pending AI Guidance',
      value: pendingGuidance,
      subtext: pendingGuidance > 0 
        ? `${pendingGuidance} enrolled students awaiting recommendations`
        : 'All current student case records complete',
      icon: Sparkles,
      iconColor: 'text-[#B87333]',
      badgeBg: 'bg-[#B87333]/10',
    },
    {
      title: t('dashboard.kpi_pending_sync'),
      value: syncQueue.length,
      subtext: syncQueue.length === 0 ? 'All local records live on cloud' : 'Unsynced intakes waiting to flush',
      icon: CloudUpload,
      iconColor: syncQueue.length > 0 ? 'text-[#DE482B]' : 'text-[#4A6B53]',
      badgeBg: syncQueue.length > 0 ? 'bg-[#DE482B]/10' : 'bg-[#4A6B53]/10',
      action: syncQueue.length > 0 ? onSyncNow : null,
      actionText: 'Flush Cloud Sync'
    }
  ];

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      {kpis.map((kpi, idx) => {
        const Icon = kpi.icon;
        return (
          <div
            key={idx}
            onClick={kpi.action || undefined}
            className={`glass-card rounded-3xl p-6 flex flex-col justify-between space-y-4 transition-all duration-300 ${
              kpi.action 
                ? 'cursor-pointer hover:-translate-y-1 hover:border-[#DE482B] hover:shadow-[0_16px_36px_rgba(222,72,43,0.1)]' 
                : 'hover:-translate-y-0.5 hover:shadow-[0_12px_28px_rgba(20,15,10,0.05)]'
            }`}
          >
            {/* Header: Icon & Optional Action Tag */}
            <div className="flex items-center justify-between">
              <div className={`w-11 h-11 rounded-2xl ${kpi.badgeBg} ${kpi.iconColor} flex items-center justify-center shrink-0 shadow-2xs`}>
                <Icon className="w-5 h-5 stroke-[2.2]" />
              </div>
              {kpi.action && (
                <span className="text-[10px] font-black uppercase tracking-wider bg-[#FAF0EE] text-[#DE482B] border border-[#F0C4BC] px-2.5 py-1 rounded-full animate-pulse">
                  {kpi.actionText}
                </span>
              )}
            </div>

            {/* Metrics & Context */}
            <div>
              <div className="font-display font-black text-4xl sm:text-5xl text-[#141414] tracking-tight tabular-nums">
                {kpi.value}
              </div>
              <div className="text-xs font-extrabold uppercase tracking-wider text-[#8A7E72] mt-1.5 font-display">
                {kpi.title}
              </div>
              <p className="text-xs text-[#524B41] font-medium mt-1 leading-snug">
                {kpi.subtext}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  );
}
