import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { UserPlus, X, Award, CheckCircle2 } from 'lucide-react';

export default function RegisterView() {
  const { isRegisterModalOpen, setIsRegisterModalOpen, setIsLoginModalOpen, register } = useAuth();
  const { t, languageOptions } = useLanguage();

  const [formData, setFormData] = useState({
    full_name: '',
    role_type: 'teacher',
    role_label: 'Government School Teacher',
    organization_name: '',
    phone_number: '',
    email: '',
    district: 'Satara',
    state: 'Maharashtra',
    preferred_ui_language: 'mr',
    password: ''
  });

  if (!isRegisterModalOpen) return null;

  const roleOptions = [
    { value: 'teacher', label: t('auth.role_teacher') },
    { value: 'govt_officer', label: t('auth.role_govt') },
    { value: 'ngo_staff', label: t('auth.role_ngo') }
  ];

  const handleSubmit = (e) => {
    e.preventDefault();
    const selectedRole = roleOptions.find(r => r.value === formData.role_type);
    register({
      ...formData,
      role_label: selectedRole?.label || 'Volunteer'
    });
  };

  return (
    <div className="fixed inset-0 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white rounded-xl shadow-2xl max-w-lg w-full overflow-hidden border border-slate-200 my-8">
        
        {/* Header */}
        <div className="bg-[#173F6B] text-white p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <UserPlus className="w-6 h-6 text-amber-400" />
            <h2 className="text-lg font-bold font-indic">{t('auth.register_title')}</h2>
          </div>
          <button 
            onClick={() => setIsRegisterModalOpen(false)}
            className="text-sky-200 hover:text-white p-1 rounded-md"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <p className="text-xs text-slate-600 font-indic">
            {t('auth.register_subtitle')}
          </p>

          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
              {t('auth.full_name')} *
            </label>
            <input
              type="text"
              required
              value={formData.full_name}
              onChange={(e) => setFormData({ ...formData, full_name: e.target.value })}
              placeholder="e.g. Anand Govind Kulkarni"
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
              {t('auth.role_type')} *
            </label>
            <select
              value={formData.role_type}
              onChange={(e) => setFormData({ ...formData, role_type: e.target.value })}
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-indic bg-white"
            >
              {roleOptions.map(r => (
                <option key={r.value} value={r.value}>{r.label}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
              {t('auth.org_name')} *
            </label>
            <input
              type="text"
              required
              value={formData.organization_name}
              onChange={(e) => setFormData({ ...formData, organization_name: e.target.value })}
              placeholder="e.g. Zilla Parishad High School, Shindewadi"
              className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('auth.phone')} *
              </label>
              <input
                type="tel"
                required
                value={formData.phone_number}
                onChange={(e) => setFormData({ ...formData, phone_number: e.target.value })}
                placeholder="10-digit mobile number"
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('camps.district')} *
              </label>
              <input
                type="text"
                required
                value={formData.district}
                onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                placeholder="e.g. Satara / Pune"
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('auth.preferred_ui_lang')}
              </label>
              <select
                value={formData.preferred_ui_language}
                onChange={(e) => setFormData({ ...formData, preferred_ui_language: e.target.value })}
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-indic bg-white"
              >
                {languageOptions.map(l => (
                  <option key={l.code} value={l.code}>{l.nativeLabel} ({l.code.toUpperCase()})</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                {t('auth.password')} *
              </label>
              <input
                type="password"
                required
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                placeholder="Create secure password"
                className="w-full px-3 py-2 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] font-medium"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-3 bg-amber-500 hover:bg-amber-600 text-slate-950 font-bold text-sm rounded-lg shadow-md flex items-center justify-center gap-2 transition-colors touch-target mt-4"
          >
            <Award className="w-4 h-4 text-slate-950" />
            <span className="font-indic">{t('auth.register_btn')}</span>
          </button>

          <div className="text-center pt-2">
            <button
              type="button"
              onClick={() => {
                setIsRegisterModalOpen(false);
                setIsLoginModalOpen(true);
              }}
              className="text-xs text-[#173F6B] hover:underline font-semibold font-indic"
            >
              {t('auth.have_account')}
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}
