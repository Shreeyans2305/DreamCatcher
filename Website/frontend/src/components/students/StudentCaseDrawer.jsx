import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { X, Sparkles, FileText, ArrowRight, CheckCircle2 } from 'lucide-react';

export default function StudentCaseDrawer({ student, onClose, onLaunchGuidance }) {
  const { t } = useLanguage();

  if (!student) return null;

  const notes = student.case_notes || [];

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-xs flex justify-end z-50 transition-opacity">
      <div className="bg-white w-full max-w-xl h-full shadow-2xl flex flex-col border-l border-black/[0.05] overflow-hidden">
        
        {/* Drawer Header */}
        <div className="p-5 sm:p-6 border-b border-black/[0.05] bg-white flex items-start justify-between">
          <div>
            <div className="flex items-center gap-2.5">
              <span className="font-bold text-lg text-neutral-900">{student.full_name}</span>
              <span className="bg-neutral-100 text-neutral-800 text-[10px] font-bold px-2.5 py-0.5 rounded-full uppercase border border-black/[0.04]">
                {student.sync_status === 'synced' ? 'Synced' : 'Local Draft'}
              </span>
            </div>
            <p className="text-xs text-neutral-500 mt-1 font-normal">
              Camp: {student.camp_name || 'Assigned Camp'}
            </p>
          </div>
          <button 
            onClick={onClose} 
            className="text-neutral-400 hover:text-black p-1.5 rounded-full hover:bg-neutral-100 transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Drawer Content */}
        <div className="flex-1 overflow-y-auto p-5 sm:p-6 space-y-6">
          
          {/* Demographic & Contact Details */}
          <div className="bg-[#F7F6F4]/60 rounded-[16px] p-4 border border-black/[0.04] space-y-2.5 text-xs">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Age / DOB</span>
                <span className="font-bold text-neutral-900">{student.age_years} Yrs ({student.date_of_birth || 'N/A'})</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Location</span>
                <span className="font-semibold text-neutral-900">{student.village_location}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 border-t border-black/[0.04] pt-2">
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Education Stage</span>
                <span className="font-semibold text-neutral-900">{student.education_level_label}</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Social Category</span>
                <span className="font-semibold text-neutral-900">{student.category_label}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 border-t border-black/[0.04] pt-2">
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Guardian Phone</span>
                <span className="font-semibold text-neutral-900">{student.guardian_contact_number}</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Preferred Language</span>
                <span className="font-semibold text-neutral-900 uppercase">{student.preferred_language}</span>
              </div>
            </div>

            {student.aspirations && (
              <div className="border-t border-black/[0.04] pt-2">
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Stated Aspirations</span>
                <p className="font-medium text-neutral-800 mt-0.5">{student.aspirations}</p>
              </div>
            )}
          </div>

          {/* Longitudinal Case Notes Section (CommCare pattern) */}
          <div>
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-neutral-900" />
                <h4 className="font-bold text-sm text-neutral-900">Guidance Case History ({notes.length})</h4>
              </div>
            </div>

            {notes.length === 0 ? (
              <div className="border border-dashed border-neutral-200 rounded-[16px] p-6 text-center text-xs text-neutral-400">
                No counseling session notes recorded yet for this student.
              </div>
            ) : (
              <div className="space-y-4">
                {notes.map((note, idx) => (
                  <div key={note.case_note_id || idx} className="card-soft p-4 bg-white space-y-3">
                    
                    <div className="flex items-center justify-between border-b border-black/[0.04] pb-2">
                      <span className="text-[11px] font-bold text-neutral-900">
                        Counseling Session #{notes.length - idx}
                      </span>
                      <span className="text-[10px] text-neutral-400">
                        {new Date(note.session_date).toLocaleDateString()}
                      </span>
                    </div>

                    <p className="text-xs text-neutral-700 leading-relaxed font-normal">
                      {note.summary}
                    </p>

                    {/* Pathways */}
                    {note.recommended_pathways?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-neutral-400 block">Recommended Pathways:</span>
                        {note.recommended_pathways.map((p, pIdx) => (
                          <div key={pIdx} className="text-xs bg-[#F7F6F4] text-neutral-900 px-2.5 py-1 rounded-[8px] font-medium">
                            • {p}
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Eligible Schemes */}
                    {note.eligible_schemes?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-neutral-400 block">Matched Govt Schemes:</span>
                        {note.eligible_schemes.map((s, sIdx) => (
                          <div key={sIdx} className="text-xs bg-emerald-50 text-emerald-800 px-2.5 py-0.5 rounded-[8px] border border-emerald-100 font-medium flex items-center gap-1.5">
                            <CheckCircle2 className="w-3 h-3 text-emerald-600 shrink-0" />
                            <span>{s}</span>
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Action items */}
                    {note.action_items?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-neutral-400 block">Next Steps:</span>
                        {note.action_items.map((a, aIdx) => (
                          <div key={aIdx} className="text-[11px] text-neutral-700 bg-neutral-50 px-2.5 py-1 rounded-[8px] flex items-start gap-1">
                            <ArrowRight className="w-3 h-3 text-neutral-900 mt-0.5 shrink-0" />
                            <span>{a}</span>
                          </div>
                        ))}
                      </div>
                    )}

                  </div>
                ))}
              </div>
            )}
          </div>

        </div>

        {/* Drawer Action Footer */}
        <div className="p-4 border-t border-black/[0.05] bg-white flex items-center gap-3">
          <button
            onClick={() => onLaunchGuidance(student)}
            className="btn-pill-black flex-1 py-3 text-xs font-semibold gap-2 shadow-sm"
          >
            <Sparkles className="w-4 h-4 text-white" />
            <span>Launch Guidance Session</span>
          </button>
        </div>

      </div>
    </div>
  );
}
