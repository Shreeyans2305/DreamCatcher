import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';
import DreamCatcherWind from '../components/ui/DreamCatcherWind';
import { 
  Mail, 
  Lock, 
  Eye, 
  EyeOff, 
  User, 
  Globe, 
  Zap, 
  Sparkles,
  Compass
} from 'lucide-react';

export default function AuthPageView({ onLoginSuccess }) {
  const { login, register } = useAuth();
  const { t, uiLanguage, setLanguage, languageOptions } = useLanguage();

  const [mode, setMode] = useState('login'); // 'login' | 'register'
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

  const roleOptions = [
    { value: 'teacher', label: t('auth.role_teacher') || 'Government School Teacher' },
    { value: 'govt_officer', label: t('auth.role_govt') || 'Block / Taluka Education Officer' },
    { value: 'ngo_staff', label: t('auth.role_ngo') || 'Field Volunteer / Counselor' }
  ];

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    login(loginEmail, loginPassword);
    if (onLoginSuccess) onLoginSuccess();
  };

  const handleQuickDemoLogin = () => {
    login('DC-VOL-2026-00042', 'password123');
    if (onLoginSuccess) onLoginSuccess();
  };

  const handleRegisterSubmit = (e) => {
    e.preventDefault();
    const selectedRole = roleOptions.find(r => r.value === registerData.role_type);
    register({
      ...registerData,
      role_label: selectedRole?.label || 'Volunteer'
    });
    if (onLoginSuccess) onLoginSuccess();
  };

  return (
    <div className="min-h-screen bg-[#EBDDD9] text-[#1C1C1C] flex items-center justify-center p-3 sm:p-6 lg:p-10 relative overflow-hidden font-sans">
      
      {/* Windy atmosphere with floating feathers drifting across the canvas */}
      <DreamCatcherWind showDreamcatchers={false} featherCount={18} windSpeed={1.1} opacity={0.7} />

      {/* Main Authentication Card */}
      <div className="relative z-10 w-full max-w-5xl bg-[#F4EFE6] rounded-[28px] sm:rounded-[32px] shadow-[0_24px_60px_rgba(80,50,40,0.14)] border border-[#DECBC7] overflow-hidden grid grid-cols-1 lg:grid-cols-12 min-h-[640px]">
        
        {/* ========================================================= */}
        {/* LEFT COLUMN: AUTHENTICATION FORM (Warm Linen / Rice Paper)*/}
        {/* ========================================================= */}
        <div className="lg:col-span-6 p-7 sm:p-10 lg:p-14 flex flex-col justify-between bg-[#F4EFE6] z-10">
          
          <div>
            {/* Top Bar: DreamCatcher Logo & Minimal Language Switcher */}
            <div className="flex items-center justify-between mb-8 sm:mb-10">
              <div className="flex items-center gap-2">
                <span className="font-serif-zen text-2xl font-semibold tracking-tight text-[#1F1F1F]">
                  • DreamCatcher
                </span>
                <span className="text-[10px] bg-[#EAE2D5] text-[#585149] px-2 py-0.5 rounded-full font-serif-zen font-medium border border-[#D5CCBD] hidden sm:inline">
                  National Mission
                </span>
              </div>

              {/* Minimalist Language Switcher */}
              <div className="flex items-center bg-[#ECE4D8] border border-[#DDD3C5] rounded-full px-2.5 py-1 text-xs">
                <Globe className="w-3 h-3 text-[#7B7165] mr-1 shrink-0" />
                <select
                  value={uiLanguage}
                  onChange={(e) => setLanguage(e.target.value)}
                  aria-label="Portal Language"
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

            {/* ===================================================== */}
            {/* SIGN IN VIEW                                          */}
            {/* ===================================================== */}
            {mode === 'login' ? (
              <div className="animate-in fade-in duration-300">
                {/* Headers */}
                <h1 className="font-serif-zen text-3xl sm:text-4xl text-[#1F1F1F] font-medium tracking-tight mb-2">
                  Welcome back!
                </h1>
                <p className="font-serif-zen text-sm sm:text-base text-[#6B6256] italic mb-8">
                  Where every village dream is caught and guided.
                </p>

                <form onSubmit={handleLoginSubmit} className="space-y-4">
                  {/* Email / ID Field */}
                  <div>
                    <label className="block font-serif-zen text-sm font-medium text-[#38332C] mb-1.5">
                      Email or Volunteer ID
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-[#8C8276]">
                        <Mail className="w-4 h-4" />
                      </div>
                      <input
                        type="text"
                        required
                        value={loginEmail}
                        onChange={(e) => setLoginEmail(e.target.value)}
                        placeholder="Enter your email or Volunteer ID"
                        className="w-full pl-9 pr-3.5 py-2.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                  </div>

                  {/* Password Field */}
                  <div>
                    <label className="block font-serif-zen text-sm font-medium text-[#38332C] mb-1.5">
                      Password
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-[#8C8276]">
                        <Lock className="w-4 h-4" />
                      </div>
                      <input
                        type={showPassword ? 'text' : 'password'}
                        required
                        value={loginPassword}
                        onChange={(e) => setLoginPassword(e.target.value)}
                        placeholder="•••••"
                        className="w-full pl-9 pr-9 py-2.5 bg-transparent border border-[#D5CCBD] rounded-[6px] text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute inset-y-0 right-0 pr-3 flex items-center text-[#8C8276] hover:text-[#222222] cursor-pointer"
                        aria-label="Toggle password visibility"
                      >
                        {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  {/* Remember Me & Forgot Password */}
                  <div className="flex items-center justify-between text-xs pt-1">
                    <label className="flex items-center gap-2 cursor-pointer text-[#6B6256] select-none hover:text-[#1F1F1F]">
                      <input
                        type="checkbox"
                        checked={rememberMe}
                        onChange={(e) => setRememberMe(e.target.checked)}
                        className="w-3.5 h-3.5 rounded-[3px] border-[#C5BBAA] text-[#222222] focus:ring-0 cursor-pointer accent-[#222222]"
                      />
                      <span>Remember me</span>
                    </label>
                    <button
                      type="button"
                      onClick={() => alert('Demo password is: password123')}
                      className="text-[#6B6256] hover:text-[#1F1F1F] underline underline-offset-2 transition-colors cursor-pointer"
                    >
                      Forgot password?
                    </button>
                  </div>

                  {/* Primary Dark Button: Log in */}
                  <div className="pt-2">
                    <button
                      type="submit"
                      className="w-full bg-[#222222] hover:bg-[#111111] text-white py-3 rounded-[6px] text-sm font-medium tracking-wide transition-all shadow-xs active:scale-[0.99] cursor-pointer"
                    >
                      Log in
                    </button>
                  </div>

                  {/* One-Click Quick Demo Pill */}
                  <div className="pt-1">
                    <button
                      type="button"
                      onClick={handleQuickDemoLogin}
                      className="w-full flex items-center justify-center gap-1.5 py-2 px-3 border border-[#D5CCBD] hover:border-[#222222] rounded-[6px] text-xs text-[#524B43] hover:text-[#1F1F1F] transition-all bg-white/20 hover:bg-white/50 cursor-pointer"
                    >
                      <Zap className="w-3.5 h-3.5 text-[#C49F5A]" />
                      <span>Quick Demo Sign In (Anand Kulkarni, Satara)</span>
                    </button>
                  </div>
                </form>
              </div>
            ) : (
              /* ===================================================== */
              /* SIGN UP / REGISTRATION VIEW                           */
              /* ===================================================== */
              <div className="animate-in fade-in duration-300">
                <h1 className="font-serif-zen text-3xl sm:text-4xl text-[#1F1F1F] font-medium tracking-tight mb-2">
                  Begin your journey.
                </h1>
                <p className="font-serif-zen text-sm sm:text-base text-[#6B6256] italic mb-6">
                  Join our national circle of rural counselors.
                </p>

                <form onSubmit={handleRegisterSubmit} className="space-y-3">
                  <div>
                    <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                      Full Name
                    </label>
                    <div className="relative">
                      <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-[#8C8276]">
                        <User className="w-3.5 h-3.5" />
                      </div>
                      <input
                        type="text"
                        required
                        value={registerData.full_name}
                        onChange={(e) => setRegisterData({ ...registerData, full_name: e.target.value })}
                        placeholder="e.g. Ramesh Govind Patil"
                        className="w-full pl-9 pr-3.5 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                      Role / Department
                    </label>
                    <select
                      value={registerData.role_type}
                      onChange={(e) => setRegisterData({ ...registerData, role_type: e.target.value })}
                      className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all cursor-pointer"
                    >
                      {roleOptions.map(r => (
                        <option key={r.value} value={r.value} className="bg-[#F4EFE6] text-[#1F1F1F]">
                          {r.label}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    <div>
                      <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                        Organization / School
                      </label>
                      <input
                        type="text"
                        required
                        value={registerData.organization_name}
                        onChange={(e) => setRegisterData({ ...registerData, organization_name: e.target.value })}
                        placeholder="ZP High School"
                        className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                    <div>
                      <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                        District
                      </label>
                      <input
                        type="text"
                        required
                        value={registerData.district}
                        onChange={(e) => setRegisterData({ ...registerData, district: e.target.value })}
                        placeholder="e.g. Satara"
                        className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                    <div>
                      <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                        Mobile Number
                      </label>
                      <input
                        type="tel"
                        required
                        value={registerData.phone_number}
                        onChange={(e) => setRegisterData({ ...registerData, phone_number: e.target.value })}
                        placeholder="10-digit mobile"
                        className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                    <div>
                      <label className="block font-serif-zen text-xs font-medium text-[#38332C] mb-1">
                        Password
                      </label>
                      <input
                        type="password"
                        required
                        value={registerData.password}
                        onChange={(e) => setRegisterData({ ...registerData, password: e.target.value })}
                        placeholder="••••••••"
                        className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-[6px] text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all"
                      />
                    </div>
                  </div>

                  <div className="pt-2">
                    <button
                      type="submit"
                      className="w-full bg-[#222222] hover:bg-[#111111] text-white py-3 rounded-[6px] text-sm font-medium tracking-wide transition-all shadow-xs active:scale-[0.99] cursor-pointer"
                    >
                      Create account
                    </button>
                  </div>
                </form>
              </div>
            )}
          </div>

          {/* Thin Hairline Divider & Bottom Mode Switcher */}
          <div className="mt-8 pt-4 border-t border-[#E3D9CA] text-xs text-[#6B6256] flex items-center justify-between">
            {mode === 'login' ? (
              <p>
                Don't have an account?{' '}
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer ml-1"
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
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer ml-1"
                >
                  Log in
                </button>
              </p>
            )}

            <span className="text-[11px] text-[#A39B8E] hidden sm:inline">
              UX4G Public Standard
            </span>
          </div>

        </div>

        {/* ========================================================= */}
        {/* RIGHT COLUMN: DREAMCATCHER WATERCOLOR ARTWORK & WIND      */}
        {/* ========================================================= */}
        <div className="hidden lg:block lg:col-span-6 relative min-h-[550px] overflow-hidden">
          {/* Main Watercolor Artwork Image */}
          <img
            src="/dreamcatcher_wind.jpg"
            alt="DreamCatcher floating in the morning breeze over river landscape"
            className="w-full h-full object-cover object-center transform scale-[1.02] transition-transform duration-1000 ease-out hover:scale-100"
          />

          {/* Seamless Feathered Gradient Mask (Left to Right Blend from Card Cream) */}
          <div className="absolute inset-0 bg-gradient-to-r from-[#F4EFE6] via-[#F4EFE6]/50 via-20% to-transparent pointer-events-none" />

          {/* Edge Softening */}
          <div className="absolute inset-0 bg-gradient-to-t from-[#F4EFE6]/30 via-transparent to-[#F4EFE6]/20 pointer-events-none" />

          {/* Swaying Dreamcatchers and Fluttering Wind Feathers Animation */}
          <DreamCatcherWind showDreamcatchers={true} featherCount={14} windSpeed={1.2} opacity={0.9} />

          {/* Poetic Mission Caption */}
          <div className="absolute bottom-6 right-6 text-right z-10 pointer-events-none bg-white/40 backdrop-blur-xs px-3.5 py-2 rounded-xl border border-white/40 shadow-xs">
            <span className="font-serif-zen italic text-xs text-[#332C24] block font-medium">
              "Catching every village dream, guiding every child."
            </span>
            <span className="text-[10px] text-[#5C5245] uppercase tracking-wider font-semibold">
              DreamCatcher • Govt Field Guidance
            </span>
          </div>
        </div>

      </div>

    </div>
  );
}
