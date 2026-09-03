import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import { Mail, Lock, X, LogIn } from 'lucide-react';

export default function LoginView() {
  const { isLoginModalOpen, setIsLoginModalOpen, setIsRegisterModalOpen, login } = useAuth();
  const { t } = useLanguage();

  const [volunteerId, setVolunteerId] = useState('DC-VOL-2026-00042');
  const [password, setPassword] = useState('password123');

  if (!isLoginModalOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    login(volunteerId, password);
  };

  return (
    <div className="fixed inset-0 bg-[#251D1B]/50 backdrop-blur-xs flex items-center justify-center p-4 z-50">
      <div className="bg-[#F4EFE6] rounded-[24px] shadow-2xl max-w-md w-full overflow-hidden border border-[#DECBC7]">
        
        {/* Modal Header */}
        <div className="p-6 border-b border-[#E3D9CA] flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <span className="font-serif-zen text-2xl font-semibold tracking-tight text-[#1F1F1F]">
              •SW
            </span>
            <span className="font-serif-zen text-base font-medium text-[#1F1F1F] ml-2">
              Welcome back
            </span>
          </div>
          <button 
            onClick={() => setIsLoginModalOpen(false)}
            className="text-[#7A6F62] hover:text-[#1F1F1F] p-1.5 rounded-full hover:bg-[#ECE4D8] transition-colors cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Modal Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <p className="font-serif-zen text-xs text-[#6B6256] italic">
            Where the blossoms greet your return.
          </p>

          <div>
            <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1.5">
              Email or Volunteer ID
            </label>
            <div className="relative">
              <Mail className="w-3.5 h-3.5 text-[#8C8276] absolute left-3.5 top-3" />
              <input
                type="text"
                required
                value={volunteerId}
                onChange={(e) => setVolunteerId(e.target.value)}
                placeholder="Enter your email"
                className="w-full pl-9 pr-4 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
              />
            </div>
          </div>

          <div>
            <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1.5">
              Password
            </label>
            <div className="relative">
              <Lock className="w-3.5 h-3.5 text-[#8C8276] absolute left-3.5 top-3" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="•••••"
                className="w-full pl-9 pr-4 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
              />
            </div>
          </div>

          <button
            type="submit"
            className="w-full bg-[#222222] hover:bg-[#111111] text-white py-2.5 rounded-[6px] text-sm font-medium tracking-wide transition-all shadow-xs cursor-pointer"
          >
            Log in
          </button>

          <div className="pt-2 text-center text-xs text-[#6B6256]">
            Don't have an account?{' '}
            <button
              type="button"
              onClick={() => {
                setIsLoginModalOpen(false);
                setIsRegisterModalOpen(true);
              }}
              className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer"
            >
              Sign up
            </button>
          </div>
        </form>

      </div>
    </div>
  );
}
