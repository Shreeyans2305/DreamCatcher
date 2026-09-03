import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useAdminAuth } from '../context/AdminAuthContext';
import { isSupabaseConfigured } from '../services/supabaseClient';
import { generateGovernmentId, generateTemporaryPassword, PREAPPROVED_NGOS } from '../utils/credentialGenerator';
import { sendAdminCredentialEmail } from '../services/emailService';
import DreamCatcherWind from '../components/ui/DreamCatcherWind';
import DreamCatcherIcon from '../components/ui/DreamCatcherIcon';
import { 
  Mail, Lock, User, Building, MapPin, Phone, 
  ArrowRight, ShieldCheck, CheckCircle2, AlertCircle, HeartHandshake, Key, Copy
} from 'lucide-react';

export default function AuthPageView({ onLoginSuccess }) {
  const { login: legacyLogin, register: legacyRegister } = useAuth();
  const { signIn: supabaseSignIn, signUp: supabaseSignUp, loading: adminLoading } = useAdminAuth();

  const [mode, setMode] = useState('login'); // 'login' | 'register'
  const [errorMessage, setErrorMessage] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [issuedCredentials, setIssuedCredentials] = useState(null);
  const [copied, setCopied] = useState(false);

  // Login Form Data
  const [loginData, setLoginData] = useState({
    email_or_phone: '',
    password: ''
  });

  // Register Form Data
  const [registerData, setRegisterData] = useState({
    full_name: '',
    email: '',
    phone_number: '',
    role_type: 'government_officer', // 'government_officer' | 'ngo_volunteer' | 'school_teacher'
    ngoCode: 'PRATHAM',
    customNgoName: '',
    organization_name: 'School Education Department, MH',
    district: 'Satara',
    state: 'Maharashtra',
    password: '',
    autoGeneratePassword: true
  });

  // Live Auto-Generated ID Preview
  const [liveGeneratedId, setLiveGeneratedId] = useState('');

  useEffect(() => {
    const generated = generateGovernmentId({
      entityType: registerData.role_type,
      ngoCode: registerData.ngoCode,
      customNgoName: registerData.customNgoName,
      state: registerData.state,
      district: registerData.district
    });
    setLiveGeneratedId(generated);
  }, [registerData.role_type, registerData.ngoCode, registerData.customNgoName, registerData.state, registerData.district]);

  const handleRoleChange = (roleVal) => {
    setRegisterData(prev => {
      let org = prev.organization_name;
      if (roleVal === 'ngo_volunteer') org = 'Pratham Education Foundation';
      else if (roleVal === 'school_teacher') org = 'Zilla Parishad High School';
      else org = 'School Education Department, MH';
      return { ...prev, role_type: roleVal, organization_name: org };
    });
  };

  const handleLoginSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage('');
    setIsSubmitting(true);

    try {
      if (isSupabaseConfigured()) {
        await supabaseSignIn(loginData.email_or_phone, loginData.password);
      }
      legacyLogin(loginData.email_or_phone, loginData.password);
      if (onLoginSuccess) onLoginSuccess();
    } catch (err) {
      setErrorMessage(err.message || 'Login failed. Please check your credentials.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleRegisterSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage('');
    setIsSubmitting(true);

    try {
      if (!registerData.full_name || !registerData.email) {
        throw new Error('Please enter your full name and email.');
      }

      const officialBadgeId = liveGeneratedId;
      const passwordToUse = registerData.autoGeneratePassword
        ? generateTemporaryPassword()
        : registerData.password;

      if (!passwordToUse || passwordToUse.length < 6) {
        throw new Error('Password must be at least 6 characters.');
      }

      if (isSupabaseConfigured()) {
        await supabaseSignUp({
          email: registerData.email,
          password: passwordToUse,
          government_id: officialBadgeId,
          name: registerData.full_name,
          mobile_number: registerData.phone_number || '9876543210',
          organization_name: registerData.organization_name,
          district: registerData.district,
          state: registerData.state
        });
      } else {
        await legacyRegister({
          ...registerData,
          government_id: officialBadgeId,
          password: passwordToUse
        });
      }

      // Dispatch credential email
      await sendAdminCredentialEmail({
        email: registerData.email,
        name: registerData.full_name,
        government_id: officialBadgeId,
        temp_password: passwordToUse,
        district: registerData.district,
        state: registerData.state,
        entityType: registerData.role_type,
        organization_name: registerData.organization_name
      });

      // Show credentials overlay modal
      setIssuedCredentials({
        badgeId: officialBadgeId,
        password: passwordToUse,
        email: registerData.email,
        name: registerData.full_name
      });

    } catch (err) {
      setErrorMessage(err.message || 'Registration failed. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="min-h-screen bg-[#EFEADF] text-[#222222] font-indic selection:bg-[#3D2123] selection:text-white flex items-center justify-center p-3 sm:p-6 lg:p-10 relative overflow-hidden">
      
      {/* Background Subtle Accent Watermarks */}
      <div className="absolute top-10 left-10 w-72 h-72 bg-[#E3D9CA]/40 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-10 right-10 w-96 h-96 bg-[#D5CCBD]/30 rounded-full blur-3xl pointer-events-none" />

      {/* Main Split-Screen Canvas Card */}
      <div className="w-full max-w-5xl bg-[#F4EFE6] border border-[#DECBC7] rounded-3xl shadow-2xl overflow-hidden grid grid-cols-1 lg:grid-cols-12 relative z-10 my-auto">
        
        {/* ========================================================= */}
        {/* LEFT COLUMN: AUTHENTICATION FORM (JANAK UI)               */}
        {/* ========================================================= */}
        <div className="lg:col-span-6 p-6 sm:p-10 flex flex-col justify-between relative bg-[#F4EFE6]">
          
          <div>
            {/* Top Brand Header with DreamCatcher Logo */}
            <div className="flex items-center mb-6">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-[#161616] text-[#FAF7F2] flex items-center justify-center p-1.5 shadow-sm">
                  <DreamCatcherIcon className="w-6 h-6 text-[#FAF7F2]" />
                </div>
                <span className="font-display font-black text-2xl tracking-tight text-[#141414]">
                  DreamCatcher
                </span>
              </div>
            </div>

            {/* Title & Description */}
            <div className="mb-6">
              <h2 className="font-serif-zen text-2xl sm:text-3xl font-bold text-[#1F1F1F] tracking-tight">
                {mode === 'login' ? 'Officer & Volunteer Sign In' : 'Register Official Credentials'}
              </h2>
              <p className="text-xs sm:text-sm text-[#5C5245] mt-1">
                {mode === 'login' 
                  ? 'Access student records, camp triaging, and AI guidance'
                  : 'Provision official Govt Officer, NGO Volunteer, or Teacher Badge'}
              </p>
            </div>

            {/* Issued Credentials Overlay (Post Signup) */}
            {issuedCredentials ? (
              <div className="bg-white border-2 border-emerald-600/40 rounded-2xl p-5 shadow-lg space-y-4 animate-in fade-in zoom-in duration-300">
                <div className="flex items-center gap-2.5 text-emerald-800">
                  <CheckCircle2 className="w-6 h-6 shrink-0 text-emerald-600" />
                  <div>
                    <h3 className="text-sm font-extrabold font-serif-zen">Credentials Provisioned!</h3>
                    <p className="text-xs text-neutral-600">Email sent to <strong>{issuedCredentials.email}</strong></p>
                  </div>
                </div>

                <div className="bg-[#F8F5EE] border border-[#DECBC7] rounded-xl p-3.5 space-y-2 text-xs">
                  <div className="flex justify-between items-center">
                    <span className="font-bold text-[#5C5245]">Official Badge ID:</span>
                    <span className="font-mono font-extrabold text-[#A83E28]">{issuedCredentials.badgeId}</span>
                  </div>
                  <div className="flex justify-between items-center border-t border-[#DECBC7]/60 pt-2">
                    <span className="font-bold text-[#5C5245]">Temporary Password:</span>
                    <span className="font-mono font-extrabold text-[#222222]">{issuedCredentials.password}</span>
                  </div>
                </div>

                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => copyToClipboard(`Badge ID: ${issuedCredentials.badgeId}\nPassword: ${issuedCredentials.password}`)}
                    className="flex-1 py-2 bg-[#F4EFE6] border border-[#D5CCBD] text-[#222222] font-bold text-xs rounded-lg flex items-center justify-center gap-1 hover:bg-[#E3D9CA] cursor-pointer"
                  >
                    <Copy className="w-3.5 h-3.5" />
                    <span>{copied ? 'Copied!' : 'Copy Info'}</span>
                  </button>

                  <button
                    type="button"
                    onClick={() => {
                      setLoginData({ email_or_phone: issuedCredentials.email, password: issuedCredentials.password });
                      setIssuedCredentials(null);
                      setMode('login');
                    }}
                    className="flex-1 py-2 bg-[#222222] hover:bg-[#111111] text-white font-bold text-xs rounded-lg flex items-center justify-center gap-1 cursor-pointer shadow-xs"
                  >
                    <span>Log in now</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            ) : (
              <>
                {/* Error Banner */}
                {errorMessage && (
                  <div className="mb-4 p-3 bg-rose-100 border border-rose-300 text-rose-800 rounded-xl text-xs flex items-center gap-2 font-medium">
                    <AlertCircle className="w-4 h-4 text-rose-600 shrink-0" />
                    <span>{errorMessage}</span>
                  </div>
                )}

                {/* 1. LOGIN FORM */}
                {mode === 'login' ? (
                  <form onSubmit={handleLoginSubmit} className="space-y-4">
                    <div>
                      <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                        Email Address or Badge ID
                      </label>
                      <div className="relative">
                        <Mail className="w-4 h-4 text-[#8C8275] absolute left-3 top-2.5" />
                        <input
                          type="text"
                          required
                          value={loginData.email_or_phone}
                          onChange={(e) => setLoginData({ ...loginData, email_or_phone: e.target.value })}
                          placeholder="anand.kulkarni@gov.in / GOV-MH-SAT-2026-0842"
                          className="w-full pl-9 pr-3.5 py-2.5 bg-transparent border border-[#D5CCBD] rounded-xl text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all font-indic"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                        Password
                      </label>
                      <div className="relative">
                        <Lock className="w-4 h-4 text-[#8C8275] absolute left-3 top-2.5" />
                        <input
                          type="password"
                          required
                          value={loginData.password}
                          onChange={(e) => setLoginData({ ...loginData, password: e.target.value })}
                          placeholder="••••••••"
                          className="w-full pl-9 pr-3.5 py-2.5 bg-transparent border border-[#D5CCBD] rounded-xl text-xs sm:text-sm text-[#1F1F1F] placeholder-[#A39B8E] focus:outline-none focus:border-[#222222] focus:bg-white/40 transition-all font-indic"
                        />
                      </div>
                    </div>

                    <button
                      type="submit"
                      disabled={isSubmitting || adminLoading}
                      className="w-full bg-[#222222] hover:bg-[#111111] text-white py-3 rounded-xl text-xs sm:text-sm font-semibold tracking-wide transition-all shadow-md active:scale-[0.99] cursor-pointer flex items-center justify-center gap-2 mt-2 font-indic"
                    >
                      <span>{isSubmitting ? 'Authenticating...' : 'Sign In to Portal'}</span>
                      <ArrowRight className="w-4 h-4" />
                    </button>
                  </form>
                ) : (
                  /* 2. REGISTER FORM */
                  <form onSubmit={handleRegisterSubmit} className="space-y-3.5">
                    
                    {/* Organization Role Selector */}
                    <div>
                      <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                        Select Role / Category *
                      </label>
                      <div className="grid grid-cols-3 gap-1.5">
                        <button
                          type="button"
                          onClick={() => handleRoleChange('government_officer')}
                          className={`py-2 px-1 rounded-lg text-xs font-bold border transition-all cursor-pointer text-center ${
                            registerData.role_type === 'government_officer'
                              ? 'bg-[#222222] text-white border-[#222222] shadow-xs'
                              : 'bg-transparent border-[#D5CCBD] text-[#38332C] hover:bg-white/50'
                          }`}
                        >
                          Govt Officer
                        </button>
                        <button
                          type="button"
                          onClick={() => handleRoleChange('ngo_volunteer')}
                          className={`py-2 px-1 rounded-lg text-xs font-bold border transition-all cursor-pointer text-center ${
                            registerData.role_type === 'ngo_volunteer'
                              ? 'bg-[#222222] text-white border-[#222222] shadow-xs'
                              : 'bg-transparent border-[#D5CCBD] text-[#38332C] hover:bg-white/50'
                          }`}
                        >
                          NGO Volunteer
                        </button>
                        <button
                          type="button"
                          onClick={() => handleRoleChange('school_teacher')}
                          className={`py-2 px-1 rounded-lg text-xs font-bold border transition-all cursor-pointer text-center ${
                            registerData.role_type === 'school_teacher'
                              ? 'bg-[#222222] text-white border-[#222222] shadow-xs'
                              : 'bg-transparent border-[#D5CCBD] text-[#38332C] hover:bg-white/50'
                          }`}
                        >
                          ZP Teacher
                        </button>
                      </div>
                    </div>

                    {/* NGO Partner Select if NGO Volunteer */}
                    {registerData.role_type === 'ngo_volunteer' && (
                      <div>
                        <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                          Select Partner NGO *
                        </label>
                        <select
                          value={registerData.ngoCode}
                          onChange={(e) => setRegisterData({ ...registerData, ngoCode: e.target.value })}
                          className="w-full px-3 py-2 bg-white/70 border border-[#D5CCBD] rounded-xl text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222] cursor-pointer"
                        >
                          {PREAPPROVED_NGOS.map(n => (
                            <option key={n.id} value={n.id}>{n.name} ({n.id})</option>
                          ))}
                        </select>
                      </div>
                    )}

                    {/* Live Generated Badge Preview Banner */}
                    <div className="p-2.5 bg-white/70 border border-[#DECBC7] rounded-xl flex items-center justify-between text-xs">
                      <span className="font-bold text-[#5C5245]">Auto Badge ID:</span>
                      <span className="font-mono font-extrabold text-[#A83E28]">{liveGeneratedId}</span>
                    </div>

                    {/* Full Name */}
                    <div>
                      <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                        Full Name *
                      </label>
                      <input
                        type="text"
                        required
                        value={registerData.full_name}
                        onChange={(e) => setRegisterData({ ...registerData, full_name: e.target.value })}
                        placeholder="Anand Kulkarni"
                        className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-xl text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40"
                      />
                    </div>

                    {/* Email & Mobile */}
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                      <div>
                        <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                          Email Address *
                        </label>
                        <input
                          type="email"
                          required
                          value={registerData.email}
                          onChange={(e) => setRegisterData({ ...registerData, email: e.target.value })}
                          placeholder="officer@gov.in"
                          className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-xl text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40"
                        />
                      </div>
                      <div>
                        <label className="block font-serif-zen text-xs font-semibold text-[#38332C] mb-1">
                          District *
                        </label>
                        <input
                          type="text"
                          required
                          value={registerData.district}
                          onChange={(e) => setRegisterData({ ...registerData, district: e.target.value })}
                          placeholder="Satara"
                          className="w-full px-3 py-2 bg-transparent border border-[#D5CCBD] rounded-xl text-xs text-[#1F1F1F] focus:outline-none focus:border-[#222222] focus:bg-white/40"
                        />
                      </div>
                    </div>

                    <button
                      type="submit"
                      disabled={isSubmitting || adminLoading}
                      className="w-full bg-[#222222] hover:bg-[#111111] text-white py-3 rounded-xl text-xs sm:text-sm font-semibold tracking-wide transition-all shadow-md cursor-pointer mt-2"
                    >
                      {isSubmitting ? 'Provisioning...' : 'Provision Badge & Send Email'}
                    </button>
                  </form>
                )}
              </>
            )}
          </div>

          {/* Mode Switcher Footer */}
          <div className="mt-6 pt-4 border-t border-[#E3D9CA] text-xs text-[#6B6256] flex items-center justify-between">
            {mode === 'login' ? (
              <p>
                Need official admin credentials?{' '}
                <button
                  type="button"
                  onClick={() => setMode('register')}
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer ml-1"
                >
                  Register Badge
                </button>
              </p>
            ) : (
              <p>
                Already have credentials?{' '}
                <button
                  type="button"
                  onClick={() => setMode('login')}
                  className="font-semibold text-[#1F1F1F] hover:underline cursor-pointer ml-1"
                >
                  Sign in
                </button>
              </p>
            )}

            <span className="text-[11px] text-[#A39B8E]">
              Supabase Auth & RLS
            </span>
          </div>

        </div>

        {/* ========================================================= */}
        {/* RIGHT COLUMN: JANAK'S WATERCOLOR ARTWORK & WIND FEATHERS  */}
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
