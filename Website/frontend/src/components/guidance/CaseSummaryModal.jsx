import React, { useState } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Award, CheckCircle2, FileText, ArrowRight, X, Sparkles, UserPlus } from 'lucide-react';

export default function CaseSummaryModal({ caseNote, student, onSave, onClose, onNewStudent }) {
  const { t } = useLanguage();
  const [editedSummary, setEditedSummary] = useState(caseNote?.summary || '');

  if (!caseNote) return null;

  return (
    <div className="fixed inset-0 bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full overflow-hidden border border-slate-200 my-8">
        
        {/* Header */}
        <div className="bg-[#173F6B] text-white p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <FileText className="w-6 h-6 text-amber-400" />
            <div>
              <h3 className="font-bold text-base font-indic">{t('guidance.session_summary_title')}</h3>
              <p className="text-xs text-sky-100 font-indic">
                Student: {student?.full_name} ({student?.education_level_label})
              </p>
            </div>
          </div>
          <button onClick={onClose} className="text-sky-200 hover:text-white p-1">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 space-y-5 text-xs">
          
          {/* Summary Note Textarea */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
              Counselor Session Summary (CommCare Case Note)
            </label>
            <textarea
              rows={3}
              value={editedSummary}
              onChange={(e) => setEditedSummary(e.target.value)}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
            />
          </div>

          {/* Recommended Pathways */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2 font-indic flex items-center gap-1.5">
              <Award className="w-4 h-4 text-[#173F6B]" />
              <span>{t('guidance.recommended_pathways')}</span>
            </label>
            <div className="space-y-1.5">
              {caseNote.recommended_pathways.map((path, idx) => (
                <div key={idx} className="bg-sky-50 border border-sky-200 p-2.5 rounded-lg text-xs font-semibold text-slate-900 font-indic flex items-start gap-2">
                  <span className="w-5 h-5 rounded-full bg-[#173F6B] text-white flex items-center justify-center shrink-0 text-[10px]">
                    {idx + 1}
                  </span>
                  <span>{path}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Eligible Schemes */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2 font-indic flex items-center gap-1.5">
              <CheckCircle2 className="w-4 h-4 text-emerald-600" />
              <span>{t('guidance.eligible_schemes')}</span>
            </label>
            <div className="space-y-1.5">
              {caseNote.eligible_schemes.map((scheme, idx) => (
                <div key={idx} className="bg-emerald-50 border border-emerald-200 p-2 rounded-lg text-xs text-emerald-900 font-indic font-medium flex items-center gap-2">
                  <span className="w-2 h-2 rounded-full bg-emerald-600 shrink-0" />
                  <span>{scheme}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Action Items */}
          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2 font-indic flex items-center gap-1.5">
              <ArrowRight className="w-4 h-4 text-amber-600" />
              <span>{t('guidance.action_items')}</span>
            </label>
            <div className="space-y-1.5">
              {caseNote.action_items.map((item, idx) => (
                <div key={idx} className="bg-amber-50/80 border border-amber-200 p-2 rounded-lg text-xs text-slate-800 font-indic flex items-start gap-2">
                  <span className="font-bold text-amber-700 shrink-0">•</span>
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Actions */}
          <div className="pt-4 border-t border-slate-200 flex flex-col sm:flex-row items-center gap-3">
            <button
              onClick={() => {
                onSave({ ...caseNote, summary: editedSummary });
              }}
              className="w-full sm:flex-1 py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-lg shadow flex items-center justify-center gap-1.5 transition-colors touch-target font-indic"
            >
              <CheckCircle2 className="w-4 h-4 text-amber-400" />
              <span>{t('guidance.save_case_note')}</span>
            </button>
            <button
              onClick={() => {
                onSave({ ...caseNote, summary: editedSummary });
                onNewStudent();
              }}
              className="w-full sm:flex-1 py-3 bg-amber-500 hover:bg-amber-600 text-slate-950 text-xs font-bold rounded-lg shadow-md flex items-center justify-center gap-1.5 transition-colors touch-target font-indic"
            >
              <UserPlus className="w-4 h-4 text-slate-950" />
              <span>{t('guidance.new_student')}</span>
            </button>
          </div>

        </div>

      </div>
    </div>
  );
}
