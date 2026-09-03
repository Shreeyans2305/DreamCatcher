import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { ShieldCheck, X, LogIn, Key, User } from 'lucide-react';

export default function LoginView() {
  const { isLoginModalOpen, setIsLoginModalOpen, setIsRegisterModalOpen, login } = useAuth();
  const { t } = useLanguage();

  const [volunteerId, setVolunteerId] = useState('DC-VOL-2026-00042');
  const [password, setPassword] = useState('••••••••');

  if (!isLoginModalOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    login(volunteerId, password);
  };

  return (
    <div className="fixed inset-0 bg-slate-950/60 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl shadow-2xl max-w-md w-full overflow-hidden border border-slate-200">
        
        {/* Modal Header */}
        <div className="bg-[#173F6B] text-white p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <ShieldCheck className="w-6 h-6 text-amber-400" />
            <h2 className="text-lg font-bold font-indic">{t('auth.login_title')}</h2>
          </div>
          <button 
            onClick={() => setIsLoginModalOpen(false)}
            className="text-sky-200 hover:text-white p-1 rounded-md"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <p className="text-xs text-slate-600 font-indic">
            {t('auth.login_subtitle')}
          </p>

          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
              {t('header.volunteer_id')} / Mobile
            </label>
            <div className="relative">
              <User className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
              <input
                type="text"
                required
                value={volunteerId}
                onChange={(e) => setVolunteerId(e.target.value)}
                placeholder="DC-VOL-2026-XXXXX or 9822014589"
                className="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] focus:border-transparent font-medium"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
              {t('auth.password')}
            </label>
            <div className="relative">
              <Key className="w-4 h-4 text-slate-400 absolute left-3 top-3.5" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-9 pr-3 py-2.5 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-[#173F6B] focus:border-transparent font-medium"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white font-bold text-sm rounded-lg shadow-md flex items-center justify-center gap-2 transition-colors touch-target"
          >
            <LogIn className="w-4 h-4 text-amber-400" />
            <span className="font-indic">{t('auth.login_btn')}</span>
          </button>

          <div className="pt-2 text-center">
            <button
              type="button"
              onClick={() => {
                setIsLoginModalOpen(false);
                setIsRegisterModalOpen(true);
              }}
              className="text-xs text-[#173F6B] hover:underline font-semibold font-indic"
            >
              {t('auth.need_account')}
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}
