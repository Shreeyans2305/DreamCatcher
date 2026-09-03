import React, { useState } from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { useCampOperations } from '../context/CampOperationsContext';
import OperationalKpiGrid from '../components/dashboard/OperationalKpiGrid';
import IntakeTrendChart from '../components/dashboard/IntakeTrendChart';
import RegionalReachChart from '../components/dashboard/RegionalReachChart';
import StudentDirectoryTable from '../components/students/StudentDirectoryTable';
import { UserPlus, Tent, Sparkles, MapPin, ArrowRight, BarChart3, Users, CheckCircle2 } from 'lucide-react';

export default function DashboardView({ onNavigateTab, onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();
  const { volunteer } = useAuth();
  const { activeCamp, students, triggerSyncFlush } = useCampOperations();
  const [dashboardTab, setDashboardTab] = useState('directory'); // 'directory' | 'analytics'

  const firstName = volunteer?.full_name ? volunteer.full_name.split(' ')[0] : 'Counselor';

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 space-y-6">
      
      {/* 1. Minimal Unified Government Field Header */}
      <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-5 sm:p-6 shadow-xs flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="text-[10px] bg-[#EAE2D5] text-[#4A4238] font-semibold px-2.5 py-0.5 rounded-full uppercase tracking-wider border border-[#D5CCBD]">
              🇮🇳 Official Guidance Camp
            </span>
            <span className="text-xs text-[#7A6F62] flex items-center gap-1 font-medium">
              <MapPin className="w-3 h-3 text-[#7A6F62]" />
              {activeCamp?.camp_name || 'Satara Rural Camp'} ({activeCamp?.village_town || 'Satara'})
            </span>
          </div>

          <h1 className="font-serif-zen text-2xl sm:text-3xl font-semibold text-[#1F1F1F] tracking-tight">
            Welcome, {firstName}
          </h1>

          <p className="text-xs sm:text-sm text-[#6B6256] font-normal">
            National Field Counselor Dashboard • {students.length} students recorded in this camp registry.
          </p>
        </div>

        {/* Minimal High-Priority Action Buttons */}
        <div className="flex items-center gap-2.5 shrink-0">
          <button
            onClick={() => onNavigateTab('intake')}
            className="px-5 py-2.5 bg-[#222222] hover:bg-[#111111] text-white text-xs font-medium rounded-full transition-all shadow-xs flex items-center gap-2 cursor-pointer hover:scale-105"
          >
            <UserPlus className="w-4 h-4" />
            <span>New Student Intake</span>
          </button>

          <button
            onClick={() => onNavigateTab('camps')}
            className="px-4 py-2.5 bg-[#F4EFE6] hover:bg-white text-[#2D2823] border border-[#DDD3C5] text-xs font-medium rounded-full transition-all cursor-pointer shadow-xs"
          >
            <Tent className="w-3.5 h-3.5 text-[#7A6F62]" />
            <span>Switch Camp</span>
          </button>
        </div>

      </div>

      {/* 2. Operational KPI Metrics (Clean Minimal Grid) */}
      <OperationalKpiGrid
        onNewIntake={() => onNavigateTab('intake')}
        onSyncNow={triggerSyncFlush}
      />

      {/* 3. Streamlined Clean View Switcher (Directory vs Analytics) */}
      <div className="space-y-4">
        <div className="flex items-center justify-between border-b border-[#E5DED4] pb-2">
          
          <div className="flex items-center gap-2">
            <button
              onClick={() => setDashboardTab('directory')}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-all cursor-pointer ${
                dashboardTab === 'directory'
                  ? 'bg-[#222222] text-white shadow-xs'
                  : 'text-[#665D52] hover:text-[#1F1F1F] hover:bg-[#F4EFE6]'
              }`}
            >
              <Users className="w-3.5 h-3.5" />
              <span>Camp Student Registry ({students.length})</span>
            </button>

            <button
              onClick={() => setDashboardTab('analytics')}
              className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-all cursor-pointer ${
                dashboardTab === 'analytics'
                  ? 'bg-[#222222] text-white shadow-xs'
                  : 'text-[#665D52] hover:text-[#1F1F1F] hover:bg-[#F4EFE6]'
              }`}
            >
              <BarChart3 className="w-3.5 h-3.5" />
              <span>Intake & Regional Trends</span>
            </button>
          </div>

          <button
            onClick={() => onNavigateTab('directory')}
            className="text-xs text-[#524B43] hover:text-[#1F1F1F] hover:underline flex items-center gap-1 cursor-pointer font-medium"
          >
            <span>Full Directory</span>
            <ArrowRight className="w-3 h-3" />
          </button>
        </div>

        {/* Tab 1: Clean Minimal Student Directory */}
        {dashboardTab === 'directory' ? (
          <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-2 sm:p-4 shadow-xs overflow-hidden">
            <StudentDirectoryTable
              onSelectStudentForCase={onSelectStudentForCase}
              onLaunchGuidance={onLaunchGuidance}
            />
          </div>
        ) : (
          /* Tab 2: Clean Analytics Row */
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-5 animate-in fade-in duration-200">
            <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-5 shadow-xs">
              <IntakeTrendChart />
            </div>
            <div className="bg-[#FCFAF7] border border-[#E5DED4] rounded-2xl p-5 shadow-xs">
              <RegionalReachChart students={students} />
            </div>
          </div>
        )}
      </div>

    </div>
  );
}
