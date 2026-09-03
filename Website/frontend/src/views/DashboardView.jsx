import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { useCampOperations } from '../context/CampOperationsContext';
import OperationalKpiGrid from '../components/dashboard/OperationalKpiGrid';
import IntakeTrendChart from '../components/dashboard/IntakeTrendChart';
import RegionalReachChart from '../components/dashboard/RegionalReachChart';
import { UserPlus, Tent, Sparkles, MapPin, ArrowRight, BarChart3, Users, CheckCircle2 } from 'lucide-react';

export default function DashboardView({ onNavigateTab, onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();
  const { volunteer } = useAuth();
  const { activeCamp, students, triggerSyncFlush } = useCampOperations();

  const firstName = volunteer?.full_name ? volunteer.full_name.split(' ')[0] : 'Counselor';

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 space-y-6">
      
      {/* 1. Minimal Unified Field Header */}
      <div className="glass-card rounded-3xl p-6 sm:p-8 shadow-xs flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="text-xs text-[#6B6256] flex items-center gap-1.5 font-bold">
              <MapPin className="w-3.5 h-3.5 text-[#DE482B]" />
              {activeCamp?.camp_name || 'Satara Rural Camp'} ({activeCamp?.village_town || 'Satara'})
            </span>
          </div>

          <h1 className="font-display font-black text-3xl sm:text-4xl text-[#141414] tracking-tight">
            {t('dashboard.welcome', 'Welcome back')}, {firstName} 👋
          </h1>

          <p className="text-sm text-[#5C554B] font-medium">
            {students.length} {t('dashboard.students_enrolled_desc', "students enrolled in this guidance session. Ready for today's intakes?")}
          </p>
        </div>

        {/* Minimal High-Priority Action Buttons */}
        <div className="flex items-center gap-2.5 shrink-0">
          <button
            onClick={() => onNavigateTab('intake')}
            className="px-5 py-2.5 bg-[#222222] hover:bg-[#111111] text-white text-xs font-bold rounded-full transition-all shadow-xs flex items-center gap-2 cursor-pointer hover:scale-105"
          >
            <UserPlus className="w-4 h-4" />
            <span>{t('dashboard.new_intake', 'New Student Intake')}</span>
          </button>

          <button
            onClick={() => onNavigateTab('camps')}
            className="px-4 py-2.5 bg-[#F4EFE6] hover:bg-white text-[#2D2823] border border-[#DDD3C5] text-xs font-bold rounded-full transition-all cursor-pointer shadow-xs"
          >
            <Tent className="w-3.5 h-3.5 text-[#7A6F62]" />
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
        <div className="flex items-center justify-between border-b border-[#E5DED4] pb-2">
          
          <div className="flex items-center gap-2">
            <div className="flex items-center gap-1.5 text-sm font-bold text-[#141414] font-display">
              <BarChart3 className="w-4 h-4 text-[#DE482B]" />
              <span>{t('dashboard.trends_tab', 'Intake & Regional Trends')}</span>
            </div>
          </div>

          <button
            onClick={() => onNavigateTab('directory')}
            className="text-xs text-[#524B43] hover:text-[#1F1F1F] hover:underline flex items-center gap-1 cursor-pointer font-bold"
          >
            <span>{t('dashboard.full_directory', 'Full Directory')}</span>
            <ArrowRight className="w-3 h-3" />
          </button>
        </div>

        {/* Analytics Row */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5 animate-in fade-in duration-200">
          <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-5 shadow-xs">
            <IntakeTrendChart />
          </div>
          <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-5 shadow-xs">
            <RegionalReachChart students={students} />
          </div>
        </div>
      </div>

    </div>
  );
}
