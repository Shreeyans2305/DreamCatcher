import React from 'react';
import { useLanguage } from '../context/LanguageContext';
import StudentDirectoryTable from '../components/students/StudentDirectoryTable';
import { Users } from 'lucide-react';

export default function DirectoryView({ onSelectStudentForCase, onLaunchGuidance }) {
  const { t } = useLanguage();

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      
      {/* Header */}
      <div className="card-soft p-6 bg-white">
        <div className="flex items-center gap-2.5">
          <div className="w-9 h-9 rounded-[12px] bg-indigo-50 text-indigo-600 flex items-center justify-center">
            <Users className="w-5 h-5" />
          </div>
          <h1 className="text-xl font-black text-neutral-900 tracking-tight">{t('directory.title')}</h1>
        </div>
        <p className="text-xs text-neutral-500 mt-1 font-normal">
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
