import React, { useState } from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useCampOperations } from '../context/CampOperationsContext';
import CampCard from '../components/camps/CampCard';
import CreateCampModal from '../components/camps/CreateCampModal';
import { Tent, Plus, Filter } from 'lucide-react';

export default function CampsView({ onSelectIntakeForCamp }) {
  const { t } = useLanguage();
  const { camps, setIsCreateCampModalOpen } = useCampOperations();
  const [statusFilter, setStatusFilter] = useState('all');

  const filteredCamps = camps.filter(camp => {
    if (statusFilter === 'all') return true;
    return camp.status === statusFilter;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      
      {/* Header & New Camp CTA */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white p-6 rounded-2xl border border-slate-200 shadow-xs">
        <div>
          <div className="flex items-center gap-2">
            <Tent className="w-6 h-6 text-[#173F6B]" />
            <h1 className="text-xl font-bold text-slate-900 font-indic">{t('camps.title')}</h1>
          </div>
          <p className="text-xs text-slate-600 font-indic mt-1">
            {t('camps.subtitle')}
          </p>
        </div>

        <button
          onClick={() => setIsCreateCampModalOpen(true)}
          className="px-5 py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-xl shadow flex items-center justify-center gap-2 transition-colors touch-target font-indic self-start sm:self-auto"
        >
          <Plus className="w-4 h-4 text-amber-400" />
          <span>{t('camps.new_camp')}</span>
        </button>
      </div>

      {/* Filter Tabs */}
      <div className="flex gap-2 overflow-x-auto pb-1">
        {[
          { id: 'all', label: t('camps.filter_all') },
          { id: 'upcoming', label: t('camps.filter_upcoming') },
          { id: 'ongoing', label: t('camps.filter_ongoing') },
          { id: 'completed', label: t('camps.filter_completed') }
        ].map(filter => (
          <button
            key={filter.id}
            onClick={() => setStatusFilter(filter.id)}
            className={`px-4 py-2 rounded-lg text-xs font-bold transition-colors font-indic touch-target ${
              statusFilter === filter.id
                ? 'bg-[#173F6B] text-white shadow-xs'
                : 'bg-white text-slate-600 hover:bg-slate-100 border border-slate-200'
            }`}
          >
            {filter.label}
          </button>
        ))}
      </div>

      {/* Camps Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {filteredCamps.map(camp => (
          <CampCard
            key={camp.camp_id}
            camp={camp}
            onSelectIntake={onSelectIntakeForCamp}
          />
        ))}
      </div>

      <CreateCampModal />

    </div>
  );
}
