import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';
import { useAdminAuth } from '../../context/AdminAuthContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import DreamCatcherIcon from '../ui/DreamCatcherIcon';
import GlassLanguageDropdown from '../ui/GlassLanguageDropdown';
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
  const { volunteer, isAuthenticated: isVolAuth, logout, openAuthModal, setIsCredentialModalOpen } = useAuth();
  const { admin, isAuthenticated: isAdminAuth, signOut: adminSignOut } = useAdminAuth();
  const isAuthenticated = isVolAuth || isAdminAuth;

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

  const officerName = admin?.name || volunteer?.full_name || 'Field Officer';
  const officerBadgeId = admin?.government_id || volunteer?.volunteer_id || 'DC-OFFICER';

  const initials = officerName
    ? officerName.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase()
    : 'DC';

  return (
    <header className="sticky top-2 sm:top-3 z-40 max-w-5xl mx-auto px-3 w-full pointer-events-none">
      <div className="glass-nav rounded-full px-3 sm:px-4 py-1.5 flex items-center justify-between pointer-events-auto transition-all duration-300">
        
        {/* ========================================================= */}
        {/* 1. LEFT: BRAND & DREAMCATCHER ICON                        */}
        {/* ========================================================= */}
        <div className="flex items-center gap-2 shrink-0">
          <button
            onClick={onNavigateHome}
            title="Return to Home"
            className="flex items-center gap-2 text-left group cursor-pointer"
          >
            {/* Minimalist Dreamcatcher Vector Icon */}
            <div className="w-7 h-7 rounded-full bg-[#161616] text-[#FAF7F2] flex items-center justify-center shadow-xs p-1 group-hover:scale-105 group-hover:bg-[#000000] transition-all">
              <DreamCatcherIcon className="w-4 h-4 text-[#FAF7F2]" />
            </div>

            <div className="flex items-center">
              <span className="font-display font-extrabold text-base tracking-tight text-[#141414] group-hover:text-black transition-colors">
                DreamCatcher
              </span>
            </div>
          </button>
        </div>

        {/* ========================================================= */}
        {/* 2. CENTER: CLEAN UNIFIED NAVIGATION TABS (No nested box)  */}
        {/* ========================================================= */}
        {onSelectTab && (
          <nav className="hidden md:flex items-center gap-1">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => onSelectTab(tab.id)}
                  className={`relative flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold transition-all duration-200 cursor-pointer ${
                    isActive
                      ? 'text-[#141414] bg-black/[0.08] shadow-2xs font-black'
                      : 'text-[#61574C] hover:text-[#111111] hover:bg-black/[0.04]'
                  }`}
                >
                  <Icon className={`w-3.5 h-3.5 ${isActive ? 'text-[#141414]' : 'text-[#7A6F62]'}`} />
                  <span className="font-display">{tab.label}</span>
                  {tab.badge && (
                    <span className={`text-[10px] px-1.5 py-0.2 rounded-full font-bold ${
                      isActive ? 'bg-[#141414] text-white' : 'bg-[#EAE2D5] text-[#333333]'
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
        <div className="flex items-center gap-1.5 shrink-0">
          
          {/* Active Camp Dropdown Item */}
          <div className="relative">
            <button
              onClick={() => setCampMenuOpen(!campMenuOpen)}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-full text-xs text-[#2D2823] hover:text-black hover:bg-black/[0.04] transition-all cursor-pointer font-bold"
              title="Switch active camp location"
            >
              <MapPin className="w-3.5 h-3.5 text-[#DE482B]" />
              <span className="font-display text-[11px] max-w-22.5 truncate">
                {activeCamp?.village_town || admin?.district || volunteer?.district || 'Field Hub'}
              </span>
              <ChevronDown className="w-2.5 h-2.5 text-[#7A6F62] opacity-70" />
            </button>

            {campMenuOpen && (
              <div className="absolute right-0 mt-2 w-56 bg-[#FCFAF7]/95 backdrop-blur-xl rounded-2xl p-2 border border-[#E5DED4] shadow-lg z-50 animate-in fade-in zoom-in-95 duration-150">
                <span className="block px-3 py-1 text-[10px] uppercase font-semibold text-[#8C8276]">
                  Active Camp Locations
                </span>
                {camps.length === 0 ? (
                  <div className="px-3 py-3 text-xs text-[#7A6F62] text-center">
                    No active camps yet.<br />
                    <span className="text-[10px] text-[#A83E28] font-bold">Go to Camps to create one</span>
                  </div>
                ) : (
                  camps.map(c => (
                    <button
                      key={c.camp_id}
                      onClick={() => {
                        setActiveCamp(c.camp_id);
                        setCampMenuOpen(false);
                      }}
                      className={`w-full text-left px-3 py-2 rounded-xl text-xs flex items-center justify-between transition-colors cursor-pointer ${
                        activeCamp?.camp_id === c.camp_id
                          ? 'bg-[#222222] text-white'
                          : 'text-[#2D2823] hover:bg-black/4'
                      }`}
                    >
                      <span className="truncate">{c.camp_name}</span>
                      <span className="text-[10px] opacity-70">{c.village_town}</span>
                    </button>
                  ))
                )}
              </div>
            )}
          </div>

          {/* Minimal Integrated Glass Language Selector */}
          <GlassLanguageDropdown />

          {/* Counselor Profile / Credentials Popover */}
          {isAuthenticated ? (
            <div className="relative">
              <button
                onClick={() => setProfileMenuOpen(!profileMenuOpen)}
                className="w-7 h-7 rounded-full bg-[#161616] text-white flex items-center justify-center font-display font-black text-[11px] shadow-xs hover:scale-105 transition-transform cursor-pointer"
                title="Volunteer Profile Menu"
              >
                {initials}
              </button>

              {profileMenuOpen && (
                <div className="absolute right-0 mt-2 w-52 bg-[#FCFAF7]/95 backdrop-blur-xl rounded-2xl p-2 border border-[#E5DED4] shadow-lg z-50 animate-in fade-in zoom-in-95 duration-150">
                  <div className="px-3 py-2 border-b border-[#EAE2D5] mb-1">
                    <span className="font-serif-zen font-semibold text-xs text-[#1F1F1F] block truncate">
                      {officerName}
                    </span>
                    <span className="text-[10px] text-[#A83E28] font-mono font-bold block truncate">
                      {officerBadgeId}
                    </span>
                  </div>

                  <button
                    onClick={() => {
                      setIsCredentialModalOpen(true);
                      setProfileMenuOpen(false);
                    }}
                    className="w-full text-left px-3 py-1.5 text-xs text-[#2D2823] hover:bg-black/4 rounded-xl flex items-center gap-2 cursor-pointer transition-colors"
                  >
                    <Award className="w-3.5 h-3.5 text-[#C49F5A]" />
                    <span>Official ID Badge</span>
                  </button>

                  <button
                    onClick={() => {
                      onNavigateHome();
                      setProfileMenuOpen(false);
                    }}
                    className="w-full text-left px-3 py-1.5 text-xs text-[#2D2823] hover:bg-black/4 rounded-xl flex items-center gap-2 cursor-pointer transition-colors"
                  >
                    <Home className="w-3.5 h-3.5 text-[#7A6F62]" />
                    <span>Public Home</span>
                  </button>

                  <div className="border-t border-[#EAE2D5] mt-1 pt-1">
                    <button
                      onClick={async () => {
                        logout();
                        if (adminSignOut) await adminSignOut();
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
