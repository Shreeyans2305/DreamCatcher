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
      <div className="card-soft p-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white">
        <div>
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-[12px] bg-amber-50 text-amber-600 flex items-center justify-center">
              <Tent className="w-5 h-5" />
            </div>
            <h1 className="text-xl font-black text-neutral-900 tracking-tight">{t('camps.title')}</h1>
          </div>
          <p className="text-xs text-neutral-500 mt-1 font-normal">
            {t('camps.subtitle')}
          </p>
        </div>

        <button
          onClick={() => setIsCreateCampModalOpen(true)}
          className="btn-pill-black px-5 py-2.5 text-xs font-semibold gap-2 self-start sm:self-auto"
        >
          <Plus className="w-4 h-4 text-white" />
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
            className={`px-4 py-2 rounded-full text-xs font-semibold transition-all cursor-pointer ${
              statusFilter === filter.id
                ? 'bg-black text-white shadow-xs'
                : 'bg-white text-neutral-600 hover:bg-neutral-100 border border-black/[0.04]'
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
