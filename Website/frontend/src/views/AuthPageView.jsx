import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';
import { 
  Compass, 
  ShieldCheck, 
  User, 
  Key, 
  Phone, 
  Building2, 
  MapPin, 
  Globe, 
  Eye, 
  EyeOff, 
  ArrowRight, 
  CheckCircle2, 
  Award, 
  Sparkles,
  Zap,
  GraduationCap
} from 'lucide-react';

export default function AuthPageView({ onLoginSuccess }) {
  const { login, register } = useAuth();
  const { t, uiLanguage, setLanguage, languageOptions } = useLanguage();

  const [mode, setMode] = useState('login'); // 'login' | 'register'
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(true);

  // Login form state
  const [loginId, setLoginId] = useState('DC-VOL-2026-00042');
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
    { value: 'teacher', label: t('auth.role_teacher') },
    { value: 'govt_officer', label: t('auth.role_govt') },
    { value: 'ngo_staff', label: t('auth.role_ngo') }
  ];

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    login(loginId, loginPassword);
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
    <div className="min-h-screen bg-[#F8F1EC] text-[#2A1517] font-indic flex flex-col justify-between selection:bg-[#3D2123] selection:text-[#F8F1EC]">
      
      {/* Top Navigation Bar */}
      <header className="w-full bg-[#3D2123] text-white px-4 sm:px-8 py-3.5 shadow-md flex items-center justify-between border-b border-[#2A1517]">
        <div className="flex items-center gap-2.5">
          <div className="w-9 h-9 rounded-lg bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center font-bold shadow-sm">
            <Compass className="w-5 h-5" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <span className="font-extrabold text-base sm:text-lg tracking-tight font-indic text-[#F8F1EC]">
                {t('brand')}
              </span>
              <span className="bg-[#EBD1C6]/20 text-[#EBD1C6] text-[10px] px-2 py-0.5 rounded font-bold border border-[#EBD1C6]/30">
                Govt / Field Portal
              </span>
            </div>
          </div>
        </div>

        {/* Language Selector */}
        <div className="flex items-center gap-2">
          <div className="flex items-center bg-[#2A1517] border border-[#EBD1C6]/30 rounded-lg px-2.5 py-1.5 text-xs">
            <Globe className="w-3.5 h-3.5 text-[#EBD1C6] mr-1.5 shrink-0" />
            <select
              value={uiLanguage}
              onChange={(e) => setLanguage(e.target.value)}
              aria-label="Portal Language Selection"
              className="bg-transparent text-[#F8F1EC] font-semibold cursor-pointer focus:outline-none font-indic"
            >
              {languageOptions.map(opt => (
                <option key={opt.code} value={opt.code} className="text-[#3D2123] bg-[#F8F1EC] font-indic">
                  {opt.nativeLabel} ({opt.code.toUpperCase()})
                </option>
              ))}
            </select>
          </div>
        </div>
      </header>

      {/* Main Full-Screen Split Card Container */}
      <main className="flex-1 flex items-center justify-center p-3 sm:p-6 lg:p-10">
        <div className="bg-white rounded-3xl shadow-2xl max-w-5xl w-full overflow-hidden border border-[#EBD1C6] grid grid-cols-1 lg:grid-cols-12 min-h-[620px]">
          
          {/* ============================================================ */}
          {/* LEFT COLUMN: HERO SHOWCASE (Mahogany & Rose Sand)           */}
          {/* ============================================================ */}
          <div className="lg:col-span-5 bg-gradient-to-br from-[#3D2123] via-[#2A1517] to-[#3D2123] text-white p-6 sm:p-10 flex flex-col justify-between relative overflow-hidden">
            
            {/* Subtle Clean Accents */}
            <div className="absolute top-0 right-0 w-64 h-64 bg-[#EBD1C6]/10 rounded-full blur-2xl pointer-events-none" />
            <div className="absolute bottom-0 left-0 w-48 h-48 bg-[#A83E28]/10 rounded-full blur-xl pointer-events-none" />

            {/* Top Branding & Mission */}
            <div className="relative z-10">
              <div className="inline-flex items-center gap-2 bg-[#EBD1C6]/15 text-[#EBD1C6] text-xs px-3 py-1 rounded-full border border-[#EBD1C6]/30 font-bold mb-4 font-indic">
                <Sparkles className="w-3.5 h-3.5 text-[#EBD1C6]" />
                <span>Multilingual Guidance Platform</span>
              </div>

              <h2 className="text-2xl sm:text-3xl font-extrabold leading-tight font-indic text-[#F8F1EC] mb-3">
                Guiding Every Dream, Across Every Village.
              </h2>
              <p className="text-xs sm:text-sm text-[#F8F1EC]/85 leading-relaxed font-indic">
                Empowering field volunteers, teachers, and officers to deliver rapid career counseling, vocational matching, and welfare scholarship eligibility to rural students.
              </p>
            </div>

            {/* Center Verified Stats Card */}
            <div className="my-6 relative z-10">
              <div className="bg-[#2A1517]/90 border border-[#EBD1C6]/30 rounded-2xl p-4 sm:p-5 shadow-lg space-y-3">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-[#EBD1C6]/20 text-[#EBD1C6] flex items-center justify-center font-bold">
                    <GraduationCap className="w-6 h-6" />
                  </div>
                  <div>
                    <div className="text-xs font-bold text-white font-indic">Public Welfare Delivery</div>
                    <div className="text-[11px] text-emerald-400 font-medium flex items-center gap-1">
                      <CheckCircle2 className="w-3 h-3" />
                      <span>Direct Scholarship Matching & DBT</span>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-2 pt-2 border-t border-[#4E5458]/60 text-xs">
                  <div className="bg-[#3D2123] p-2.5 rounded-xl border border-[#4E5458]">
                    <span className="text-[10px] text-[#EBD1C6] block uppercase font-bold">Students Guided</span>
                    <span className="text-base font-extrabold text-white">45,000+</span>
                  </div>
                  <div className="bg-[#3D2123] p-2.5 rounded-xl border border-[#4E5458]">
                    <span className="text-[10px] text-[#EBD1C6] block uppercase font-bold">Active Camps</span>
                    <span className="text-base font-extrabold text-white">3,400+</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Bottom Proof Quote */}
            <div className="relative z-10 pt-3 border-t border-[#4E5458]/60">
              <p className="text-xs text-[#EBD1C6] italic font-indic">
                "DreamCatcher helped our village school connect 40+ 10th-grade students to Govt ITI and Polytechnic seats in a single afternoon."
              </p>
              <div className="mt-2 text-[11px] text-[#EBD1C6]/80 font-semibold font-indic">
                — Anand Kulkarni, ZP High School Teacher, Satara
              </div>
            </div>

          </div>

          {/* ============================================================ */}
          {/* RIGHT COLUMN: INTERACTIVE FORM (Sign In / Register)         */}
          {/* ============================================================ */}
          <div className="lg:col-span-7 p-6 sm:p-10 flex flex-col justify-between bg-white">
            
            <div>
              {/* Segmented Pill Switcher */}
              <div className="flex bg-[#F8F1EC] p-1.5 rounded-2xl mb-6 max-w-sm border border-[#EBD1C6] shadow-inner">
                <button
                  type="button"
                  onClick={() => setMode('login')}
                  className={`flex-1 py-2.5 text-xs sm:text-sm font-extrabold rounded-xl transition-all font-indic touch-target ${
                    mode === 'login'
                      ? 'bg-[#3D2123] text-white shadow-md'
                      : 'text-[#4E5458] hover:text-[#2A1517]'
                  }`}
                >
                  {t('auth.login_title')}
                </button>
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className={`flex-1 py-2.5 text-xs sm:text-sm font-extrabold rounded-xl transition-all font-indic touch-target ${
                    mode === 'register'
                      ? 'bg-[#3D2123] text-white shadow-md'
                      : 'text-[#4E5458] hover:text-[#2A1517]'
                  }`}
                >
                  {t('auth.register_title')}
                </button>
              </div>

              {/* Form Title & Subtitle */}
              <div className="mb-6">
                <h1 className="text-2xl font-extrabold text-[#3D2123] font-indic">
                  {mode === 'login' ? 'Field Volunteer Sign In' : 'Field Volunteer Registration'}
                </h1>
                <p className="text-xs sm:text-sm text-[#4E5458] font-indic mt-1">
                  {mode === 'login'
                    ? 'Enter your unique Volunteer ID or registered mobile number to access camp registries.'
                    : 'Register as a teacher, government officer, or NGO staff to begin organizing guidance camps.'}
                </p>
              </div>

              {/* ---------------------------------------------------- */}
              {/* SIGN IN FORM                                         */}
              {/* ---------------------------------------------------- */}
              {mode === 'login' ? (
                <form onSubmit={handleLoginSubmit} className="space-y-4">
                  
                  {/* ID / Phone Input */}
                  <div>
                    <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1.5 font-indic">
                      {t('header.volunteer_id')} / Mobile Number
                    </label>
                    <div className="relative">
                      <User className="w-4 h-4 text-[#4E5458] absolute left-3.5 top-3.5" />
                      <input
                        type="text"
                        required
                        value={loginId}
                        onChange={(e) => setLoginId(e.target.value)}
                        placeholder="e.g. DC-VOL-2026-00042 or 9822014589"
                        className="w-full pl-10 pr-3 py-3 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium font-indic bg-[#F8F1EC]/40"
                      />
                    </div>
                  </div>

                  {/* Password Input */}
                  <div>
                    <div className="flex items-center justify-between mb-1.5">
                      <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider font-indic">
                        {t('auth.password')}
                      </label>
                      <button
                        type="button"
                        onClick={() => alert('Default demo password is: password123')}
                        className="text-xs text-[#A83E28] hover:underline font-semibold font-indic"
                      >
                        Forgot Password?
                      </button>
                    </div>
                    <div className="relative">
                      <Key className="w-4 h-4 text-[#4E5458] absolute left-3.5 top-3.5" />
                      <input
                        type={showPassword ? 'text' : 'password'}
                        required
                        value={loginPassword}
                        onChange={(e) => setLoginPassword(e.target.value)}
                        placeholder="••••••••"
                        className="w-full pl-10 pr-10 py-3 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium bg-[#F8F1EC]/40"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute right-3 top-3.5 text-[#4E5458] hover:text-[#2A1517] p-0.5"
                      >
                        {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  {/* Remember Me */}
                  <div className="flex items-center justify-between pt-1">
                    <label className="flex items-center gap-2 cursor-pointer text-xs font-medium text-[#4E5458] font-indic">
                      <input
                        type="checkbox"
                        checked={rememberMe}
                        onChange={(e) => setRememberMe(e.target.checked)}
                        className="h-4 w-4 rounded border-[#EBD1C6] text-[#3D2123] focus:ring-[#3D2123]"
                      />
                      <span>Remember this session on this device</span>
                    </label>
                  </div>

                  {/* Sign In Button */}
                  <button
                    type="submit"
                    className="w-full py-3.5 bg-[#3D2123] hover:bg-[#2A1517] text-white font-extrabold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-all touch-target mt-3 font-indic"
                  >
                    <span>{t('auth.login_btn')}</span>
                    <ArrowRight className="w-4 h-4 text-[#EBD1C6]" />
                  </button>

                  {/* Quick Demo One-Click Sign In */}
                  <div className="pt-2">
                    <button
                      type="button"
                      onClick={handleQuickDemoLogin}
                      className="w-full py-2.5 bg-[#EBD1C6]/30 hover:bg-[#EBD1C6]/60 text-[#3D2123] border border-[#EBD1C6] rounded-xl text-xs font-extrabold flex items-center justify-center gap-1.5 transition-colors font-indic touch-target"
                    >
                      <Zap className="w-4 h-4 text-[#A83E28]" />
                      <span>⚡ Quick Demo Sign In as Anand Kulkarni (Satara)</span>
                    </button>
                  </div>

                </form>
              ) : (
                /* ---------------------------------------------------- */
                /* SIGN UP / REGISTRATION FORM                          */
                /* ---------------------------------------------------- */
                <form onSubmit={handleRegisterSubmit} className="space-y-3.5">
                  
                  {/* Full Name */}
                  <div>
                    <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                      {t('auth.full_name')} *
                    </label>
                    <div className="relative">
                      <User className="w-4 h-4 text-[#4E5458] absolute left-3 top-3" />
                      <input
                        type="text"
                        required
                        value={registerData.full_name}
                        onChange={(e) => setRegisterData({ ...registerData, full_name: e.target.value })}
                        placeholder="e.g. Ramesh Govind Patil"
                        className="w-full pl-9 pr-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium font-indic"
                      />
                    </div>
                  </div>

                  {/* Role Category */}
                  <div>
                    <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                      {t('auth.role_type')} *
                    </label>
                    <select
                      value={registerData.role_type}
                      onChange={(e) => setRegisterData({ ...registerData, role_type: e.target.value })}
                      className="w-full px-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-indic bg-white"
                    >
                      {roleOptions.map(r => (
                        <option key={r.value} value={r.value}>{r.label}</option>
                      ))}
                    </select>
                  </div>

                  {/* Organization */}
                  <div>
                    <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                      {t('auth.org_name')} *
                    </label>
                    <div className="relative">
                      <Building2 className="w-4 h-4 text-[#4E5458] absolute left-3 top-3" />
                      <input
                        type="text"
                        required
                        value={registerData.organization_name}
                        onChange={(e) => setRegisterData({ ...registerData, organization_name: e.target.value })}
                        placeholder="e.g. ZP High School / Taluka Education Office"
                        className="w-full pl-9 pr-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium font-indic"
                      />
                    </div>
                  </div>

                  {/* Mobile & District */}
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                        {t('auth.phone')} *
                      </label>
                      <input
                        type="tel"
                        required
                        value={registerData.phone_number}
                        onChange={(e) => setRegisterData({ ...registerData, phone_number: e.target.value })}
                        placeholder="10-digit mobile"
                        className="w-full px-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                        {t('camps.district')} *
                      </label>
                      <input
                        type="text"
                        required
                        value={registerData.district}
                        onChange={(e) => setRegisterData({ ...registerData, district: e.target.value })}
                        placeholder="e.g. Satara / Pune"
                        className="w-full px-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium font-indic"
                      />
                    </div>
                  </div>

                  {/* Preferred Language & Password */}
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                        {t('auth.preferred_ui_lang')}
                      </label>
                      <select
                        value={registerData.preferred_ui_language}
                        onChange={(e) => setRegisterData({ ...registerData, preferred_ui_language: e.target.value })}
                        className="w-full px-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-indic bg-white"
                      >
                        {languageOptions.map(l => (
                          <option key={l.code} value={l.code}>{l.nativeLabel} ({l.code.toUpperCase()})</option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1 font-indic">
                        {t('auth.password')} *
                      </label>
                      <input
                        type="password"
                        required
                        value={registerData.password}
                        onChange={(e) => setRegisterData({ ...registerData, password: e.target.value })}
                        placeholder="••••••••"
                        className="w-full px-3 py-2 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium"
                      />
                    </div>
                  </div>

                  {/* Submit Registration Button */}
                  <button
                    type="submit"
                    className="w-full py-3.5 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-all touch-target mt-3 font-indic"
                  >
                    <Award className="w-4 h-4 text-white" />
                    <span>{t('auth.register_btn')}</span>
                  </button>

                </form>
              )}

            </div>

            {/* Bottom Switcher */}
            <div className="pt-4 mt-2 border-t border-[#EBD1C6]/40 text-center text-xs text-[#4E5458] font-indic">
              {mode === 'login' ? (
                <span>
                  New volunteer coordinator?{' '}
                  <button
                    type="button"
                    onClick={() => setMode('register')}
                    className="font-bold text-[#3D2123] hover:underline"
                  >
                    Create an Account
                  </button>
                </span>
              ) : (
                <span>
                  Already have a Volunteer ID?{' '}
                  <button
                    type="button"
                    onClick={() => setMode('login')}
                    className="font-bold text-[#3D2123] hover:underline"
                  >
                    Sign In here
                  </button>
                </span>
              )}
            </div>

          </div>

        </div>
      </main>

      {/* Field Footer */}
      <footer className="w-full bg-[#2A1517] text-[#EBD1C6]/80 border-t border-[#3D2123] py-3.5 px-4 text-center text-xs font-indic">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-2">
          <span>DreamCatcher — Multilingual Public AI Career Guidance Field Platform</span>
          <span className="text-[#EBD1C6]/60">Offline-Ready PWA • UX4G Indic Design Standard</span>
        </div>
      </footer>

    </div>
  );
}
