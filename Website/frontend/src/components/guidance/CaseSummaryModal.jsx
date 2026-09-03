import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Award, CheckCircle2, FileText, ArrowRight, X, UserPlus } from 'lucide-react';

export default function CaseSummaryModal({ caseNote, student, onSave, onClose, onNewStudent }) {
  const { t } = useLanguage();
  const [editedSummary, setEditedSummary] = useState(caseNote?.summary || '');

  if (!caseNote) return null;

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white rounded-[20px] shadow-2xl max-w-2xl w-full overflow-hidden border border-black/[0.05] my-8">
        
        {/* Header */}
        <div className="p-5 sm:p-6 border-b border-black/[0.05] bg-white flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-[12px] bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-bold text-base text-neutral-900">{t('guidance.session_summary_title')}</h3>
              <p className="text-xs text-neutral-500 font-normal">
                Student: {student?.full_name} ({student?.education_level_label})
              </p>
            </div>
          </div>
          <button onClick={onClose} className="text-neutral-400 hover:text-black p-1.5 rounded-full hover:bg-neutral-100 transition-colors cursor-pointer">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 space-y-5 text-xs">
          
          {/* Summary Note Textarea */}
          <div>
            <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-1.5">
              Counselor Session Summary (CommCare Case Note)
            </label>
            <textarea
              rows={3}
              value={editedSummary}
              onChange={(e) => setEditedSummary(e.target.value)}
              className="w-full px-4 py-3 text-sm border border-neutral-200 rounded-[14px] focus:ring-2 focus:ring-black focus:outline-none font-medium bg-[#F7F6F4]/40"
            />
          </div>

          {/* Recommended Pathways */}
          <div>
            <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-2 flex items-center gap-1.5">
              <Award className="w-4 h-4 text-neutral-900" />
              <span>{t('guidance.recommended_pathways')}</span>
            </label>
            <div className="space-y-2">
              {caseNote.recommended_pathways.map((path, idx) => (
                <div key={idx} className="bg-[#F7F6F4] border border-black/[0.04] p-3 rounded-[12px] text-xs font-semibold text-neutral-900 flex items-start gap-2.5">
                  <span className="w-5 h-5 rounded-full bg-[#111111] text-white flex items-center justify-center shrink-0 text-[10px] font-bold">
                    {idx + 1}
                  </span>
                  <span>{path}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Eligible Schemes */}
          <div>
            <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-2 flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4 text-emerald-600" />
              <span>{t('guidance.eligible_schemes')}</span>
            </label>
            <div className="space-y-1.5">
              {caseNote.eligible_schemes.map((scheme, idx) => (
                <div key={idx} className="bg-emerald-50 border border-emerald-200 p-2.5 rounded-[10px] text-xs text-emerald-900 font-medium flex items-center gap-2">
                  <span className="w-2 h-2 rounded-full bg-emerald-600 shrink-0" />
                  <span>{scheme}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Action Items */}
          <div>
            <label className="block text-xs font-semibold text-neutral-700 uppercase tracking-wider mb-2 flex items-center gap-1.5">
              <ArrowRight className="w-4 h-4 text-neutral-900" />
              <span>{t('guidance.action_items')}</span>
            </label>
            <div className="space-y-1.5">
              {caseNote.action_items.map((item, idx) => (
                <div key={idx} className="bg-neutral-50 border border-black/[0.04] p-2.5 rounded-[10px] text-xs text-neutral-800 flex items-start gap-2">
                  <span className="font-bold text-neutral-900 shrink-0">•</span>
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Actions */}
          <div className="pt-4 border-t border-black/[0.05] flex flex-col sm:flex-row items-center gap-3">
            <button
              onClick={() => {
                onSave({ ...caseNote, summary: editedSummary });
              }}
              className="btn-pill-secondary w-full sm:flex-1 py-3 text-xs font-semibold gap-1.5"
            >
              <CheckCircle2 className="w-4 h-4" />
              <span>{t('guidance.save_case_note')}</span>
            </button>
            <button
              onClick={() => {
                onSave({ ...caseNote, summary: editedSummary });
                onNewStudent();
              }}
              className="btn-pill-black w-full sm:flex-1 py-3 text-xs font-semibold gap-1.5 shadow-sm"
            >
              <UserPlus className="w-4 h-4" />
              <span>{t('guidance.new_student')}</span>
            </button>
          </div>

        </div>

      </div>
    </div>
  );
}
