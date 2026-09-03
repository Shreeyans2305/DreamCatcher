import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { X, Sparkles, User, MapPin, Phone, GraduationCap, Award, Calendar, FileText, ArrowRight, CheckCircle2 } from 'lucide-react';

export default function StudentCaseDrawer({ student, onClose, onLaunchGuidance }) {
  const { t } = useLanguage();

  if (!student) return null;

  const notes = student.case_notes || [];

  return (
    <div className="fixed inset-0 bg-slate-950/60 backdrop-blur-xs flex justify-end z-50 transition-opacity">
      <div className="bg-white w-full max-w-xl h-full shadow-2xl flex flex-col border-l border-slate-200 overflow-hidden">
        
        {/* Drawer Header */}
        <div className="bg-[#173F6B] text-white p-5 flex items-start justify-between border-b border-[#0D2E50]">
          <div>
            <div className="flex items-center gap-2">
              <span className="font-bold text-lg font-indic">{student.full_name}</span>
              <span className="bg-amber-400 text-slate-950 text-[10px] font-bold px-2 py-0.5 rounded uppercase">
                {student.sync_status === 'synced' ? 'Synced' : 'Local Draft'}
              </span>
            </div>
            <p className="text-xs text-sky-100 mt-1 font-indic">
              Camp: {student.camp_name || 'Shindewadi ZP School'}
            </p>
          </div>
          <button 
            onClick={onClose} 
            className="text-sky-200 hover:text-white p-1.5 rounded-lg hover:bg-[#0D2E50]"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Drawer Content */}
        <div className="flex-1 overflow-y-auto p-5 sm:p-6 space-y-6">
          
          {/* Demographic & Contact Details */}
          <div className="bg-slate-50 rounded-xl p-4 border border-slate-200 space-y-2.5 text-xs">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Age / DOB</span>
                <span className="font-bold text-slate-900 font-indic">{student.age_years} Yrs ({student.date_of_birth || 'N/A'})</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Location</span>
                <span className="font-semibold text-slate-900 font-indic">{student.village_location}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 border-t border-slate-200 pt-2">
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Education Stage</span>
                <span className="font-semibold text-slate-900 font-indic">{student.education_level_label}</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Social Category</span>
                <span className="font-semibold text-slate-900 font-indic">{student.category_label}</span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 border-t border-slate-200 pt-2">
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Guardian Phone</span>
                <span className="font-semibold text-slate-900">{student.guardian_contact_number}</span>
              </div>
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Preferred Language</span>
                <span className="font-semibold text-slate-900 uppercase">{student.preferred_language}</span>
              </div>
            </div>

            {student.aspirations && (
              <div className="border-t border-slate-200 pt-2">
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Stated Aspirations</span>
                <p className="font-medium text-slate-800 font-indic mt-0.5">{student.aspirations}</p>
              </div>
            )}
          </div>

          {/* Longitudinal Case Notes Section (CommCare pattern) */}
          <div>
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center gap-2">
                <FileText className="w-4 h-4 text-[#173F6B]" />
                <h4 className="font-bold text-sm text-slate-900 font-indic">Guidance Case History ({notes.length})</h4>
              </div>
            </div>

            {notes.length === 0 ? (
              <div className="border border-dashed border-slate-200 rounded-xl p-6 text-center text-xs text-slate-500 font-indic">
                No counseling session notes recorded yet for this student.
              </div>
            ) : (
              <div className="space-y-4">
                {notes.map((note, idx) => (
                  <div key={note.case_note_id || idx} className="border border-slate-200 rounded-xl p-4 bg-white shadow-2xs space-y-3">
                    
                    <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                      <span className="text-[11px] font-bold text-amber-700 font-indic">
                        Counseling Session #{notes.length - idx}
                      </span>
                      <span className="text-[10px] text-slate-400">
                        {new Date(note.session_date).toLocaleDateString()}
                      </span>
                    </div>

                    <p className="text-xs text-slate-800 font-indic leading-relaxed">
                      {note.summary}
                    </p>

                    {/* Pathways */}
                    {note.recommended_pathways?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-slate-400 block">Recommended Pathways:</span>
                        {note.recommended_pathways.map((p, pIdx) => (
                          <div key={pIdx} className="text-xs bg-sky-50 text-[#173F6B] px-2 py-1 rounded border border-sky-100 font-indic font-medium">
                            • {p}
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Eligible Schemes */}
                    {note.eligible_schemes?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-slate-400 block">Matched Govt Schemes:</span>
                        {note.eligible_schemes.map((s, sIdx) => (
                          <div key={sIdx} className="text-xs bg-emerald-50 text-emerald-800 px-2 py-0.5 rounded border border-emerald-100 font-indic flex items-center gap-1">
                            <CheckCircle2 className="w-3 h-3 text-emerald-600 shrink-0" />
                            <span>{s}</span>
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Action items */}
                    {note.action_items?.length > 0 && (
                      <div className="space-y-1">
                        <span className="text-[10px] uppercase font-bold text-slate-400 block">Next Steps:</span>
                        {note.action_items.map((a, aIdx) => (
                          <div key={aIdx} className="text-[11px] text-slate-700 bg-amber-50/60 px-2 py-1 rounded font-indic flex items-start gap-1">
                            <ArrowRight className="w-3 h-3 text-amber-600 mt-0.5 shrink-0" />
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
        <div className="p-4 border-t border-slate-200 bg-slate-50 flex items-center gap-3">
          <button
            onClick={() => onLaunchGuidance(student)}
            className="flex-1 py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-lg shadow flex items-center justify-center gap-2 transition-colors touch-target font-indic"
          >
            <Sparkles className="w-4 h-4 text-amber-400" />
            <span>Launch Guidance Session</span>
          </button>
        </div>

      </div>
    </div>
  );
}
