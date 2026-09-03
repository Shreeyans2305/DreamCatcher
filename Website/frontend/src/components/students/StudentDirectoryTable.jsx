import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { Search, Sparkles, CheckCircle2, Eye, User } from 'lucide-react';

export default function StudentDirectoryTable({ onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();
  const { students, camps } = useCampOperations();

  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCampFilter, setSelectedCampFilter] = useState('all');
  const [selectedCategoryFilter, setSelectedCategoryFilter] = useState('all');

  const filteredStudents = students.filter(student => {
    const matchesSearch = 
      student.full_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      student.village_location.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (student.guardian_contact_number && student.guardian_contact_number.includes(searchQuery));
    
    const matchesCamp = selectedCampFilter === 'all' || student.camp_id === selectedCampFilter;
    const matchesCategory = selectedCategoryFilter === 'all' || student.category === selectedCategoryFilter;

    return matchesSearch && matchesCamp && matchesCategory;
  });

  return (
    <div className="space-y-4">
      
      {/* Search & Filter Bar */}
      <div className="card-soft p-4 bg-white flex flex-col md:flex-row items-center gap-3">
        
        <div className="relative flex-1 w-full">
          <Search className="w-4 h-4 text-neutral-400 absolute left-3.5 top-3" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={t('directory.search_placeholder')}
            className="w-full pl-10 pr-4 py-2 text-xs border border-neutral-200 rounded-full focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
          />
        </div>

        <div className="flex items-center gap-2 w-full md:w-auto">
          {/* Camp filter */}
          <select
            value={selectedCampFilter}
            onChange={(e) => setSelectedCampFilter(e.target.value)}
            className="flex-1 md:flex-none text-xs border border-neutral-200 rounded-full px-3.5 py-2 bg-white text-neutral-700 font-medium focus:ring-2 focus:ring-black focus:outline-none cursor-pointer"
          >
            <option value="all">All Camps ({camps.length})</option>
            {camps.map(c => (
              <option key={c.camp_id} value={c.camp_id}>{c.camp_name}</option>
            ))}
          </select>

          {/* Category filter */}
          <select
            value={selectedCategoryFilter}
            onChange={(e) => setSelectedCategoryFilter(e.target.value)}
            className="flex-1 md:flex-none text-xs border border-neutral-200 rounded-full px-3.5 py-2 bg-white text-neutral-700 font-medium focus:ring-2 focus:ring-black focus:outline-none cursor-pointer"
          >
            <option value="all">All Categories</option>
            <option value="cat_sc">SC (Scheduled Caste)</option>
            <option value="cat_st">ST (Scheduled Tribe)</option>
            <option value="cat_obc">OBC</option>
            <option value="cat_ews">EWS</option>
            <option value="cat_general">General</option>
          </select>
        </div>

      </div>

      {/* Table Container */}
      <div className="card-soft border border-black/[0.04] bg-white overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-neutral-50 border-b border-black/[0.05] text-[11px] font-bold text-neutral-700 uppercase tracking-wider">
                <th className="p-3.5">{t('directory.col_name')}</th>
                <th className="p-3.5">{t('directory.col_village')}</th>
                <th className="p-3.5">{t('directory.col_education')}</th>
                <th className="p-3.5">{t('directory.col_category')}</th>
                <th className="p-3.5">{t('directory.col_language')}</th>
                <th className="p-3.5">{t('directory.col_sessions')}</th>
                <th className="p-3.5">{t('directory.col_status')}</th>
                <th className="p-3.5 text-right">{t('directory.col_actions')}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-black/[0.04]">
              {filteredStudents.length === 0 ? (
                <tr>
                  <td colSpan={8} className="p-8 text-center text-neutral-400">
                    No matching student records found.
                  </td>
                </tr>
              ) : (
                filteredStudents.map((stu) => {
                  const notesCount = (stu.case_notes || []).length;
                  const isSynced = stu.sync_status === 'synced';

                  return (
                    <tr key={stu.student_record_id} className="hover:bg-neutral-50/70 transition-colors">
                      
                      {/* Name & Phone */}
                      <td className="p-3.5">
                        <div className="flex items-center gap-2.5">
                          <div className="w-7 h-7 rounded-full bg-neutral-100 text-neutral-800 flex items-center justify-center font-bold text-[11px] shrink-0">
                            {stu.full_name?.charAt(0) || 'S'}
                          </div>
                          <div>
                            <div className="font-bold text-neutral-900">{stu.full_name}</div>
                            <div className="text-[10px] text-neutral-400 font-normal">{stu.guardian_contact_number || 'No contact'}</div>
                          </div>
                        </div>
                      </td>

                      {/* Village */}
                      <td className="p-3.5 text-neutral-600 font-medium">
                        {stu.village_location}
                      </td>

                      {/* Education Level */}
                      <td className="p-3.5 text-neutral-600">
                        {stu.education_level_label}
                      </td>

                      {/* Category */}
                      <td className="p-3.5">
                        <span className="text-[10px] font-bold bg-neutral-100 text-neutral-800 px-2.5 py-0.5 rounded-full border border-black/[0.04]">
                          {stu.category_label}
                        </span>
                      </td>

                      {/* Language */}
                      <td className="p-3.5 uppercase font-bold text-neutral-700">
                        {stu.preferred_language}
                      </td>

                      {/* Notes Count */}
                      <td className="p-3.5">
                        {notesCount > 0 ? (
                          <span className="inline-flex items-center gap-1 bg-emerald-50 text-emerald-800 text-[10px] font-bold px-2.5 py-0.5 rounded-full border border-emerald-200">
                            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                            <span>{notesCount} Session(s)</span>
                          </span>
                        ) : (
                          <span className="text-[10px] text-neutral-400 font-medium">
                            Pending Session
                          </span>
                        )}
                      </td>

                      {/* Sync Status */}
                      <td className="p-3.5">
                        {isSynced ? (
                          <span className="text-emerald-700 text-[11px] font-semibold flex items-center gap-1">
                            <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" />
                            <span>Synced</span>
                          </span>
                        ) : (
                          <span className="text-amber-700 text-[11px] font-bold flex items-center gap-1">
                            <span className="w-1.5 h-1.5 rounded-full bg-amber-600 animate-ping" />
                            <span>Local Draft</span>
                          </span>
                        )}
                      </td>

                      {/* Action Buttons */}
                      <td className="p-3.5 text-right space-x-1.5 whitespace-nowrap">
                        <button
                          onClick={() => onSelectStudentForCase(stu)}
                          className="btn-pill-secondary px-3 py-1 text-xs font-semibold gap-1"
                          title="Inspect student history and notes"
                        >
                          <Eye className="w-3 h-3 text-neutral-500" />
                          <span>{t('directory.view_case')}</span>
                        </button>
                        
                        <button
                          onClick={() => onLaunchGuidance(stu)}
                          className="btn-pill-black px-3 py-1 text-xs font-semibold gap-1 shadow-xs"
                          title="Start guidance session"
                        >
                          <Sparkles className="w-3 h-3 text-white" />
                          <span>{t('directory.start_guidance')}</span>
                        </button>
                      </td>

                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

    </div>
  );
}
