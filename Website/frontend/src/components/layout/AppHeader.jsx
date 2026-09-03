import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useAuth } from '../../context/AuthContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { 
  Compass, 
  Globe, 
  Wifi, 
  WifiOff, 
  RefreshCw, 
  Award, 
  LogOut, 
  Home,
  MapPin, 
  ChevronDown 
} from 'lucide-react';

export default function AppHeader({ onNavigateHome }) {
  const { uiLanguage, setLanguage, languageOptions, t } = useLanguage();
  const { volunteer, isAuthenticated, logout, openAuthModal, setIsCredentialModalOpen } = useAuth();
  const { activeCamp, camps, setActiveCamp, isOnline, setIsOnline, syncQueue, triggerSyncFlush } = useCampOperations();

  return (
    <header className="bg-[#3D2123] text-[#F8F1EC] shadow-md sticky top-0 z-40 border-b border-[#2A1517]">
      {/* Top Utility Bar with National/Field Alignment */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          
          {/* Brand & Portal Title */}
          <div className="flex items-center gap-3">
            <button
              onClick={onNavigateHome}
              title="Return to Public Landing Page"
              className="flex items-center gap-2.5 text-left focus:outline-none group"
            >
              <div className="w-10 h-10 rounded-lg bg-[#EBD1C6]/20 border border-[#EBD1C6]/40 flex items-center justify-center text-[#EBD1C6] shadow-inner group-hover:scale-105 transition-transform">
                <Compass className="w-6 h-6 animate-pulse-subtle" />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <span className="font-bold text-lg sm:text-xl tracking-wide font-indic text-[#F8F1EC] group-hover:text-[#EBD1C6] transition-colors">{t('brand')}</span>
                  <span className="bg-[#EBD1C6]/20 text-[#EBD1C6] text-xs px-2 py-0.5 rounded font-semibold border border-[#EBD1C6]/30">
                    Govt / Field Edition
                  </span>
                </div>
                <p className="text-xs text-[#EBD1C6]/80 hidden sm:block font-indic">
                  {t('portal_title')} — {volunteer?.organization_name || 'Rural Secondary Guidance'}
                </p>
              </div>
            </button>
          </div>

          {/* Center / Active Camp Anchor Pill */}
          <div className="hidden md:flex items-center bg-[#2A1517] border border-[#EBD1C6]/20 px-3 py-1.5 rounded-lg text-xs">
            <MapPin className="w-4 h-4 text-[#EBD1C6] mr-2 shrink-0" />
            <span className="text-[#EBD1C6]/80 mr-1.5">{t('header.active_camp')}:</span>
            <select
              value={activeCamp?.camp_id || ''}
              onChange={(e) => setActiveCamp(e.target.value)}
              aria-label="Active Camp Selection"
              className="bg-transparent font-medium text-white focus:outline-none cursor-pointer pr-1"
            >
              {camps.map(c => (
                <option key={c.camp_id} value={c.camp_id} className="text-[#3D2123] bg-[#F8F1EC]">
                  {c.camp_name} ({c.village_town})
                </option>
              ))}
            </select>
          </div>

          {/* Right Controls: Network Status, Language Selector, User Profile */}
          <div className="flex items-center gap-2 sm:gap-3">
            
            {/* Public Home Button */}
            {onNavigateHome && (
              <button
                onClick={onNavigateHome}
                className="hidden lg:flex items-center gap-1.5 bg-[#2A1517] hover:bg-[#4E5458] text-[#EBD1C6] hover:text-white px-2.5 py-1 rounded text-xs font-semibold transition-colors border border-[#EBD1C6]/20"
                title="View Public Landing Page"
              >
                <Home className="w-3.5 h-3.5 text-[#EBD1C6]" />
                <span>Home</span>
              </button>
            )}

            {/* Network Status & Sync Action */}
            <div className="flex items-center gap-1.5">
              <button
                onClick={() => setIsOnline(!isOnline)}
                title="Click to toggle simulated online/offline field state"
                className={`flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-medium border transition-colors ${
                  isOnline 
                    ? 'bg-emerald-950/80 text-emerald-300 border-emerald-500/40 hover:bg-emerald-900/60' 
                    : 'bg-[#A83E28]/80 text-[#F8F1EC] border-[#A83E28] hover:bg-[#A83E28]'
                }`}
              >
                {isOnline ? <Wifi className="w-3.5 h-3.5" /> : <WifiOff className="w-3.5 h-3.5" />}
                <span className="hidden sm:inline">{isOnline ? t('header.online') : t('header.offline')}</span>
              </button>

              {syncQueue.length > 0 && (
                <button
                  onClick={triggerSyncFlush}
                  className="flex items-center gap-1 bg-[#A83E28] hover:bg-[#8F3320] text-white px-2 py-1 rounded text-xs font-bold shadow transition-all"
                  title="Click to sync pending records"
                >
                  <RefreshCw className="w-3 h-3 animate-spin" />
                  <span>{syncQueue.length} {t('header.sync_pending')}</span>
                </button>
              )}
            </div>

            {/* Universal Native Language Selector */}
            <div className="relative flex items-center bg-[#2A1517] border border-[#EBD1C6]/30 rounded-md px-2 py-1 text-xs">
              <Globe className="w-3.5 h-3.5 text-[#EBD1C6] mr-1.5 shrink-0" />
              <select
                value={uiLanguage}
                onChange={(e) => setLanguage(e.target.value)}
                aria-label="Interface Language Selection"
                className="bg-transparent text-white font-semibold cursor-pointer focus:outline-none font-indic"
              >
                {languageOptions.map(opt => (
                  <option key={opt.code} value={opt.code} className="text-[#3D2123] bg-[#F8F1EC] font-indic">
                    {opt.nativeLabel} ({opt.code.toUpperCase()})
                  </option>
                ))}
              </select>
            </div>

            {/* Volunteer Identity / Credential Trigger */}
            {isAuthenticated ? (
              <div className="flex items-center gap-1 sm:gap-2">
                <button
                  onClick={() => setIsCredentialModalOpen(true)}
                  className="flex items-center gap-1.5 bg-[#2A1517] hover:bg-[#4E5458] text-[#EBD1C6] px-2.5 py-1 rounded border border-[#EBD1C6]/30 text-xs font-medium transition-colors"
                  title="View official volunteer credential badge"
                >
                  <Award className="w-3.5 h-3.5 text-[#EBD1C6]" />
                  <span className="hidden lg:inline">{volunteer?.volunteer_id}</span>
                </button>

                <button
                  onClick={logout}
                  className="p-1 text-[#EBD1C6] hover:text-rose-300 hover:bg-[#2A1517] rounded transition-colors"
                  title={t('header.logout')}
                >
                  <LogOut className="w-4 h-4" />
                </button>
              </div>
            ) : (
              <div className="flex items-center gap-1.5">
                <button
                  onClick={() => openAuthModal('login')}
                  className="bg-[#4E5458] hover:bg-[#2A1517] text-[#F8F1EC] px-2.5 py-1 rounded text-xs font-medium border border-[#EBD1C6]/30 font-indic"
                >
                  {t('header.login')}
                </button>
                <button
                  onClick={() => openAuthModal('register')}
                  className="bg-[#A83E28] hover:bg-[#8F3320] text-white px-2.5 py-1 rounded text-xs font-bold font-indic"
                >
                  {t('header.register')}
                </button>
              </div>
            )}

          </div>

        </div>
      </div>
    </header>
  );
}
