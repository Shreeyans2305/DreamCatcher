import React, { useState, useEffect } from 'react';
import { useAdminAuth } from '../context/AdminAuthContext';
import { isSupabaseConfigured } from '../services/supabaseClient';
import { generateGovernmentId, generateTemporaryPassword, PREAPPROVED_NGOS } from '../utils/credentialGenerator';
import { sendAdminCredentialEmail } from '../services/emailService';
import DreamCatcherIcon from '../components/ui/DreamCatcherIcon';
import { 
  Lock, Mail, ArrowRight, ShieldCheck, UserCheck, 
  AlertCircle, Building2, MapPin, Phone, User, HeartHandshake, Key, CheckCircle2, Copy 
} from 'lucide-react';

export default function AdminLoginView({ onBackToHome, onLoginSuccess }) {
  const { signIn, signUp, loading, error: authError } = useAdminAuth();
  
  const [isRegistering, setIsRegistering] = useState(false);
  const [formError, setFormError] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [issuedCredentials, setIssuedCredentials] = useState(null);
  const [copied, setCopied] = useState(false);

  // Form State
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    name: '',
    entityType: 'government_officer', // 'government_officer' | 'ngo_volunteer' | 'school_teacher'
    ngoCode: 'PRATHAM',
    customNgoName: '',
    organization_name: 'School Education Department, Maharashtra',
    district: 'Satara',
    state: 'Maharashtra',
    mobile_number: '',
    autoGeneratePassword: true
  });

  // Live Auto-Generated ID Preview
  const [liveGeneratedId, setLiveGeneratedId] = useState('');

  // Update live preview ID as role / NGO / district / state changes
  useEffect(() => {
    const generated = generateGovernmentId({
      entityType: formData.entityType,
      ngoCode: formData.ngoCode,
      customNgoName: formData.customNgoName,
      state: formData.state,
      district: formData.district
    });
    setLiveGeneratedId(generated);
  }, [formData.entityType, formData.ngoCode, formData.customNgoName, formData.state, formData.district]);

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => {
      const updated = { ...prev, [name]: type === 'checkbox' ? checked : value };
      
      // Auto-update organization name when NGO or role changes
      if (name === 'entityType') {
        if (value === 'ngo_volunteer') {
          updated.organization_name = 'Pratham Education Foundation';
        } else if (value === 'school_teacher') {
          updated.organization_name = 'Zilla Parishad High School';
        } else {
          updated.organization_name = 'School Education Department, Maharashtra';
        }
      } else if (name === 'ngoCode') {
        const found = PREAPPROVED_NGOS.find(n => n.id === value);
        if (found && value !== 'CUSTOM') {
          updated.organization_name = found.name;
        }
      }
      return updated;
    });
    setFormError(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormError(null);
    setIsSubmitting(true);

    try {
      if (isRegistering) {
        if (!formData.name || !formData.email) {
          throw new Error('Please fill in your Name and Email address.');
        }

        // Generate credentials
        const officialBadgeId = liveGeneratedId;
        const passwordToUse = formData.autoGeneratePassword 
          ? generateTemporaryPassword() 
          : formData.password;

        if (!passwordToUse || passwordToUse.length < 6) {
          throw new Error('Password must be at least 6 characters.');
        }

        // 1. Register user with Supabase Auth
        await signUp({
          email: formData.email,
          password: passwordToUse,
          government_id: officialBadgeId,
          name: formData.name,
          mobile_number: formData.mobile_number || '9876543210',
          organization_name: formData.organization_name,
          district: formData.district,
          state: formData.state
        });

        // 2. Dispatch credentials via Email Service
        await sendAdminCredentialEmail({
          email: formData.email,
          name: formData.name,
          government_id: officialBadgeId,
          temp_password: passwordToUse,
          district: formData.district,
          state: formData.state,
          entityType: formData.entityType,
          organization_name: formData.organization_name
        });

        // 3. Display Issued Credentials Confirmation Modal
        setIssuedCredentials({
          badgeId: officialBadgeId,
          password: passwordToUse,
          email: formData.email,
          name: formData.name
        });

      } else {
        if (!formData.email || !formData.password) {
          throw new Error('Please enter both email and password.');
        }
        await signIn(formData.email, formData.password);
        if (onLoginSuccess) onLoginSuccess();
      }
    } catch (err) {
      setFormError(err.message || 'Operation failed. Please check your credentials.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDemoLogin = async (role = 'gov') => {
    setFormError(null);
    setIsSubmitting(true);
    try {
      const demoEmail = role === 'ngo' ? 'ngo.satara@pratham.org' : 'anand.kulkarni@gov.in';
      await signIn(demoEmail, 'demo1234');
      if (onLoginSuccess) onLoginSuccess();
    } catch (err) {
      setFormError(err.message);
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
    <div className="min-h-screen bg-gradient-to-br from-[#2A1517] via-[#3D2123] to-[#1F0F11] text-[#F8F1EC] flex items-center justify-center p-4 sm:p-6 font-indic relative overflow-hidden">
      {/* Ambient background glow */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-[#EBD1C6]/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-[#A83E28]/20 rounded-full blur-3xl pointer-events-none" />

      <div className="w-full max-w-xl relative z-10 my-6">
        
        {/* Header Branding */}
        <div className="text-center mb-6">
          <div 
            onClick={onBackToHome}
            className="inline-flex items-center justify-center w-14 h-14 rounded-full bg-[#161616] text-[#FAF7F2] mb-3 shadow-xl cursor-pointer hover:scale-105 transition-transform p-2"
          >
            <DreamCatcherIcon className="w-10 h-10 text-[#FAF7F2]" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#F8F1EC]">
            DreamCatcher
          </h1>
          <p className="text-xs sm:text-sm text-[#EBD1C6]/75 mt-1">
            Government Officers & Partner NGO Coordinators
          </p>
        </div>

        {/* Issued Credentials Overlay Card (Post Signup) */}
        {issuedCredentials ? (
          <div className="bg-[#2A1517] border-2 border-emerald-500/50 rounded-3xl p-6 sm:p-8 shadow-2xl space-y-5 animate-in fade-in zoom-in duration-300">
            <div className="flex items-center gap-3 text-emerald-400">
              <CheckCircle2 className="w-8 h-8 shrink-0" />
              <div>
                <h2 className="text-lg font-extrabold text-white">Credentials Provisioned & Emailed!</h2>
                <p className="text-xs text-emerald-300/80">
                  Welcome email sent to <strong>{issuedCredentials.email}</strong>
                </p>
              </div>
            </div>

            <div className="bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-2xl p-4 space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-[#EBD1C6]/70 uppercase">Official Badge ID:</span>
                <span className="font-mono text-sm font-extrabold text-[#EBD1C6] tracking-wider">{issuedCredentials.badgeId}</span>
              </div>
              <div className="flex items-center justify-between border-t border-[#EBD1C6]/10 pt-2">
                <span className="text-xs font-bold text-[#EBD1C6]/70 uppercase">Temporary Password:</span>
                <span className="font-mono text-sm font-extrabold text-amber-300 tracking-wider">{issuedCredentials.password}</span>
              </div>
            </div>

            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => copyToClipboard(`Badge ID: ${issuedCredentials.badgeId}\nPassword: ${issuedCredentials.password}`)}
                className="flex-1 py-2.5 bg-[#3D2123] border border-[#EBD1C6]/30 text-[#EBD1C6] font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 hover:bg-[#4E2B2E] cursor-pointer"
              >
                <Copy className="w-3.5 h-3.5" />
                <span>{copied ? 'Copied to Clipboard!' : 'Copy Credentials'}</span>
              </button>

              <button
                type="button"
                onClick={() => {
                  setFormData(prev => ({ ...prev, email: issuedCredentials.email, password: issuedCredentials.password }));
                  setIssuedCredentials(null);
                  setIsRegistering(false);
                }}
                className="flex-1 py-2.5 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-xs rounded-xl flex items-center justify-center gap-1.5 cursor-pointer shadow-md"
              >
                <span>Proceed to Sign In</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>
        ) : (
          /* Card Container */
          <div className="bg-[#2A1517]/95 backdrop-blur-xl border border-[#EBD1C6]/25 rounded-3xl p-6 sm:p-8 shadow-2xl space-y-5">
            
            {/* Section Selector Pills */}
            <div className="flex rounded-full bg-[#1F0F11] p-1 border border-[#EBD1C6]/15">
              <button
                type="button"
                onClick={() => { setIsRegistering(false); setFormError(null); }}
                className={`flex-1 py-2 text-xs font-bold rounded-full transition-all cursor-pointer ${
                  !isRegistering ? 'bg-[#EBD1C6] text-[#3D2123] shadow-md' : 'text-[#EBD1C6]/70 hover:text-white'
                }`}
              >
                Portal Sign In
              </button>
              <button
                type="button"
                onClick={() => { setIsRegistering(true); setFormError(null); }}
                className={`flex-1 py-2 text-xs font-bold rounded-full transition-all cursor-pointer ${
                  isRegistering ? 'bg-[#EBD1C6] text-[#3D2123] shadow-md' : 'text-[#EBD1C6]/70 hover:text-white'
                }`}
              >
                Register Admin / NGO Badge
              </button>
            </div>

            {(formError || authError) && (
              <div className="p-3.5 bg-rose-900/40 border border-rose-500/40 text-rose-200 rounded-2xl text-xs flex items-center gap-2">
                <AlertCircle className="w-4 h-4 shrink-0 text-rose-400" />
                <span>{formError || authError}</span>
              </div>
            )}

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              
              {isRegistering && (
                <>
                  {/* Entity Category Selector */}
                  <div>
                    <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1.5">
                      Select Organization Category *
                    </label>
                    <div className="grid grid-cols-3 gap-2">
                      <button
                        type="button"
                        onClick={() => handleChange({ target: { name: 'entityType', value: 'government_officer' } })}
                        className={`p-2.5 rounded-xl border text-center transition-all cursor-pointer flex flex-col items-center gap-1 ${
                          formData.entityType === 'government_officer'
                            ? 'bg-[#EBD1C6] text-[#3D2123] border-[#EBD1C6] font-bold shadow-md'
                            : 'bg-[#1F0F11] border-[#EBD1C6]/20 text-[#EBD1C6]/70 hover:border-[#EBD1C6]/50'
                        }`}
                      >
                        <ShieldCheck className="w-4 h-4" />
                        <span className="text-[11px]">Govt Officer</span>
                      </button>

                      <button
                        type="button"
                        onClick={() => handleChange({ target: { name: 'entityType', value: 'ngo_volunteer' } })}
                        className={`p-2.5 rounded-xl border text-center transition-all cursor-pointer flex flex-col items-center gap-1 ${
                          formData.entityType === 'ngo_volunteer'
                            ? 'bg-[#EBD1C6] text-[#3D2123] border-[#EBD1C6] font-bold shadow-md'
                            : 'bg-[#1F0F11] border-[#EBD1C6]/20 text-[#EBD1C6]/70 hover:border-[#EBD1C6]/50'
                        }`}
                      >
                        <HeartHandshake className="w-4 h-4" />
                        <span className="text-[11px]">NGO Volunteer</span>
                      </button>

                      <button
                        type="button"
                        onClick={() => handleChange({ target: { name: 'entityType', value: 'school_teacher' } })}
                        className={`p-2.5 rounded-xl border text-center transition-all cursor-pointer flex flex-col items-center gap-1 ${
                          formData.entityType === 'school_teacher'
                            ? 'bg-[#EBD1C6] text-[#3D2123] border-[#EBD1C6] font-bold shadow-md'
                            : 'bg-[#1F0F11] border-[#EBD1C6]/20 text-[#EBD1C6]/70 hover:border-[#EBD1C6]/50'
                        }`}
                      >
                        <Building2 className="w-4 h-4" />
                        <span className="text-[11px]">ZP Teacher</span>
                      </button>
                    </div>
                  </div>

                  {/* NGO Select Dropdown if NGO Volunteer selected */}
                  {formData.entityType === 'ngo_volunteer' && (
                    <div>
                      <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                        Select Partner NGO *
                      </label>
                      <select
                        name="ngoCode"
                        value={formData.ngoCode}
                        onChange={handleChange}
                        className="w-full px-3.5 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/30 rounded-xl text-xs text-white focus:outline-none focus:border-[#EBD1C6]"
                      >
                        {PREAPPROVED_NGOS.map(ngo => (
                          <option key={ngo.id} value={ngo.id} className="bg-[#2A1517] text-white">
                            {ngo.name} ({ngo.id})
                          </option>
                        ))}
                      </select>
                    </div>
                  )}

                  {/* Live Auto-Generated ID Badge Banner */}
                  <div className="p-3 bg-[#1F0F11] border border-amber-500/40 rounded-xl flex items-center justify-between">
                    <div>
                      <span className="block text-[10px] text-amber-300/80 font-bold uppercase tracking-wider">
                        Auto-Generated Badge ID Preview
                      </span>
                      <span className="font-mono text-xs sm:text-sm font-extrabold text-amber-300">
                        {liveGeneratedId}
                      </span>
                    </div>
                    <Key className="w-5 h-5 text-amber-400" />
                  </div>

                  {/* Full Name */}
                  <div>
                    <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                      Full Name *
                    </label>
                    <div className="relative">
                      <User className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                      <input
                        type="text"
                        name="name"
                        required
                        placeholder="e.g. Anand Kulkarni"
                        value={formData.name}
                        onChange={handleChange}
                        className="w-full pl-10 pr-4 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                      />
                    </div>
                  </div>

                  {/* District & Mobile */}
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                        District
                      </label>
                      <div className="relative">
                        <MapPin className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                        <input
                          type="text"
                          name="district"
                          placeholder="Satara"
                          value={formData.district}
                          onChange={handleChange}
                          className="w-full pl-10 pr-3 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                        Mobile Number
                      </label>
                      <div className="relative">
                        <Phone className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                        <input
                          type="tel"
                          name="mobile_number"
                          placeholder="9876543210"
                          value={formData.mobile_number}
                          onChange={handleChange}
                          className="w-full pl-10 pr-3 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                        />
                      </div>
                    </div>
                  </div>

                  {/* Auto Password Toggle */}
                  <div className="flex items-center gap-2 pt-1">
                    <input
                      type="checkbox"
                      id="autoGeneratePassword"
                      name="autoGeneratePassword"
                      checked={formData.autoGeneratePassword}
                      onChange={handleChange}
                      className="rounded border-[#EBD1C6]/40 text-[#A83E28] focus:ring-0 cursor-pointer"
                    />
                    <label htmlFor="autoGeneratePassword" className="text-xs text-[#EBD1C6]/90 cursor-pointer font-medium">
                      Auto-generate secure temporary password & send to email
                    </label>
                  </div>
                </>
              )}

              {/* Email */}
              <div>
                <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                  Email Address *
                </label>
                <div className="relative">
                  <Mail className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                  <input
                    type="email"
                    name="email"
                    required
                    placeholder="anand.kulkarni@gov.in / ngo@pratham.org"
                    value={formData.email}
                    onChange={handleChange}
                    className="w-full pl-10 pr-4 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                  />
                </div>
              </div>

              {/* Password */}
              {(!isRegistering || !formData.autoGeneratePassword) && (
                <div>
                  <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                    Password *
                  </label>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                    <input
                      type="password"
                      name="password"
                      required={!isRegistering || !formData.autoGeneratePassword}
                      placeholder="••••••••"
                      value={formData.password}
                      onChange={handleChange}
                      className="w-full pl-10 pr-4 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                    />
                  </div>
                </div>
              )}

              {/* Submit Button */}
              <button
                type="submit"
                disabled={isSubmitting || loading}
                className="w-full py-3 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-xs rounded-xl shadow-lg flex items-center justify-center gap-2 transition-all transform hover:-translate-y-0.5 disabled:opacity-50 cursor-pointer mt-2"
              >
                <span>{isSubmitting ? 'Provisioning Account...' : isRegistering ? 'Provision Badge & Send Credentials Email' : 'Sign In to Field Portal'}</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </form>

            {/* Quick Demo Credentials Action */}
            <div className="pt-3 border-t border-[#EBD1C6]/15 text-center flex items-center justify-center gap-3">
              <button
                type="button"
                onClick={() => handleDemoLogin('gov')}
                className="text-xs text-[#EBD1C6]/80 hover:text-white underline cursor-pointer font-medium"
              >
                ⚡ Demo Govt Officer (Satara)
              </button>
              <span className="text-[#EBD1C6]/30">•</span>
              <button
                type="button"
                onClick={() => handleDemoLogin('ngo')}
                className="text-xs text-[#EBD1C6]/80 hover:text-white underline cursor-pointer font-medium"
              >
                🤝 Demo NGO Volunteer (Pratham)
              </button>
            </div>

          </div>
        )}

        {/* Back Link */}
        <div className="text-center mt-6">
          <button
            onClick={onBackToHome}
            className="text-xs text-[#EBD1C6]/60 hover:text-white transition-colors cursor-pointer"
          >
            ← Return to DreamCatcher Landing Page
          </button>
        </div>

      </div>
    </div>
  );
}
