import React from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { Award, Printer, X, CheckCircle, Compass } from 'lucide-react';

export default function VolunteerCredentialModal() {
  const { volunteer, isCredentialModalOpen, setIsCredentialModalOpen } = useAuth();
  const { t } = useLanguage();

  if (!isCredentialModalOpen || !volunteer) return null;

  return (
    <div className="fixed inset-0 bg-black/50 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-[20px] shadow-2xl max-w-md w-full overflow-hidden border border-black/[0.05]">
        
        {/* Header */}
        <div className="p-5 border-b border-black/[0.05] bg-white flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-[10px] bg-neutral-100 text-neutral-900 flex items-center justify-center font-bold">
              <Award className="w-4.5 h-4.5" />
            </div>
            <h3 className="font-bold text-base text-neutral-900">{t('auth.credential_title')}</h3>
          </div>
          <button 
            onClick={() => setIsCredentialModalOpen(false)}
            className="text-neutral-400 hover:text-black p-1.5 rounded-full hover:bg-neutral-100 transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Card Body (Printable Design) */}
        <div className="p-6">
          <div className="border border-black/[0.08] rounded-[18px] p-5 bg-[#F7F6F4]/50 relative shadow-xs">
            
            {/* Top Emblem & Govt Badge */}
            <div className="flex items-start justify-between border-b border-black/[0.05] pb-3 mb-3">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-[10px] bg-[#111111] flex items-center justify-center text-white font-bold text-base shadow-xs">
                  <Compass className="w-4.5 h-4.5" />
                </div>
                <div>
                  <h4 className="font-bold text-xs uppercase tracking-wider text-neutral-900">
                    DreamCatcher Platform
                  </h4>
                  <p className="text-[10px] text-neutral-500 font-medium">
                    Govt Field Counselor Accreditation
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-1 bg-emerald-50 text-emerald-800 text-[10px] font-bold px-2.5 py-0.5 rounded-full border border-emerald-200">
                <CheckCircle className="w-3 h-3 text-emerald-600" />
                <span>Verified</span>
              </div>
            </div>

            {/* Volunteer Details */}
            <div className="space-y-2.5 text-xs">
              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Volunteer Name</span>
                <span className="text-sm font-bold text-neutral-900">{volunteer.full_name}</span>
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <span className="text-[10px] uppercase font-bold text-neutral-400 block">Volunteer ID</span>
                  <span className="font-bold text-neutral-900 bg-white px-2 py-0.5 rounded-full inline-block text-xs border border-black/[0.06] font-mono shadow-2xs">
                    {volunteer.volunteer_id}
                  </span>
                </div>
                <div>
                  <span className="text-[10px] uppercase font-bold text-neutral-400 block">Affiliation</span>
                  <span className="font-semibold text-neutral-800">{volunteer.role_label || volunteer.role_type}</span>
                </div>
              </div>

              <div>
                <span className="text-[10px] uppercase font-bold text-neutral-400 block">Organization / Department</span>
                <span className="font-medium text-neutral-800">{volunteer.organization_name}</span>
              </div>

              <div className="grid grid-cols-2 gap-2 border-t border-black/[0.05] pt-2">
                <div>
                  <span className="text-[10px] uppercase font-bold text-neutral-400 block">Jurisdiction</span>
                  <span className="font-semibold text-neutral-800">{volunteer.district}, {volunteer.state}</span>
                </div>
                <div>
                  <span className="text-[10px] uppercase font-bold text-neutral-400 block">Phone</span>
                  <span className="font-semibold text-neutral-800">{volunteer.phone_number}</span>
                </div>
              </div>
            </div>

            {/* Footer Barcode / Security strip */}
            <div className="mt-4 pt-2 border-t border-dashed border-neutral-300 flex items-center justify-between text-[9px] text-neutral-400 font-mono">
              <span>AUTH-SIG: DC-{volunteer.volunteer_id.slice(-5)}</span>
              <span>ISSUED: 2026-09</span>
            </div>

          </div>

          {/* Action Buttons */}
          <div className="mt-5 flex gap-2">
            <button
              onClick={() => window.print()}
              className="btn-pill-secondary flex-1 py-2.5 text-xs font-semibold gap-1.5"
            >
              <Printer className="w-3.5 h-3.5 text-neutral-600" />
              <span>{t('auth.print_card')}</span>
            </button>
            <button
              onClick={() => setIsCredentialModalOpen(false)}
              className="btn-pill-black flex-1 py-2.5 text-xs font-semibold"
            >
              {t('auth.close')}
            </button>
          </div>

        </div>

      </div>
    </div>
  );
}
