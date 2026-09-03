import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { Users, CalendarCheck, CheckCircle2, CloudUpload, AlertCircle } from 'lucide-react';

export default function OperationalKpiGrid({ onNewIntake, onSyncNow }) {
  const { t } = useLanguage();
  const { students, camps, syncQueue } = useCampOperations();

  const totalStudents = students.length;
  const completedCamps = camps.filter(c => c.status === 'completed').length;
  const totalCamps = camps.length;
  const studentsWithNotes = students.filter(s => (s.case_notes || []).length > 0).length;
  const pendingGuidance = totalStudents - studentsWithNotes;

  const kpis = [
    {
      title: t('dashboard.kpi_total_students'),
      value: totalStudents,
      subtext: `${studentsWithNotes} fully completed guidance sessions`,
      icon: Users,
      badgeBg: 'bg-indigo-50 text-indigo-600',
    },
    {
      title: 'Field Camps Completed',
      value: `${completedCamps} / ${totalCamps}`,
      subtext: 'Across Satara & Patan rural blocks',
      icon: CalendarCheck,
      badgeBg: 'bg-emerald-50 text-emerald-600',
    },
    {
      title: 'Pending Guidance Follow-up',
      value: pendingGuidance,
      subtext: 'Registered students awaiting AI counseling',
      icon: AlertCircle,
      badgeBg: 'bg-amber-50 text-amber-600',
    },
    {
      title: t('dashboard.kpi_pending_sync'),
      value: syncQueue.length,
      subtext: syncQueue.length === 0 ? 'All local records synced' : 'Click to flush to cloud',
      icon: CloudUpload,
      badgeBg: syncQueue.length > 0 ? 'bg-rose-50 text-rose-600' : 'bg-neutral-100 text-neutral-600',
      action: syncQueue.length > 0 ? onSyncNow : null
    }
  ];

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
      {kpis.map((kpi, idx) => {
        const Icon = kpi.icon;
        return (
          <div
            key={idx}
            onClick={kpi.action || undefined}
            className={`glass-card rounded-2xl p-5 flex flex-col justify-between space-y-3 transition-all ${
              kpi.action ? 'cursor-pointer hover:border-[#141414]' : ''
            }`}
          >
            <div className="flex items-center justify-between">
              <div className={`w-10 h-10 rounded-xl ${kpi.badgeBg} flex items-center justify-center shrink-0`}>
                <Icon className="w-5 h-5" />
              </div>
              {kpi.action && (
                <span className="text-[10px] font-bold bg-[#FAF0EE] text-[#8E3A32] border border-[#E8C2BA] px-2 py-0.5 rounded-full">
                  Action Needed
                </span>
              )}
            </div>
            <div>
              <div className="font-display font-black text-3xl sm:text-4xl text-[#141414] tracking-tight tabular-nums">
                {kpi.value}
              </div>
              <div className="text-xs font-bold text-[#38332C] mt-1">
                {kpi.title}
              </div>
              <p className="text-[11px] text-[#7A6F62] font-medium mt-0.5 leading-normal">
                {kpi.subtext}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  );
}
