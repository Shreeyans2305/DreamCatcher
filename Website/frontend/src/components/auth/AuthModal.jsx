import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { useLanguage } from '../../context/LanguageContext';
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
  X, 
  Sparkles,
  Zap,
  GraduationCap
} from 'lucide-react';

export default function AuthModal({ initialMode = 'login', isOpen, onClose }) {
  const { login, register, setIsCredentialModalOpen } = useAuth();
  const { t, languageOptions } = useLanguage();

  const [mode, setMode] = useState(initialMode); // 'login' | 'register'
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

  if (!isOpen) return null;

  const roleOptions = [
    { value: 'teacher', label: t('auth.role_teacher') },
    { value: 'govt_officer', label: t('auth.role_govt') },
    { value: 'ngo_staff', label: t('auth.role_ngo') }
  ];

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    login(loginId, loginPassword);
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
    <div className="fixed inset-0 bg-slate-950/70 backdrop-blur-xs flex items-center justify-center p-3 sm:p-5 z-50 overflow-y-auto">
      <div className="bg-white rounded-3xl shadow-2xl max-w-4xl w-full overflow-hidden border border-slate-200/80 my-auto grid grid-cols-1 md:grid-cols-12 min-h-[580px] animate-in fade-in duration-200">
        
        {/* ============================================================ */}
        {/* LEFT COLUMN: HERO SHOWCASE (Dribbble Split-Screen Pattern)   */}
        {/* ============================================================ */}
        <div className="md:col-span-5 bg-gradient-to-br from-[#173F6B] via-[#0D2E50] to-[#1E3A8A] text-white p-6 sm:p-8 flex flex-col justify-between relative overflow-hidden">
          
          {/* Subtle geometric background accents (Clean, no weird blur effects) */}
          <div className="absolute top-0 right-0 w-64 h-64 bg-sky-500/10 rounded-full blur-2xl pointer-events-none" />
          <div className="absolute bottom-0 left-0 w-48 h-48 bg-amber-500/10 rounded-full blur-xl pointer-events-none" />

          {/* Top Branding */}
          <div className="relative z-10">
            <div className="flex items-center gap-2.5 mb-6">
              <div className="w-11 h-11 rounded-xl bg-amber-400 text-slate-950 flex items-center justify-center font-bold shadow-md">
                <Compass className="w-6 h-6" />
              </div>
              <div>
                <span className="font-extrabold text-xl tracking-tight font-indic text-white">
                  {t('brand')}
                </span>
                <span className="block text-[11px] text-sky-200 font-medium font-indic">
                  National Field Counselor Network
                </span>
              </div>
            </div>

            {/* Headline & Mission */}
            <h2 className="text-xl sm:text-2xl font-extrabold leading-snug font-indic text-white mb-3">
              Guiding Every Dream, Across Every Village.
            </h2>
            <p className="text-xs text-sky-100/85 leading-relaxed font-indic">
              Connecting rural students to personalized career pathways, polytechnic admissions, and government welfare scholarships through multilingual AI.
            </p>
          </div>

          {/* Center Showcase Graphic Badge */}
          <div className="my-6 relative z-10">
            <div className="bg-[#0D2E50]/90 border border-sky-400/30 rounded-2xl p-4 shadow-lg space-y-3">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-lg bg-amber-500/20 text-amber-400 flex items-center justify-center font-bold">
                  <GraduationCap className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs font-bold text-white font-indic">Public Welfare Impact</div>
                  <div className="text-[11px] text-emerald-400 font-medium flex items-center gap-1">
                    <CheckCircle2 className="w-3 h-3" />
                    <span>Verified Schemes & Direct DBT</span>
                  </div>
                </div>
              </div>

              {/* Verified Metrics Chips */}
              <div className="grid grid-cols-2 gap-2 pt-1 border-t border-sky-900/60 text-[11px]">
                <div className="bg-sky-950/70 p-2 rounded-lg border border-sky-800/40">
                  <span className="text-[10px] text-sky-300 block uppercase font-bold">Students Reached</span>
                  <span className="text-sm font-extrabold text-white">45,000+</span>
                </div>
                <div className="bg-sky-950/70 p-2 rounded-lg border border-sky-800/40">
                  <span className="text-[10px] text-amber-300 block uppercase font-bold">Camps Run</span>
                  <span className="text-sm font-extrabold text-white">3,400+</span>
                </div>
              </div>
            </div>
          </div>

          {/* Bottom Social Proof / Testimonial */}
          <div className="relative z-10 pt-3 border-t border-sky-900/60">
            <p className="text-[11px] text-sky-100 italic font-indic line-clamp-3">
              "We registered 42 students in 2 hours and mapped each to MahaDBT scholarships without any paperwork bottleneck."
            </p>
            <div className="mt-2 text-[10px] text-sky-300 font-semibold font-indic">
              — Anand Kulkarni, ZP School Teacher, Satara
            </div>
          </div>

        </div>

        {/* ============================================================ */}
        {/* RIGHT COLUMN: INTERACTIVE FORM (Sign In / Sign Up)          */}
        {/* ============================================================ */}
        <div className="md:col-span-7 p-6 sm:p-8 flex flex-col justify-between bg-white relative">
          
          {/* Close button */}
          <button
            onClick={onClose}
            className="absolute top-5 right-5 p-1.5 text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-full transition-colors"
          >
            <X className="w-5 h-5" />
          </button>

          <div>
            {/* Segmented Tab Switcher (Dribbble Styled Pills) */}
            <div className="flex bg-slate-100 p-1 rounded-xl mb-6 max-w-xs border border-slate-200/80">
              <button
                type="button"
                onClick={() => setMode('login')}
                className={`flex-1 py-2 text-xs font-bold rounded-lg transition-all font-indic ${
                  mode === 'login'
                    ? 'bg-[#173F6B] text-white shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                {t('auth.login_title')}
              </button>
              <button
                type="button"
                onClick={() => setMode('register')}
                className={`flex-1 py-2 text-xs font-bold rounded-lg transition-all font-indic ${
                  mode === 'register'
                    ? 'bg-[#173F6B] text-white shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                {t('auth.register_title')}
              </button>
            </div>

            {/* Mode Title & Subtitle */}
            <div className="mb-5">
              <h1 className="text-xl font-extrabold text-slate-900 font-indic">
                {mode === 'login' ? 'Welcome Back, Counselor' : 'Volunteer Self-Registration'}
              </h1>
              <p className="text-xs text-slate-500 font-indic mt-1">
                {mode === 'login'
                  ? 'Sign in with your Volunteer ID or registered mobile number.'
                  : 'Register as a teacher, government officer, or NGO staff to begin running guidance camps.'}
              </p>
            </div>

            {/* ---------------------------------------------------- */}
            {/* SIGN IN FORM                                         */}
            {/* ---------------------------------------------------- */}
            {mode === 'login' ? (
              <form onSubmit={handleLoginSubmit} className="space-y-4">
                
                {/* Volunteer ID / Phone Input */}
                <div>
                  <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5 font-indic">
                    {t('header.volunteer_id')} / Mobile Number
                  </label>
                  <div className="relative">
                    <User className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
                    <input
                      type="text"
                      required
                      value={loginId}
                      onChange={(e) => setLoginId(e.target.value)}
                      placeholder="e.g. DC-VOL-2026-00042 or 9822014589"
                      className="w-full pl-10 pr-3 py-2.5 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] focus:border-transparent font-medium font-indic bg-slate-50/50"
                    />
                  </div>
                </div>

                {/* Password Input */}
                <div>
                  <div className="flex items-center justify-between mb-1.5">
                    <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider font-indic">
                      {t('auth.password')}
                    </label>
                    <button
                      type="button"
                      onClick={() => alert('For this demonstration, use your Volunteer ID or click Quick Demo Login.')}
                      className="text-[11px] text-[#173F6B] hover:underline font-semibold font-indic"
                    >
                      Forgot ID?
                    </button>
                  </div>
                  <div className="relative">
                    <Key className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
                    <input
                      type={showPassword ? 'text' : 'password'}
                      required
                      value={loginPassword}
                      onChange={(e) => setLoginPassword(e.target.value)}
                      placeholder="••••••••"
                      className="w-full pl-10 pr-10 py-2.5 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] focus:border-transparent font-medium bg-slate-50/50"
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-3 top-3 text-slate-400 hover:text-slate-600 p-0.5"
                    >
                      {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>

                {/* Remember Me Checkbox */}
                <div className="flex items-center justify-between pt-1">
                  <label className="flex items-center gap-2 cursor-pointer text-xs font-medium text-slate-700 font-indic">
                    <input
                      type="checkbox"
                      checked={rememberMe}
                      onChange={(e) => setRememberMe(e.target.checked)}
                      className="h-4 w-4 rounded border-slate-300 text-[#173F6B] focus:ring-[#173F6B]"
                    />
                    <span>Remember this session on device</span>
                  </label>
                </div>

                {/* Sign In Button */}
                <button
                  type="submit"
                  className="w-full py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white font-bold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-all touch-target mt-2 font-indic"
                >
                  <span>{t('auth.login_btn')}</span>
                  <ArrowRight className="w-4 h-4 text-amber-400" />
                </button>

                {/* Quick Demo Login Pill */}
                <div className="pt-2">
                  <button
                    type="button"
                    onClick={handleQuickDemoLogin}
                    className="w-full py-2 bg-amber-50 hover:bg-amber-100 text-amber-900 border border-amber-300/80 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-colors font-indic"
                  >
                    <Zap className="w-3.5 h-3.5 text-amber-600" />
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
                  <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                    {t('auth.full_name')} *
                  </label>
                  <div className="relative">
                    <User className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
                    <input
                      type="text"
                      required
                      value={registerData.full_name}
                      onChange={(e) => setRegisterData({ ...registerData, full_name: e.target.value })}
                      placeholder="e.g. Ramesh Govind Patil"
                      className="w-full pl-9 pr-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
                    />
                  </div>
                </div>

                {/* Role Category */}
                <div>
                  <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                    {t('auth.role_type')} *
                  </label>
                  <select
                    value={registerData.role_type}
                    onChange={(e) => setRegisterData({ ...registerData, role_type: e.target.value })}
                    className="w-full px-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-indic bg-white"
                  >
                    {roleOptions.map(r => (
                      <option key={r.value} value={r.value}>{r.label}</option>
                    ))}
                  </select>
                </div>

                {/* Organization */}
                <div>
                  <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                    {t('auth.org_name')} *
                  </label>
                  <div className="relative">
                    <Building2 className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
                    <input
                      type="text"
                      required
                      value={registerData.organization_name}
                      onChange={(e) => setRegisterData({ ...registerData, organization_name: e.target.value })}
                      placeholder="e.g. ZP High School / Taluka Education Office"
                      className="w-full pl-9 pr-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
                    />
                  </div>
                </div>

                {/* Mobile & District */}
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                      {t('auth.phone')} *
                    </label>
                    <input
                      type="tel"
                      required
                      value={registerData.phone_number}
                      onChange={(e) => setRegisterData({ ...registerData, phone_number: e.target.value })}
                      placeholder="10-digit mobile"
                      className="w-full px-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-medium"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                      {t('camps.district')} *
                    </label>
                    <input
                      type="text"
                      required
                      value={registerData.district}
                      onChange={(e) => setRegisterData({ ...registerData, district: e.target.value })}
                      placeholder="e.g. Satara / Pune"
                      className="w-full px-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-medium font-indic"
                    />
                  </div>
                </div>

                {/* Preferred Language & Password */}
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1 font-indic">
                      {t('auth.preferred_ui_lang')}
                    </label>
                    <select
                      value={registerData.preferred_ui_language}
                      onChange={(e) => setRegisterData({ ...registerData, preferred_ui_language: e.target.value })}
                      className="w-full px-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-indic bg-white"
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
                      value={registerData.password}
                      onChange={(e) => setRegisterData({ ...registerData, password: e.target.value })}
                      placeholder="••••••••"
                      className="w-full px-3 py-2 text-sm border border-slate-300 rounded-xl focus:ring-2 focus:ring-[#173F6B] font-medium"
                    />
                  </div>
                </div>

                {/* Submit Registration Button */}
                <button
                  type="submit"
                  className="w-full py-3 bg-amber-500 hover:bg-amber-600 text-slate-950 font-extrabold text-sm rounded-xl shadow-md flex items-center justify-center gap-2 transition-all touch-target mt-2 font-indic"
                >
                  <Award className="w-4 h-4 text-slate-950" />
                  <span>{t('auth.register_btn')}</span>
                </button>

              </form>
            )}

          </div>

          {/* Bottom Switcher Prompt */}
          <div className="pt-4 mt-2 border-t border-slate-100 text-center text-xs text-slate-600 font-indic">
            {mode === 'login' ? (
              <span>
                New volunteer coordinator?{' '}
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className="font-bold text-[#173F6B] hover:underline"
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
                  className="font-bold text-[#173F6B] hover:underline"
                >
                  Sign In here
                </button>
              </span>
            )}
          </div>

        </div>

      </div>
    </div>
  );
}
