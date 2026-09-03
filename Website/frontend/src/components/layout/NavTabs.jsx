import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { 
  LayoutDashboard, 
  Tent, 
  UserPlus, 
  Users, 
  Sparkles 
} from 'lucide-react';

export default function NavTabs({ activeTab, onSelectTab }) {
  const { t } = useLanguage();
  const { selectedStudentForGuidance } = useCampOperations();

  const tabs = [
    { id: 'dashboard', label: t('nav.dashboard'), icon: LayoutDashboard },
    { id: 'camps', label: t('nav.camps'), icon: Tent },
    { id: 'intake', label: t('nav.intake'), icon: UserPlus, highlight: true },
    { id: 'directory', label: t('nav.directory'), icon: Users },
    { 
      id: 'guidance', 
      label: t('nav.guidance'), 
      icon: Sparkles,
      badge: selectedStudentForGuidance ? selectedStudentForGuidance.full_name : null
    },
  ];

  return (
    <nav className="bg-[#FAF7F2]/90 backdrop-blur-md border-b border-[#E5DED4] sticky top-16 z-30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex space-x-1.5 sm:space-x-2 overflow-x-auto py-2.5 scrollbar-none">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => onSelectTab(tab.id)}
                className={`flex items-center gap-2 px-4 py-2 rounded-full text-xs sm:text-sm font-medium whitespace-nowrap transition-all cursor-pointer ${
                  isActive
                    ? 'bg-[#222222] text-[#FAF7F2] shadow-xs'
                    : 'text-[#665D52] hover:text-[#1F1F1F] hover:bg-[#F4EFE6]'
                } ${tab.highlight && !isActive ? 'border border-[#DDD3C5] text-[#1F1F1F] bg-[#F4EFE6]/60' : ''}`}
              >
                <Icon className={`w-4 h-4 shrink-0 ${isActive ? 'text-[#FAF7F2]' : 'text-[#8C8276]'}`} />
                <span className="font-serif-zen font-medium">{tab.label}</span>
                {tab.badge && (
                  <span className={`text-[11px] px-2 py-0.5 rounded-full font-serif-zen ${
                    isActive ? 'bg-[#3A3530] text-[#FAF7F2]' : 'bg-[#EAE2D5] text-[#3A3530] border border-[#DDD3C5]'
                  }`}>
                    {tab.badge}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </nav>
  );
}
