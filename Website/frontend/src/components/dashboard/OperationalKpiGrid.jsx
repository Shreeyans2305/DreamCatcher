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
      color: 'text-[#173F6B]',
      bgColor: 'bg-sky-50 border-sky-200'
    },
    {
      title: 'Field Camps Completed',
      value: `${completedCamps} / ${totalCamps}`,
      subtext: 'Across Satara & Patan rural blocks',
      icon: CalendarCheck,
      color: 'text-emerald-700',
      bgColor: 'bg-emerald-50 border-emerald-200'
    },
    {
      title: 'Pending Guidance Follow-up',
      value: pendingGuidance,
      subtext: 'Registered students awaiting AI counseling',
      icon: AlertCircle,
      color: 'text-amber-700',
      bgColor: 'bg-amber-50 border-amber-200'
    },
    {
      title: t('dashboard.kpi_pending_sync'),
      value: syncQueue.length,
      subtext: syncQueue.length === 0 ? 'All local records synced' : 'Click to flush to cloud',
      icon: CloudUpload,
      color: syncQueue.length > 0 ? 'text-amber-600' : 'text-slate-600',
      bgColor: syncQueue.length > 0 ? 'bg-amber-50 border-amber-300' : 'bg-slate-50 border-slate-200',
      action: syncQueue.length > 0 ? onSyncNow : null
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
            className={`rounded-xl border p-4 sm:p-5 shadow-xs transition-all ${kpi.bgColor} ${
              kpi.action ? 'cursor-pointer hover:shadow-md' : ''
            }`}
          >
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-bold text-slate-700 font-indic">{kpi.title}</span>
              <Icon className={`w-5 h-5 ${kpi.color}`} />
            </div>
            <div className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight font-indic">
              {kpi.value}
            </div>
            <p className="text-[11px] text-slate-600 font-medium font-indic mt-1">
              {kpi.subtext}
            </p>
          </div>
        );
      })}
    </div>
  );
}
