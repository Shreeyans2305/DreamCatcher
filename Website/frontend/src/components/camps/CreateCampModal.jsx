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
    <div className="fixed inset-0 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white rounded-xl shadow-2xl max-w-lg w-full overflow-hidden border border-slate-200 my-8">
        
        {/* Header */}
        <div className="bg-[#173F6B] text-white p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <Tent className="w-6 h-6 text-amber-400" />
            <h2 className="text-lg font-bold font-indic">{t('camps.create_modal_title')}</h2>
          </div>
          <button 
            onClick={() => setIsCreateCampModalOpen(false)}
            className="text-sky-200 hover:text-white p-1 rounded-md"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
              {t('camps.camp_name')} *
            </label>
            <input
              type="text"
              required
              value={formData.camp_name}
              onChange={(e) => setFormData({ ...formData, camp_name: e.target.value })}
              placeholder="e.g. Dahiwadi High School Career Guidance Camp"
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('camps.village')} *
              </label>
              <input
                type="text"
                required
                value={formData.village_town}
                onChange={(e) => setFormData({ ...formData, village_town: e.target.value })}
                placeholder="e.g. Dahiwadi"
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('camps.district')} *
              </label>
              <input
                type="text"
                required
                value={formData.district}
                onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                placeholder="e.g. Satara"
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('camps.date')} *
              </label>
              <input
                type="date"
                required
                value={formData.scheduled_date}
                onChange={(e) => setFormData({ ...formData, scheduled_date: e.target.value })}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                Start Time
              </label>
              <input
                type="time"
                value={formData.start_time}
                onChange={(e) => setFormData({ ...formData, start_time: e.target.value })}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                End Time
              </label>
              <input
                type="time"
                value={formData.end_time}
                onChange={(e) => setFormData({ ...formData, end_time: e.target.value })}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white font-bold text-sm rounded-lg shadow-md flex items-center justify-center gap-2 transition-colors touch-target mt-4"
          >
            <Plus className="w-4 h-4 text-amber-400" />
            <span className="font-indic">{t('camps.save_camp')}</span>
          </button>
        </form>

      </div>
    </div>
  );
}
