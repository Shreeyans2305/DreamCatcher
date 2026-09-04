import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { useAdminAuth } from '../context/AdminAuthContext';
import { useCampOperations } from '../context/CampOperationsContext';
import OperationalKpiGrid from '../components/dashboard/OperationalKpiGrid';
import IntakeTrendChart from '../components/dashboard/IntakeTrendChart';
import RegionalReachChart from '../components/dashboard/RegionalReachChart';
import { UserPlus, Tent, MapPin, ArrowRight, BarChart3, Sparkles } from 'lucide-react';

export default function DashboardView({ onNavigateTab, onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();
  const { volunteer } = useAuth();
  const { admin } = useAdminAuth();
  const { activeCamp, camps = [], students, triggerSyncFlush } = useCampOperations();

  const officerName = admin?.name || volunteer?.full_name || 'Field Officer';
  const firstName = officerName.split(' ')[0];
  const jurisdiction = admin?.district || volunteer?.district || 'Field';
  const locationLabel = activeCamp
    ? `${activeCamp.camp_name} • ${activeCamp.village_town || activeCamp.district || 'Active Hub'}`
    : `${jurisdiction} Jurisdiction • Active`;

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-8 space-y-6 sm:space-y-8">
      
      {/* 1. Minimal Aesthetic Field Header */}
      <div className="glass-card rounded-3xl p-7 sm:p-9 shadow-xs flex flex-col md:flex-row md:items-center md:justify-between gap-6 relative overflow-hidden">
        
        {/* Subtle decorative glow */}
        <div className="absolute top-0 right-0 w-72 h-72 bg-[#DE482B]/3 rounded-full blur-3xl pointer-events-none" />

        <div className="space-y-2 relative z-10">
          {/* Active Camp Location Pill */}
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-black/4 border border-black/5 text-xs font-bold text-[#554E44]">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse shrink-0" />
            <MapPin className="w-3.5 h-3.5 text-[#DE482B] shrink-0" />
            <span>
              {locationLabel}
            </span>
          </div>

          {/* Bold Human Greeting */}
          <h1 className="font-display font-black text-3xl sm:text-5xl text-[#141414] tracking-tight leading-tight">
            {t('dashboard.welcome', 'Welcome back')}, {firstName} 👋
          </h1>

          <p className="text-sm sm:text-base text-[#5C5449] font-medium leading-relaxed max-w-xl">
            {camps.length === 0
              ? `Welcome to your field portal! No active guidance camps scheduled in ${jurisdiction} yet. Click New Camp to get started.`
              : `${students.length} ${t('dashboard.students_enrolled_desc', "students enrolled in this guidance session. Ready for today's intakes?")}`}
          </p>
        </div>

        {/* Minimal High-Priority Action Buttons */}
        <div className="flex flex-wrap items-center gap-3 shrink-0 relative z-10">
          <button
            onClick={() => onNavigateTab('intake')}
            className="px-6 py-3 bg-[#161616] hover:bg-black text-white text-xs font-bold rounded-full transition-all shadow-sm flex items-center gap-2 cursor-pointer hover:scale-105 active:scale-95"
          >
            <UserPlus className="w-4 h-4" />
            <span>{t('dashboard.new_intake', 'New Student Intake')}</span>
          </button>

          <button
            onClick={() => onNavigateTab('camps')}
            className="px-5 py-3 bg-white/80 hover:bg-white text-[#2D2823] border border-[#DDD3C5] text-xs font-bold rounded-full transition-all cursor-pointer shadow-2xs hover:scale-105 active:scale-95 flex items-center gap-2"
          >
            <Tent className="w-4 h-4 text-[#7A6F62]" />
            <span>{t('dashboard.switch_camp', 'Switch Camp')}</span>
          </button>
        </div>

      </div>

      {/* 2. Operational KPI Metrics (Clean Minimal Grid) */}
      <OperationalKpiGrid
        onNewIntake={() => onNavigateTab('intake')}
        onSyncNow={triggerSyncFlush}
      />

      {/* 3. Streamlined Clean Trends Analytics */}
      <div className="space-y-4">
        <div className="flex items-center justify-between border-b border-[#E5DED4] pb-3">
          
          <div className="flex items-center gap-2">
            <div className="flex items-center gap-2 text-sm font-extrabold text-[#141414] font-display">
              <BarChart3 className="w-4 h-4 text-[#DE482B]" />
              <span>{t('dashboard.trends_tab', 'Intake & Regional Trends')}</span>
            </div>
          </div>

          <button
            onClick={() => onNavigateTab('directory')}
            className="text-xs text-[#524B43] hover:text-[#141414] hover:underline flex items-center gap-1.5 cursor-pointer font-bold transition-colors"
          >
            <span>{t('dashboard.full_directory', 'Full Directory')}</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* Analytics Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5 animate-in fade-in duration-200">
          <IntakeTrendChart students={students} />
          <RegionalReachChart students={students} />
        </div>
      </div>

    </div>
  );
}
