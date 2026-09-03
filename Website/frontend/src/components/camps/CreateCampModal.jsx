import React, { useState } from 'react';
import { useCampOperations } from '../../context/CampOperationsContext';
import { useLanguage } from '../../context/LanguageContext';
import { Tent, X, Plus } from 'lucide-react';

export default function CreateCampModal() {
  const { isCreateCampModalOpen, setIsCreateCampModalOpen, createCamp } = useCampOperations();
  const { t } = useLanguage();

  const [formData, setFormData] = useState({
    camp_name: '',
    village_town: '',
    district: 'Satara',
    state: 'Maharashtra',
    scheduled_date: new Date().toISOString().split('T')[0],
    start_time: '09:30',
    end_time: '16:30'
  });

  if (!isCreateCampModalOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    createCamp(formData);
  };

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white rounded-[20px] shadow-2xl max-w-lg w-full overflow-hidden border border-black/[0.05] my-8">
        
        {/* Header */}
        <div className="p-5 sm:p-6 border-b border-black/[0.05] bg-white flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-[12px] bg-amber-50 text-amber-600 flex items-center justify-center font-bold">
              <Tent className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-neutral-900">{t('camps.create_modal_title')}</h2>
              <p className="text-xs text-neutral-500 font-normal">Organize a new school / village career guidance hub</p>
            </div>
          </div>
          <button 
            onClick={() => setIsCreateCampModalOpen(false)}
            className="text-neutral-400 hover:text-black p-1.5 rounded-full hover:bg-neutral-100 transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div>
            <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
              {t('camps.camp_name')} *
            </label>
            <input
              type="text"
              required
              value={formData.camp_name}
              onChange={(e) => setFormData({ ...formData, camp_name: e.target.value })}
              placeholder="e.g. Dahiwadi High School Career Guidance Camp"
              className="w-full px-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
                {t('camps.village')} *
              </label>
              <input
                type="text"
                required
                value={formData.village_town}
                onChange={(e) => setFormData({ ...formData, village_town: e.target.value })}
                placeholder="e.g. Dahiwadi"
                className="w-full px-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
                {t('camps.district')} *
              </label>
              <input
                type="text"
                required
                value={formData.district}
                onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                placeholder="e.g. Satara"
                className="w-full px-4 py-2.5 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <div>
              <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
                {t('camps.date')} *
              </label>
              <input
                type="date"
                required
                value={formData.scheduled_date}
                onChange={(e) => setFormData({ ...formData, scheduled_date: e.target.value })}
                className="w-full px-4 py-2 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
                Start Time
              </label>
              <input
                type="time"
                value={formData.start_time}
                onChange={(e) => setFormData({ ...formData, start_time: e.target.value })}
                className="w-full px-4 py-2 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
                End Time
              </label>
              <input
                type="time"
                value={formData.end_time}
                onChange={(e) => setFormData({ ...formData, end_time: e.target.value })}
                className="w-full px-4 py-2 text-sm border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
              />
            </div>
          </div>

          <button
            type="submit"
            className="btn-pill-black w-full py-3 text-sm font-semibold gap-2 mt-4 shadow-sm"
          >
            <Plus className="w-4 h-4 text-white" />
            <span>{t('camps.save_camp')}</span>
          </button>
        </form>

      </div>
    </div>
  );
}
