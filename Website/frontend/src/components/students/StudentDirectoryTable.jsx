import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { Search, Filter, Sparkles, FileText, CheckCircle2, AlertCircle, Eye, User } from 'lucide-react';

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
      <div className="bg-white rounded-xl p-4 border border-slate-200 shadow-xs flex flex-col md:flex-row items-center gap-3">
        
        <div className="relative flex-1 w-full">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={t('directory.search_placeholder')}
            className="w-full pl-9 pr-3 py-2 text-xs border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
          />
        </div>

        <div className="flex items-center gap-2 w-full md:w-auto">
          {/* Camp filter */}
          <select
            value={selectedCampFilter}
            onChange={(e) => setSelectedCampFilter(e.target.value)}
            className="flex-1 md:flex-none text-xs border border-slate-300 rounded-lg px-3 py-2 bg-white text-slate-700 font-medium font-indic focus:ring-2 focus:ring-[#173F6B]"
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
            className="flex-1 md:flex-none text-xs border border-slate-300 rounded-lg px-3 py-2 bg-white text-slate-700 font-medium font-indic focus:ring-2 focus:ring-[#173F6B]"
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
      <div className="bg-white rounded-xl border border-slate-200 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-slate-100/80 border-b border-slate-200 text-[11px] font-bold text-slate-700 uppercase tracking-wider font-indic">
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
            <tbody className="divide-y divide-slate-200">
              {filteredStudents.length === 0 ? (
                <tr>
                  <td colSpan={8} className="p-8 text-center text-slate-500 font-indic">
                    No matching student records found.
                  </td>
                </tr>
              ) : (
                filteredStudents.map((stu) => {
                  const notesCount = (stu.case_notes || []).length;
                  const isSynced = stu.sync_status === 'synced';

                  return (
                    <tr key={stu.student_record_id} className="hover:bg-slate-50/80 transition-colors">
                      
                      {/* Name & Age */}
                      <td className="p-3.5">
                        <div className="font-bold text-slate-900 font-indic">{stu.full_name}</div>
                        <div className="text-[10px] text-slate-400 font-mono">
                          Ph: {stu.guardian_contact_number || 'N/A'} • {stu.age_years} Yrs
                        </div>
                      </td>

                      {/* Location & Camp */}
                      <td className="p-3.5 font-indic font-medium text-slate-700">
                        <div>{stu.village_location}</div>
                        <div className="text-[10px] text-slate-400 truncate max-w-[140px]">
                          {stu.camp_name}
                        </div>
                      </td>

                      {/* Education */}
                      <td className="p-3.5 font-indic font-medium text-slate-800">
                        {stu.education_level_label}
                      </td>

                      {/* Category */}
                      <td className="p-3.5 font-indic">
                        <span className="bg-slate-100 text-slate-800 text-[10px] font-semibold px-2 py-0.5 rounded border border-slate-200">
                          {stu.category_label || stu.category}
                        </span>
                      </td>

                      {/* Language */}
                      <td className="p-3.5 uppercase font-bold text-slate-700">
                        {stu.preferred_language}
                      </td>

                      {/* Notes Count */}
                      <td className="p-3.5">
                        {notesCount > 0 ? (
                          <span className="inline-flex items-center gap-1 bg-emerald-50 text-emerald-800 text-[10px] font-bold px-2 py-0.5 rounded-full border border-emerald-200">
                            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                            <span>{notesCount} Session(s)</span>
                          </span>
                        ) : (
                          <span className="text-[10px] text-slate-400 font-medium font-indic">
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
                          className="px-2.5 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-md font-semibold text-xs border border-slate-300 font-indic transition-colors"
                          title="Inspect student history and notes"
                        >
                          <Eye className="w-3.5 h-3.5 inline mr-1 text-slate-500" />
                          <span>{t('directory.view_case')}</span>
                        </button>
                        
                        <button
                          onClick={() => onLaunchGuidance(stu)}
                          className="px-2.5 py-1.5 bg-[#173F6B] hover:bg-[#0D2E50] text-white rounded-md font-bold text-xs shadow-xs font-indic transition-colors"
                          title="Start guidance session"
                        >
                          <Sparkles className="w-3.5 h-3.5 inline mr-1 text-amber-400" />
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
