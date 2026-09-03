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
    <nav className="bg-white border-b border-[#EBD1C6] sticky top-16 z-30 shadow-xs">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex space-x-1 sm:space-x-4 overflow-x-auto py-2 scrollbar-none">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => onSelectTab(tab.id)}
                className={`flex items-center gap-2 px-3.5 py-2 rounded-lg text-sm font-semibold whitespace-nowrap transition-all touch-target ${
                  isActive
                    ? 'bg-[#3D2123] text-[#F8F1EC] shadow-sm'
                    : 'text-[#4E5458] hover:text-[#3D2123] hover:bg-[#F8F1EC]'
                } ${tab.highlight && !isActive ? 'border border-[#EBD1C6] text-[#A83E28] bg-[#F8F1EC]' : ''}`}
              >
                <Icon className={`w-4 h-4 shrink-0 ${isActive ? 'text-[#EBD1C6]' : 'text-[#4E5458]'}`} />
                <span className="font-indic">{tab.label}</span>
                {tab.badge && (
                  <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                    isActive ? 'bg-[#EBD1C6] text-[#3D2123] font-bold' : 'bg-[#F8F1EC] text-[#3D2123] border border-[#EBD1C6]'
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
