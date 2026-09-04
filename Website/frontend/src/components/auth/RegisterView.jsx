import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { X, Award } from 'lucide-react';

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
    { value: 'teacher', label: t('auth.role_teacher') || 'School Teacher' },
    { value: 'govt_officer', label: t('auth.role_govt') || 'Government Officer' },
    { value: 'ngo_staff', label: t('auth.role_ngo') || 'NGO Staff / Field Volunteer' }
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
    <div className="fixed inset-0 bg-[#251D1B]/50 backdrop-blur-xs flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-[#F4EFE6] rounded-[24px] shadow-2xl max-w-lg w-full overflow-hidden border border-[#DECBC7] my-8">
        
        {/* Header */}
        <div className="p-6 border-b border-[#E3D9CA] flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <span className="font-serif-zen text-2xl font-semibold tracking-tight text-[#1F1F1F]">
              •SW
            </span>
            <div>
              <h2 className="font-serif-zen text-xl font-medium text-[#1F1F1F]">Begin your journey</h2>
              <p className="font-serif-zen text-xs text-[#6B6256] italic">Where dreams take root and blossom.</p>
            </div>
          </div>
          <button 
            onClick={() => setIsRegisterModalOpen(false)}
            className="text-[#7A6F62] hover:text-[#1F1F1F] p-1.5 rounded-full hover:bg-[#ECE4D8] transition-colors cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-3.5">
          <div>
            <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
              Full Name *
            </label>
            <input
              type="text"
              required
              value={formData.full_name}
              onChange={(e) => setFormData({ ...formData, full_name: e.target.value })}
              placeholder="e.g. Anand Govind Kulkarni"
              className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
            />
          </div>

          <div>
            <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
              Role Type *
            </label>
            <select
              value={formData.role_type}
              onChange={(e) => setFormData({ ...formData, role_type: e.target.value })}
              className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all cursor-pointer"
            >
              {roleOptions.map(r => (
                <option key={r.value} value={r.value} className="bg-[#F4EFE6]">{r.label}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
              Organization / School *
            </label>
            <input
              type="text"
              required
              value={formData.organization_name}
              onChange={(e) => setFormData({ ...formData, organization_name: e.target.value })}
              placeholder="e.g. Govt High School / Pratham Foundation / ZP School"
              className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
            />
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                Mobile Number *
              </label>
              <input
                type="tel"
                required
                value={formData.phone_number}
                onChange={(e) => setFormData({ ...formData, phone_number: e.target.value })}
                placeholder="10-digit mobile"
                className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
              />
            </div>

            <div>
              <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                District *
              </label>
              <input
                type="text"
                required
                value={formData.district}
                onChange={(e) => setFormData({ ...formData, district: e.target.value })}
                placeholder="e.g. Satara"
                className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                Preferred Language
              </label>
              <select
                value={formData.preferred_ui_language}
                onChange={(e) => setFormData({ ...formData, preferred_ui_language: e.target.value })}
                className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all cursor-pointer"
              >
                {languageOptions.map(l => (
                  <option key={l.code} value={l.code} className="bg-[#F4EFE6]">{l.nativeLabel}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                Password *
              </label>
              <input
                type="password"
                required
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                placeholder="••••••••"
                className="w-full px-3.5 py-2 text-sm bg-transparent border border-[#D5CCBD] rounded-[6px] text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full bg-[#222222] hover:bg-[#111111] text-white py-3 rounded-[6px] text-sm font-medium tracking-wide transition-all shadow-xs cursor-pointer mt-3"
          >
            Create account
          </button>

          <div className="text-center pt-2 text-xs text-[#6B6256]">
            Already have an account?{' '}
            <button
              type="button"
              onClick={() => {
                setIsRegisterModalOpen(false);
                setIsLoginModalOpen(true);
              }}
              className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer"
            >
              Log in
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}
