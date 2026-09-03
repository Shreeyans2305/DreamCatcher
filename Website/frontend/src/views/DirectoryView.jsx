import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import StudentDirectoryTable from '../components/students/StudentDirectoryTable';
import { Users } from 'lucide-react';

export default function DirectoryView({ onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      
      {/* Header */}
      <div className="bg-white p-6 rounded-2xl border border-slate-200 shadow-xs">
        <div className="flex items-center gap-2">
          <Users className="w-6 h-6 text-[#173F6B]" />
          <h1 className="text-xl font-bold text-slate-900 font-indic">{t('directory.title')}</h1>
        </div>
        <p className="text-xs text-slate-600 font-indic mt-1">
          {t('directory.subtitle')}
        </p>
      </div>

      {/* Directory Table */}
      <StudentDirectoryTable
        onSelectStudentForCase={onSelectStudentForCase}
        onLaunchGuidance={onLaunchGuidance}
      />

    </div>
  );
}
