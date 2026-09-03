import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
import DreamCatcherWind from '../ui/DreamCatcherWind';
import { 
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  User, 
  Building2, 
  X, 
  Zap, 
  Globe 
} from 'lucide-react';

export default function AuthModal({ initialMode = 'login', isOpen, onClose }) {
  const { login, register } = useAuth();
  const { t, uiLanguage, setLanguage, languageOptions } = useLanguage();

  const [mode, setMode] = useState(initialMode); // 'login' | 'register'
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(true);

  // Login form state
  const [loginEmail, setLoginEmail] = useState('DC-VOL-2026-00042');
  const [loginPassword, setLoginPassword] = useState('password123');

  // Register form state
  const [registerData, setRegisterData] = useState({
    full_name: '',
    role_type: 'teacher',
    role_label: 'Government School Teacher',
    organization_name: '',
    phone_number: '',
    district: 'Satara',
    state: 'Maharashtra',
    preferred_ui_language: 'mr',
    password: ''
  });

  if (!isOpen) return null;

  const roleOptions = [
    { value: 'teacher', label: t('auth.role_teacher') || 'School Teacher' },
    { value: 'govt_officer', label: t('auth.role_govt') || 'Government Officer' },
    { value: 'ngo_staff', label: t('auth.role_ngo') || 'NGO / Volunteer Staff' }
  ];

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    login(loginEmail, loginPassword);
    onClose();
  };

  const handleQuickDemoLogin = () => {
    login('DC-VOL-2026-00042', 'password123');
    onClose();
  };

  const handleRegisterSubmit = (e) => {
    e.preventDefault();
    const selectedRole = roleOptions.find(r => r.value === registerData.role_type);
    register({
      ...registerData,
      role_label: selectedRole?.label || 'Volunteer'
    });
    onClose();
  };

  return (
    <div className="fixed inset-0 bg-[#251D1B]/50 backdrop-blur-xs flex items-center justify-center p-3 sm:p-5 z-50 overflow-y-auto">
      <div className="bg-[#F4EFE6] rounded-[28px] shadow-[0_25px_60px_rgba(60,40,35,0.22)] max-w-4xl w-full overflow-hidden border border-[#DECBC7] my-auto grid grid-cols-1 md:grid-cols-12 min-h-[560px] animate-in fade-in duration-200 relative">
        
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 z-20 p-2 text-[#7A6F62] hover:text-[#1F1F1F] bg-[#ECE4D8]/80 hover:bg-[#ECE4D8] rounded-full transition-colors cursor-pointer"
          aria-label="Close modal"
        >
          <X className="w-4 h-4" />
        </button>

        {/* ========================================================= */}
        {/* LEFT COLUMN: INTERACTIVE FORM                             */}
        {/* ========================================================= */}
        <div className="md:col-span-6 p-6 sm:p-8 lg:p-10 flex flex-col justify-between bg-[#F4EFE6]">
          
          <div>
            {/* Top Monogram */}
            <div className="flex items-center justify-between mb-6">
              <span className="font-serif-zen text-2xl font-semibold tracking-tight text-[#1F1F1F]">
                • DreamCatcher
              </span>

              <div className="flex items-center bg-[#ECE4D8] border border-[#DDD3C5] rounded-full px-2.5 py-1 text-xs mr-6">
                <Globe className="w-3 h-3 text-[#7B7165] mr-1 shrink-0" />
                <select
                  value={uiLanguage}
                  onChange={(e) => setLanguage(e.target.value)}
                  className="bg-transparent text-[#2D2823] font-medium text-[11px] cursor-pointer focus:outline-none"
                >
                  {languageOptions.map(opt => (
                    <option key={opt.code} value={opt.code} className="text-[#1F1F1F] bg-[#F4EFE6]">
                      {opt.nativeLabel}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* Mode Switcher pill */}
            <div className="flex bg-[#ECE4D8] p-1 rounded-full mb-6 max-w-xs border border-[#DCD1C2]">
              <button
                type="button"
                onClick={() => setMode('login')}
                className={`flex-1 py-1.5 text-xs font-serif-zen font-semibold rounded-full transition-all cursor-pointer ${
                  mode === 'login'
                    ? 'bg-[#222222] text-white shadow-xs'
                    : 'text-[#665D52] hover:text-[#1F1F1F]'
                }`}
              >
                Log in
              </button>
              <button
                type="button"
                onClick={() => setMode('register')}
                className={`flex-1 py-1.5 text-xs font-serif-zen font-semibold rounded-full transition-all cursor-pointer ${
                  mode === 'register'
                    ? 'bg-[#222222] text-white shadow-xs'
                    : 'text-[#665D52] hover:text-[#1F1F1F]'
                }`}
              >
                Sign up
              </button>
            </div>

            {/* Form Headers */}
            <h1 className="font-serif-zen text-2xl sm:text-3xl text-[#1F1F1F] font-medium tracking-tight mb-1">
              {mode === 'login' ? 'Welcome back!' : 'Begin your journey.'}
            </h1>
            <p className="font-serif-zen text-xs sm:text-sm text-[#6B6256] italic mb-6">
              {mode === 'login' 
                ? 'Where the blossoms greet your return.'
                : 'Where dreams take root and blossom.'}
            </p>

            {/* ===================================================== */}
            {/* LOGIN FORM                                            */}
            {/* ===================================================== */}
            {mode === 'login' ? (
              <form onSubmit={handleLoginSubmit} className="space-y-3.5">
                <div>
                  <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                    Email
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-[#8C8276]">
                      <Mail className="w-3.5 h-3.5" />
                    </div>
                    <input
                      type="text"
                      required
                      value={loginEmail}
                      onChange={(e) => setLoginEmail(e.target.value)}
                      placeholder="Enter your email"
                      className="w-full pl-9 pr-3.5 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                    />
                  </div>
                </div>

                <div>
                  <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                    Password
                  </label>
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-[#8C8276]">
                      <Lock className="w-3.5 h-3.5" />
                    </div>
                    <input
                      type={showPassword ? 'text' : 'password'}
                      required
                      value={loginPassword}
                      onChange={(e) => setLoginPassword(e.target.value)}
                      placeholder="•••••"
                      className="w-full pl-9 pr-9 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute inset-y-0 right-0 pr-3 flex items-center text-[#8C8276] hover:text-[#222222] cursor-pointer"
                    >
                      {showPassword ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                    </button>
                  </div>
                </div>

                <div className="flex items-center justify-between text-xs pt-0.5">
                  <label className="flex items-center gap-2 cursor-pointer text-[#6B6256]">
                    <input
                      type="checkbox"
                      checked={rememberMe}
                      onChange={(e) => setRememberMe(e.target.checked)}
                      className="w-3.5 h-3.5 rounded-[3px] border-[#C5BBAA] text-[#222222] accent-[#222222]"
                    />
                    <span>Remember me</span>
                  </label>
                  <button
                    type="button"
                    onClick={() => alert('Demo password is: password123')}
                    className="text-[#6B6256] hover:text-[#1F1F1F] underline underline-offset-2 cursor-pointer"
                  >
                    Forgot password?
                  </button>
                </div>

                <div className="pt-2">
                  <button
                    type="submit"
                    className="w-full bg-[#222222] hover:bg-[#111111] text-white py-2.5 rounded-[6px] text-xs sm:text-sm font-medium tracking-wide transition-all shadow-xs cursor-pointer"
                  >
                    Log in
                  </button>
                </div>

                <div className="pt-1">
                  <button
                    type="button"
                    onClick={handleQuickDemoLogin}
                    className="w-full flex items-center justify-center gap-1.5 py-1.5 px-3 border border-[#D5CCBD] hover:border-[#222222] rounded-[6px] text-xs text-[#524B43] hover:text-[#1F1F1F] transition-all bg-white/20 hover:bg-white/50 cursor-pointer"
                  >
                    <Zap className="w-3 h-3 text-[#C49F5A]" />
                    <span>Quick Demo Sign In (Anand Kulkarni)</span>
                  </button>
                </div>
              </form>
            ) : (
              /* ===================================================== */
              /* REGISTER FORM                                         */
              /* ===================================================== */
              <form onSubmit={handleRegisterSubmit} className="space-y-2.5">
                <div>
                  <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-0.5">
                    Full Name
                  </label>
                  <input
                    type="text"
                    required
                    value={registerData.full_name}
                    onChange={(e) => setRegisterData({ ...registerData, full_name: e.target.value })}
                    placeholder="e.g. Ramesh Patil"
                    className="w-full px-3 py-1.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222]"
                  />
                </div>

                <div>
                  <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-0.5">
                    Role
                  </label>
                  <select
                    value={registerData.role_type}
                    onChange={(e) => setRegisterData({ ...registerData, role_type: e.target.value })}
                    className="w-full px-3 py-1.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222] cursor-pointer"
                  >
                    {roleOptions.map(r => (
                      <option key={r.value} value={r.value} className="bg-[#F4EFE6]">{r.label}</option>
                    ))}
                  </select>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-0.5">
                      District
                    </label>
                    <input
                      type="text"
                      required
                      value={registerData.district}
                      onChange={(e) => setRegisterData({ ...registerData, district: e.target.value })}
                      placeholder="e.g. Satara"
                      className="w-full px-3 py-1.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222]"
                    />
                  </div>
                  <div>
                    <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-0.5">
                      Mobile
                    </label>
                    <input
                      type="tel"
                      required
                      value={registerData.phone_number}
                      onChange={(e) => setRegisterData({ ...registerData, phone_number: e.target.value })}
                      placeholder="10-digit mobile"
                      className="w-full px-3 py-1.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222]"
                    />
                  </div>
                </div>

                <div>
                  <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-0.5">
                    Password
                  </label>
                  <input
                    type="password"
                    required
                    value={registerData.password}
                    onChange={(e) => setRegisterData({ ...registerData, password: e.target.value })}
                    placeholder="••••••••"
                    className="w-full px-3 py-1.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222]"
                  />
                </div>

                <div className="pt-2">
                  <button
                    type="submit"
                    className="w-full bg-[#222222] hover:bg-[#111111] text-white py-2.5 rounded-[6px] text-xs sm:text-sm font-medium tracking-wide transition-all shadow-xs cursor-pointer"
                  >
                    Create account
                  </button>
                </div>
              </form>
            )}
          </div>

          <div className="mt-6 pt-3 border-t border-[#E3D9CA] text-xs text-[#6B6256] text-center">
            {mode === 'login' ? (
              <p>
                Don't have an account?{' '}
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer"
                >
                  Sign up
                </button>
              </p>
            ) : (
              <p>
                Already have an account?{' '}
                <button
                  type="button"
                  onClick={() => setMode('login')}
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer"
                >
                  Log in
                </button>
              </p>
            )}
          </div>

        </div>

        {/* ========================================================= */}
        {/* RIGHT COLUMN: WATERCOLOR ARTWORK                         */}
        {/* ========================================================= */}
        <div className="hidden md:block md:col-span-6 relative overflow-hidden">
          <img
            src="/dreamcatcher_wind.jpg"
            alt="DreamCatcher floating in morning breeze"
            className="w-full h-full object-cover object-center"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-[#F4EFE6] via-[#F4EFE6]/40 via-15% to-transparent pointer-events-none" />
          <DreamCatcherWind showDreamcatchers={true} featherCount={12} windSpeed={1} opacity={0.85} />
        </div>

      </div>
    </div>
  );
}
