import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useCampOperations } from '../context/CampOperationsContext';
import OperationalKpiGrid from '../components/dashboard/OperationalKpiGrid';
import IntakeTrendChart from '../components/dashboard/IntakeTrendChart';
import RegionalReachChart from '../components/dashboard/RegionalReachChart';
import StudentDirectoryTable from '../components/students/StudentDirectoryTable';
import { UserPlus, Tent, Sparkles, MapPin, ArrowRight } from 'lucide-react';

export default function DashboardView({ onNavigateTab, onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();
  const { activeCamp, students, triggerSyncFlush } = useCampOperations();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      
      {/* Top Banner / Quick Action Launcher */}
      <div className="bg-gradient-to-r from-[#173F6B] to-[#0D2E50] rounded-2xl text-white p-6 shadow-md border border-[#0D2E50]">
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <span className="bg-amber-400 text-slate-950 text-[10px] font-extrabold px-2.5 py-0.5 rounded-full uppercase tracking-wider">
                Field Deployment Active
              </span>
              <span className="text-sky-200 text-xs font-indic">
                Anchor: {activeCamp?.camp_name}
              </span>
            </div>
            <h1 className="text-xl sm:text-2xl font-bold font-indic">
              Welcome to DreamCatcher Field Portal
            </h1>
            <p className="text-xs sm:text-sm text-sky-100/90 font-indic mt-1 max-w-2xl">
              Conduct high-speed student intake (under 60 seconds) and connect rural students to multilingual AI career counseling in Marathi, Hindi, Gujarati, or English.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={() => onNavigateTab('intake')}
              className="px-5 py-3 bg-amber-500 hover:bg-amber-600 text-slate-950 font-extrabold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-all font-indic touch-target"
            >
              <UserPlus className="w-4 h-4 text-slate-950" />
              <span>{t('nav.intake')}</span>
            </button>
            <button
              onClick={() => onNavigateTab('camps')}
              className="px-4 py-3 bg-sky-900/80 hover:bg-sky-800 text-white font-bold text-xs rounded-xl border border-sky-400/30 flex items-center justify-center gap-1.5 transition-colors font-indic touch-target"
            >
              <Tent className="w-4 h-4 text-amber-400" />
              <span>{t('nav.camps')}</span>
            </button>
          </div>
        </div>
      </div>

      {/* Operational KPI Grid */}
      <OperationalKpiGrid
        onNewIntake={() => onNavigateTab('intake')}
        onSyncNow={triggerSyncFlush}
      />

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <IntakeTrendChart />
        <RegionalReachChart students={students} />
      </div>

      {/* Student Registry Snippet */}
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h2 className="text-base font-bold text-slate-900 font-indic">
            {t('dashboard.recent_students')}
          </h2>
          <button
            onClick={() => onNavigateTab('directory')}
            className="text-xs font-bold text-[#173F6B] hover:underline flex items-center gap-1 font-indic"
          >
            <span>{t('dashboard.view_all')}</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        <StudentDirectoryTable
          onSelectStudentForCase={onSelectStudentForCase}
          onLaunchGuidance={onLaunchGuidance}
        />
      </div>

    </div>
  );
}
