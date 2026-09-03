import React, { useState } from 'react';
import { useAdminAuth } from '../context/AdminAuthContext';
import { isSupabaseConfigured } from '../services/supabaseClient';
import { Compass, Lock, Mail, ArrowRight, ShieldCheck, UserCheck, AlertCircle, Building, MapPin, Phone, User } from 'lucide-react';

export default function AdminLoginView({ onBackToHome, onLoginSuccess }) {
  const { signIn, signUp, loading, error: authError } = useAdminAuth();
  
  const [isRegistering, setIsRegistering] = useState(false);
  const [formError, setFormError] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [registrationSuccess, setRegistrationSuccess] = useState(false);

  // Form State
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    name: '',
    government_id: '',
    organization_name: '',
    district: 'Satara',
    state: 'Maharashtra',
    mobile_number: ''
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    setFormError(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormError(null);
    setIsSubmitting(true);

    try {
      if (isRegistering) {
        if (!formData.name || !formData.government_id || !formData.email || !formData.password) {
          throw new Error('Please fill in all mandatory fields.');
        }
        await signUp(formData);
        setRegistrationSuccess(true);
        setIsRegistering(false);
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

  const handleDemoLogin = async () => {
    setFormError(null);
    setIsSubmitting(true);
    try {
      await signIn('anand.kulkarni@gov.in', 'demo1234');
      if (onLoginSuccess) onLoginSuccess();
    } catch (err) {
      setFormError(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#2A1517] via-[#3D2123] to-[#1F0F11] text-[#F8F1EC] flex items-center justify-center p-4 sm:p-6 font-indic relative overflow-hidden">
      {/* Ambient background glow */}
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-[#EBD1C6]/10 rounded-full blur-3xl pointer-events-none" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-[#A83E28]/20 rounded-full blur-3xl pointer-events-none" />

      <div className="w-full max-w-md relative z-10">
        
        {/* Header Branding */}
        <div className="text-center mb-8">
          <div 
            onClick={onBackToHome}
            className="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-[#EBD1C6] text-[#3D2123] mb-4 shadow-xl cursor-pointer hover:scale-105 transition-transform"
          >
            <Compass className="w-8 h-8 text-[#3D2123]" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight text-[#F8F1EC]">
            DreamCatcher Admin Portal
          </h1>
          <p className="text-xs sm:text-sm text-[#EBD1C6]/75 mt-1">
            Government Officers & Field Volunteer Infrastructure
          </p>

          {/* Database indicator badge */}
          <div className="inline-flex items-center gap-1.5 mt-3 px-3 py-1 rounded-full text-[11px] font-bold border border-[#EBD1C6]/30 bg-[#2A1517]/80 text-[#EBD1C6]">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
            <span>
              {isSupabaseConfigured() ? 'Live Supabase DB Connected' : 'Local Sandbox Mode'}
            </span>
          </div>
        </div>

        {/* Card Container */}
        <div className="bg-[#2A1517]/90 backdrop-blur-xl border border-[#EBD1C6]/25 rounded-3xl p-6 sm:p-8 shadow-2xl space-y-5">
          
          {/* Section Selector Pills */}
          <div className="flex rounded-full bg-[#1F0F11] p-1 border border-[#EBD1C6]/15">
            <button
              type="button"
              onClick={() => { setIsRegistering(false); setFormError(null); }}
              className={`flex-1 py-2 text-xs font-bold rounded-full transition-all ${
                !isRegistering ? 'bg-[#EBD1C6] text-[#3D2123] shadow-md' : 'text-[#EBD1C6]/70 hover:text-white'
              }`}
            >
              Admin Sign In
            </button>
            <button
              type="button"
              onClick={() => { setIsRegistering(true); setFormError(null); }}
              className={`flex-1 py-2 text-xs font-bold rounded-full transition-all ${
                isRegistering ? 'bg-[#EBD1C6] text-[#3D2123] shadow-md' : 'text-[#EBD1C6]/70 hover:text-white'
              }`}
            >
              New Registration
            </button>
          </div>

          {/* Alert Messages */}
          {registrationSuccess && (
            <div className="p-3.5 bg-emerald-900/40 border border-emerald-500/40 text-emerald-200 rounded-2xl text-xs flex items-center gap-2">
              <UserCheck className="w-4 h-4 shrink-0 text-emerald-400" />
              <span>Registration submitted! You can now sign in with your email & password.</span>
            </div>
          )}

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

                {/* Government ID */}
                <div>
                  <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                    Government / Officer Badge ID *
                  </label>
                  <div className="relative">
                    <ShieldCheck className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                    <input
                      type="text"
                      name="government_id"
                      required
                      placeholder="e.g. GOV-MH-SAT-2026"
                      value={formData.government_id}
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
              </>
            )}

            {/* Email */}
            <div>
              <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                Officer Email Address *
              </label>
              <div className="relative">
                <Mail className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                <input
                  type="email"
                  name="email"
                  required
                  placeholder="anand.kulkarni@gov.in"
                  value={formData.email}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                />
              </div>
            </div>

            {/* Password */}
            <div>
              <label className="block text-[11px] font-bold text-[#EBD1C6]/90 uppercase tracking-wider mb-1">
                Password *
              </label>
              <div className="relative">
                <Lock className="w-4 h-4 text-[#EBD1C6]/50 absolute left-3.5 top-3" />
                <input
                  type="password"
                  name="password"
                  required
                  placeholder="••••••••"
                  value={formData.password}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-2.5 bg-[#1F0F11] border border-[#EBD1C6]/20 rounded-xl text-xs text-white placeholder-[#EBD1C6]/40 focus:outline-none focus:border-[#EBD1C6]"
                />
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isSubmitting || loading}
              className="w-full py-3 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-xs rounded-xl shadow-lg flex items-center justify-center gap-2 transition-all transform hover:-translate-y-0.5 disabled:opacity-50 cursor-pointer mt-2"
            >
              <span>{isSubmitting ? 'Processing...' : isRegistering ? 'Register Admin Credentials' : 'Sign In to Admin Portal'}</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </form>

          {/* Quick Demo Credentials Action */}
          <div className="pt-3 border-t border-[#EBD1C6]/15 text-center">
            <button
              type="button"
              onClick={handleDemoLogin}
              className="text-xs text-[#EBD1C6]/80 hover:text-white underline cursor-pointer font-medium"
            >
              ⚡ Quick Demo Sign In (Anand Kulkarni, Satara)
            </button>
          </div>

        </div>

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
