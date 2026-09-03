import React from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { Award, ShieldCheck, Printer, X, CheckCircle, Compass } from 'lucide-react';

export default function VolunteerCredentialModal() {
  const { volunteer, isCredentialModalOpen, setIsCredentialModalOpen } = useAuth();
  const { t } = useLanguage();

  if (!isCredentialModalOpen || !volunteer) return null;

  return (
    <div className="fixed inset-0 bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden border border-slate-200">
        
        {/* Header */}
        <div className="bg-[#173F6B] text-white p-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Award className="w-5 h-5 text-amber-400" />
            <h3 className="font-bold text-base font-indic">{t('auth.credential_title')}</h3>
          </div>
          <button 
            onClick={() => setIsCredentialModalOpen(false)}
            className="text-sky-200 hover:text-white p-1"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Card Body (Printable Design) */}
        <div className="p-6">
          <div className="border-2 border-[#173F6B] rounded-xl p-5 bg-gradient-to-b from-sky-50/40 via-white to-amber-50/20 relative shadow-sm">
            
            {/* Top Emblem & Govt Badge */}
            <div className="flex items-start justify-between border-b border-slate-200 pb-3 mb-3">
              <div className="flex items-center gap-2">
                <div className="w-9 h-9 rounded-md bg-[#173F6B] flex items-center justify-center text-amber-400 font-bold text-base">
                  <Compass className="w-5 h-5" />
                </div>
                <div>
                  <h4 className="font-bold text-xs uppercase tracking-wider text-[#173F6B]">
                    DreamCatcher Platform
                  </h4>
                  <p className="text-[10px] text-slate-500 font-medium">
                    Govt Field Counselor Accreditation
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-1 bg-emerald-100 text-emerald-800 text-[10px] font-bold px-2 py-0.5 rounded-full border border-emerald-300">
                <CheckCircle className="w-3 h-3" />
                <span>Verified</span>
              </div>
            </div>

            {/* Volunteer Details */}
            <div className="space-y-2.5 text-xs">
              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Volunteer Name</span>
                <span className="text-sm font-bold text-slate-900 font-indic">{volunteer.full_name}</span>
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <span className="text-[10px] uppercase font-bold text-slate-400 block">Volunteer ID</span>
                  <span className="font-bold text-amber-700 bg-amber-100/80 px-2 py-0.5 rounded inline-block text-xs border border-amber-300 font-mono">
                    {volunteer.volunteer_id}
                  </span>
                </div>
                <div>
                  <span className="text-[10px] uppercase font-bold text-slate-400 block">Affiliation</span>
                  <span className="font-semibold text-slate-800 font-indic">{volunteer.role_label || volunteer.role_type}</span>
                </div>
              </div>

              <div>
                <span className="text-[10px] uppercase font-bold text-slate-400 block">Organization / Department</span>
                <span className="font-medium text-slate-800 font-indic">{volunteer.organization_name}</span>
              </div>

              <div className="grid grid-cols-2 gap-2 border-t border-slate-100 pt-2">
                <div>
                  <span className="text-[10px] uppercase font-bold text-slate-400 block">Jurisdiction</span>
                  <span className="font-semibold text-slate-800">{volunteer.district}, {volunteer.state}</span>
                </div>
                <div>
                  <span className="text-[10px] uppercase font-bold text-slate-400 block">Phone</span>
                  <span className="font-semibold text-slate-800">{volunteer.phone_number}</span>
                </div>
              </div>
            </div>

            {/* Footer Barcode / Security strip */}
            <div className="mt-4 pt-2 border-t border-dashed border-slate-300 flex items-center justify-between text-[9px] text-slate-400 font-mono">
              <span>AUTH-SIG: DC-{volunteer.volunteer_id.slice(-5)}</span>
              <span>ISSUED: 2026-09</span>
            </div>

          </div>

          {/* Action Buttons */}
          <div className="mt-5 flex gap-2">
            <button
              onClick={() => window.print()}
              className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-800 text-xs font-bold rounded-lg border border-slate-300 flex items-center justify-center gap-1.5 transition-colors"
            >
              <Printer className="w-3.5 h-3.5 text-slate-600" />
              <span className="font-indic">{t('auth.print_card')}</span>
            </button>
            <button
              onClick={() => setIsCredentialModalOpen(false)}
              className="flex-1 py-2.5 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-xs font-bold rounded-lg transition-colors font-indic"
            >
              {t('auth.close')}
            </button>
          </div>

        </div>

      </div>
    </div>
  );
}
