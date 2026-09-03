import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import DreamCatcherIcon from '../ui/DreamCatcherIcon';
import { 
  Globe, 
  Wifi, 
  WifiOff, 
  RefreshCw, 
  Award, 
  LogOut, 
  MapPin, 
  ChevronDown,
  LayoutDashboard,
  Tent,
  UserPlus,
  Users,
  Sparkles,
  Home
} from 'lucide-react';

export default function AppHeader({ activeTab, onSelectTab, onNavigateHome }) {
  const { uiLanguage, setLanguage, languageOptions, t } = useLanguage();
  const { volunteer, isAuthenticated, logout, openAuthModal, setIsCredentialModalOpen } = useAuth();
  const { 
    activeCamp, 
    camps, 
    setActiveCamp, 
    isOnline, 
    setIsOnline, 
    syncQueue, 
    triggerSyncFlush, 
    selectedStudentForGuidance 
  } = useCampOperations();

  const [campMenuOpen, setCampMenuOpen] = useState(false);
  const [profileMenuOpen, setProfileMenuOpen] = useState(false);

  const tabs = [
    { id: 'dashboard', label: t('nav.dashboard') || 'Dashboard', icon: LayoutDashboard },
    { id: 'camps', label: t('nav.camps') || 'Camps', icon: Tent },
    { id: 'intake', label: t('nav.intake') || 'Intake', icon: UserPlus, highlight: true },
    { id: 'directory', label: t('nav.directory') || 'Registry', icon: Users },
    { 
      id: 'guidance', 
      label: t('nav.guidance') || 'Guidance', 
      icon: Sparkles,
      badge: selectedStudentForGuidance ? selectedStudentForGuidance.full_name?.split(' ')[0] : null
    },
  ];

  const initials = volunteer?.full_name
    ? volunteer.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : 'DC';

  return (
    <header className="sticky top-3 sm:top-4 z-40 max-w-7xl mx-auto px-3 sm:px-6 w-full pointer-events-none">
      <div className="bg-[#FCFAF7]/75 backdrop-blur-2xl backdrop-saturate-150 border border-white/80 shadow-[0_10px_35px_rgba(40,30,20,0.06),0_1px_2px_rgba(0,0,0,0.03)] rounded-full px-3.5 sm:px-5 py-2 flex items-center justify-between pointer-events-auto transition-all duration-300">
        
        {/* ========================================================= */}
        {/* 1. LEFT: BRAND & DREAMCATCHER ICON                        */}
        {/* ========================================================= */}
        <div className="flex items-center gap-2 sm:gap-3 shrink-0">
          <button
            onClick={onNavigateHome}
            title="Return to Home"
            className="flex items-center gap-2 text-left group cursor-pointer"
          >
            {/* Minimalist Dreamcatcher Vector Icon */}
            <div className="w-8 h-8 rounded-full bg-[#222222] text-[#F7F4EE] flex items-center justify-center shadow-xs p-1 group-hover:scale-105 group-hover:bg-[#111111] transition-all">
              <DreamCatcherIcon className="w-5 h-5 text-[#F7F4EE]" />
            </div>

            <div className="flex flex-col">
              <span className="font-serif-zen font-semibold text-base sm:text-lg tracking-tight text-[#1F1F1F] group-hover:text-black transition-colors">
                DreamCatcher
              </span>
            </div>
          </button>
        </div>

        {/* ========================================================= */}
        {/* 2. CENTER: MINIMAL FLOATING NAVIGATION TABS (iOS Glass)   */}
        {/* ========================================================= */}
        {onSelectTab && (
          <nav className="hidden md:flex items-center gap-1 bg-black/[0.03] p-1 rounded-full border border-black/[0.03]">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => onSelectTab(tab.id)}
                  className={`relative flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all duration-200 cursor-pointer ${
                    isActive
                      ? 'bg-[#222222] text-white shadow-xs'
                      : 'text-[#61574C] hover:text-[#1F1F1F] hover:bg-black/[0.04]'
                  }`}
                >
                  <Icon className={`w-3.5 h-3.5 ${isActive ? 'text-white' : 'text-[#7A6F62]'}`} />
                  <span className="font-serif-zen font-medium">{tab.label}</span>
                  {tab.badge && (
                    <span className={`text-[10px] px-1.5 py-0.2 rounded-full ${
                      isActive ? 'bg-[#3D3730] text-white' : 'bg-[#EAE2D5] text-[#3D3730]'
                    }`}>
                      {tab.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        )}

        {/* ========================================================= */}
        {/* 3. RIGHT: COMPACT, STREAMLINED UTILITIES                  */}
        {/* ========================================================= */}
        <div className="flex items-center gap-2 shrink-0">
          
          {/* Active Camp Dropdown Chip */}
          <div className="relative">
            <button
              onClick={() => setCampMenuOpen(!campMenuOpen)}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/70 hover:bg-white border border-[#DDD3C5] text-xs text-[#2D2823] transition-all cursor-pointer shadow-2xs"
              title="Switch active camp location"
            >
              <MapPin className="w-3.5 h-3.5 text-[#C49F5A]" />
              <span className="font-medium max-w-[100px] truncate">
                {activeCamp?.village_town || 'Satara'}
              </span>
              <ChevronDown className="w-3 h-3 text-[#7A6F62] opacity-70" />
            </button>

            {campMenuOpen && (
              <div className="absolute right-0 mt-2 w-56 bg-[#FCFAF7]/95 backdrop-blur-xl rounded-2xl p-2 border border-[#E5DED4] shadow-lg z-50 animate-in fade-in zoom-in-95 duration-150">
                <span className="block px-3 py-1 text-[10px] uppercase font-semibold text-[#8C8276]">
                  Active Camp Locations
                </span>
                {camps.map(c => (
                  <button
                    key={c.camp_id}
                    onClick={() => {
                      setActiveCamp(c.camp_id);
                      setCampMenuOpen(false);
                    }}
                    className={`w-full text-left px-3 py-2 rounded-xl text-xs flex items-center justify-between transition-colors cursor-pointer ${
                      activeCamp?.camp_id === c.camp_id
                        ? 'bg-[#222222] text-white'
                        : 'text-[#2D2823] hover:bg-black/[0.04]'
                    }`}
                  >
                    <span className="truncate">{c.camp_name}</span>
                    <span className="text-[10px] opacity-70">{c.village_town}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Online / Sync Status Dot */}
          <div className="flex items-center">
            <button
              onClick={() => setIsOnline(!isOnline)}
              title={isOnline ? 'Online (Click to simulate offline)' : 'Offline (Click to go online)'}
              className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-full text-xs transition-colors cursor-pointer border ${
                isOnline 
                  ? 'bg-[#E8EFE9]/80 border-[#BDD3C2] text-[#2C4A33] hover:bg-[#E8EFE9]' 
                  : 'bg-[#FAF0EE]/80 border-[#E8C2BA] text-[#8E3A32] hover:bg-[#FAF0EE]'
              }`}
            >
              <span className={`w-2 h-2 rounded-full ${isOnline ? 'bg-emerald-500 animate-pulse' : 'bg-rose-500'}`} />
              <span className="hidden lg:inline text-[11px] font-medium">{isOnline ? 'Online' : 'Offline'}</span>
            </button>

            {syncQueue.length > 0 && (
              <button
                onClick={triggerSyncFlush}
                title="Pending local records to sync"
                className="ml-1.5 flex items-center gap-1 px-2.5 py-1 bg-[#C49F5A] text-white rounded-full text-[11px] font-medium shadow-2xs hover:bg-[#B38F4B] transition-all cursor-pointer"
              >
                <RefreshCw className="w-3 h-3 animate-spin" />
                <span>{syncQueue.length}</span>
              </button>
            )}
          </div>

          {/* Minimal Language Selector (EN, MR, GU, HI) */}
          <div className="flex items-center bg-white/70 hover:bg-white border border-[#DDD3C5] rounded-full px-2 py-1.5 text-xs shadow-2xs">
            <Globe className="w-3 h-3 text-[#7A6F62] mr-1 shrink-0" />
            <select
              value={uiLanguage}
              onChange={(e) => setLanguage(e.target.value)}
              aria-label="Language selection"
              className="bg-transparent text-[#1F1F1F] font-semibold text-[11px] cursor-pointer focus:outline-none uppercase"
            >
              {languageOptions.map(opt => (
                <option key={opt.code} value={opt.code} className="text-black bg-[#FAF7F2]">
                  {opt.code.toUpperCase()}
                </option>
              ))}
            </select>
          </div>

          {/* Counselor Profile / Credentials Popover */}
          {isAuthenticated ? (
            <div className="relative">
              <button
                onClick={() => setProfileMenuOpen(!profileMenuOpen)}
                className="w-8 h-8 rounded-full bg-[#222222] text-white flex items-center justify-center font-serif-zen font-bold text-xs shadow-xs hover:scale-105 transition-transform cursor-pointer"
                title="Volunteer Profile Menu"
              >
                {initials}
              </button>

              {profileMenuOpen && (
                <div className="absolute right-0 mt-2 w-52 bg-[#FCFAF7]/95 backdrop-blur-xl rounded-2xl p-2 border border-[#E5DED4] shadow-lg z-50 animate-in fade-in zoom-in-95 duration-150">
                  <div className="px-3 py-2 border-b border-[#EAE2D5] mb-1">
                    <span className="font-serif-zen font-semibold text-xs text-[#1F1F1F] block truncate">
                      {volunteer?.full_name || 'Counselor'}
                    </span>
                    <span className="text-[10px] text-[#7A6F62] block truncate">
                      {volunteer?.volunteer_id || 'DC-VOL-2026'}
                    </span>
                  </div>

                  <button
                    onClick={() => {
                      setIsCredentialModalOpen(true);
                      setProfileMenuOpen(false);
                    }}
                    className="w-full text-left px-3 py-1.5 text-xs text-[#2D2823] hover:bg-black/[0.04] rounded-xl flex items-center gap-2 cursor-pointer transition-colors"
                  >
                    <Award className="w-3.5 h-3.5 text-[#C49F5A]" />
                    <span>Official ID Badge</span>
                  </button>

                  <button
                    onClick={() => {
                      onNavigateHome();
                      setProfileMenuOpen(false);
                    }}
                    className="w-full text-left px-3 py-1.5 text-xs text-[#2D2823] hover:bg-black/[0.04] rounded-xl flex items-center gap-2 cursor-pointer transition-colors"
                  >
                    <Home className="w-3.5 h-3.5 text-[#7A6F62]" />
                    <span>Public Home</span>
                  </button>

                  <div className="border-t border-[#EAE2D5] mt-1 pt-1">
                    <button
                      onClick={() => {
                        logout();
                        setProfileMenuOpen(false);
                      }}
                      className="w-full text-left px-3 py-1.5 text-xs text-rose-600 hover:bg-rose-50 rounded-xl flex items-center gap-2 cursor-pointer transition-colors"
                    >
                      <LogOut className="w-3.5 h-3.5" />
                      <span>{t('header.logout') || 'Log out'}</span>
                    </button>
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className="flex items-center gap-1.5">
              <button
                onClick={() => openAuthModal('login')}
                className="px-3.5 py-1.5 text-xs font-medium bg-[#222222] hover:bg-[#111111] text-white rounded-full transition-all shadow-xs cursor-pointer"
              >
                Sign In
              </button>
            </div>
          )}

        </div>

      </div>

      {/* Mobile Responsive Tab Row (Below glass bar on small screens only) */}
      {onSelectTab && (
        <div className="flex md:hidden items-center justify-center gap-1 mt-2 overflow-x-auto py-1 px-2 scrollbar-none pointer-events-auto">
          <div className="flex items-center gap-1 bg-white/70 backdrop-blur-xl p-1 rounded-full border border-white/60 shadow-xs">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => onSelectTab(tab.id)}
                  className={`flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-medium transition-all ${
                    isActive
                      ? 'bg-[#222222] text-white shadow-xs'
                      : 'text-[#61574C] hover:text-[#1F1F1F]'
                  }`}
                >
                  <Icon className="w-3 h-3" />
                  <span>{tab.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      )}

    </header>
  );
}
