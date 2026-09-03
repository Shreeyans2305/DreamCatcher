import React, { useState } from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { dummyAiEngine } from '../services/dummyAiEngine';
import DreamCatcherWind from '../components/ui/DreamCatcherWind';
import DreamCatcherIcon from '../components/ui/DreamCatcherIcon';
import { motion, AnimatePresence, useReducedMotion } from 'framer-motion';
import { 
  Compass, 
  Sparkles, 
  ArrowRight, 
  CheckCircle2, 
  Globe, 
  Users, 
  ShieldCheck, 
  Play, 
  GraduationCap, 
  Award, 
  Send,
  Zap,
  BookOpen,
  Tent,
  Check
} from 'lucide-react';

export default function LandingPageView({ onEnterAuth, onEnterPortal }) {
  const { t, uiLanguage, setLanguage, languageOptions } = useLanguage();
  const { isAuthenticated } = useAuth();
  const shouldReduceMotion = useReducedMotion();

  // Minimal Persona Selection for AI Counselor Simulator
  const samplePersonas = [
    {
      id: 'pooja',
      name: 'Pooja Jadhav',
      location: 'Satara, MH',
      grade: 'Class 10th Pass',
      category: 'OBC',
      lang: 'mr',
      defaultQuery: '१० वी नंतर लगेच नोकरीसाठी आयटीआय किंवा पॉलिटेक्निक चे कोणते ट्रेड्स बेस्ट आहेत?'
    },
    {
      id: 'rahul',
      name: 'Rahul More',
      location: 'Patan Tribal, MH',
      grade: 'Class 10th Pass',
      category: 'SC / Tribal',
      lang: 'hi',
      defaultQuery: '१०वीं के बाद सरकारी नौकरी और आईटीआई वायरमैन के लिए कौन सी छात्रवृत्ति मिलेगी?'
    },
    {
      id: 'darshan',
      name: 'Darshan Patel',
      location: 'Navsari, Gujarat',
      grade: 'Class 10th Pass',
      category: 'EWS',
      lang: 'gu',
      defaultQuery: 'ડિપ્લોમા એન્જિનિયરિંગમાં એડમિશન અને MYSY સ્કોલરશીપ માટે કેવી રીતે અરજી કરવી?'
    }
  ];

  const [selectedPersona, setSelectedPersona] = useState(samplePersonas[0]);
  const [queryInput, setQueryInput] = useState(samplePersonas[0].defaultQuery);
  const [aiResponse, setAiResponse] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleSelectPersona = (p) => {
    setSelectedPersona(p);
    setQueryInput(p.defaultQuery);
    setAiResponse(null);
  };

  const handleRunGuidance = async () => {
    setIsLoading(true);
    try {
      const studentMock = {
        full_name: selectedPersona.name,
        age_years: 16,
        education_level: 'grade_10',
        education_level_label: selectedPersona.grade,
        category: 'cat_' + selectedPersona.category.toLowerCase(),
        category_label: selectedPersona.category,
        village_location: selectedPersona.location,
        preferred_language: selectedPersona.lang
      };
      const res = await dummyAiEngine.generateGuidanceResponse(queryInput, studentMock);
      setAiResponse(res);
    } catch (e) {
      console.error(e);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F7F4EE] text-[#1C1C1C] selection:bg-[#222222] selection:text-[#F7F4EE] relative font-sans">
      
      {/* Gentle wind and floating feathers across background */}
      <DreamCatcherWind showDreamcatchers={false} featherCount={14} windSpeed={0.8} opacity={0.45} />

      {/* ============================================================ */}
      {/* 1. TOP NATIONAL / GOVERNMENT AFFILIATION BANNER              */}
      {/* ============================================================ */}
      <div className="w-full bg-[#ECE5D8] border-b border-[#DCD1C2] px-4 py-1.5 text-xs text-[#524B43]">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="font-serif-zen font-semibold text-[#1F1F1F]">🇮🇳 National Guidance Mission</span>
            <span className="hidden sm:inline text-[#7A6F62]">• NEP 2020 Vocational Education Standard</span>
          </div>
          <div className="flex items-center gap-3 text-[11px]">
            <span className="text-[#6B6256] hidden md:inline">Government of India Digital Service</span>
            <span className="bg-[#DFD4C3] px-2 py-0.5 rounded text-[#38332C] font-medium">UX4G Standard</span>
          </div>
        </div>
      </div>

      {/* ============================================================ */}
      {/* 2. MINIMAL FLOATING iOS GLASS NAVIGATION                     */}
      {/* ============================================================ */}
      <header className="sticky top-3 sm:top-4 z-40 max-w-6xl mx-auto px-4 w-full pointer-events-none">
        <div className="bg-[#FCFAF7]/75 backdrop-blur-2xl backdrop-saturate-150 border border-white/80 shadow-[0_10px_35px_rgba(40,30,20,0.06),0_1px_2px_rgba(0,0,0,0.03)] rounded-full px-4 sm:px-6 py-2.5 flex items-center justify-between pointer-events-auto transition-all duration-300">
          
          {/* Logo & Platform Name */}
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-full bg-[#222222] text-[#F7F4EE] flex items-center justify-center font-bold shadow-xs p-1 hover:scale-105 transition-transform">
              <DreamCatcherIcon className="w-5 h-5 text-[#F7F4EE]" />
            </div>
            <div>
              <span className="font-serif-zen font-semibold text-base sm:text-lg tracking-tight text-[#1F1F1F]">
                DreamCatcher
              </span>
              <span className="text-[10px] text-[#7A6F62] ml-2 hidden sm:inline font-medium">
                National Field Portal
              </span>
            </div>
          </div>

          {/* Right: Language Selector & Login CTA */}
          <div className="flex items-center gap-2.5">
            {/* Minimal Language Pill */}
            <div className="flex items-center bg-white/70 hover:bg-white border border-[#DDD3C5] rounded-full px-2.5 py-1 text-xs transition-colors shadow-2xs">
              <Globe className="w-3 h-3 text-[#7A6F62] mr-1.5 shrink-0" />
              <select
                value={uiLanguage}
                onChange={(e) => setLanguage(e.target.value)}
                aria-label="Language Selector"
                className="bg-transparent text-[#1F1F1F] font-semibold cursor-pointer focus:outline-none text-xs uppercase"
              >
                {languageOptions.map(opt => (
                  <option key={opt.code} value={opt.code} className="text-[#1F1F1F] bg-[#F4EFE6]">
                    {opt.code.toUpperCase()}
                  </option>
                ))}
              </select>
            </div>

            {/* Portal Action */}
            {isAuthenticated ? (
              <button
                onClick={onEnterPortal}
                className="px-4 py-1.5 text-xs font-medium bg-[#222222] hover:bg-[#111111] text-white rounded-full transition-all shadow-xs flex items-center gap-1.5 cursor-pointer hover:scale-105"
              >
                <span>Enter Field Portal</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            ) : (
              <button
                onClick={onEnterAuth}
                className="px-4 py-1.5 text-xs font-medium bg-[#222222] hover:bg-[#111111] text-white rounded-full transition-all shadow-xs flex items-center gap-1.5 cursor-pointer hover:scale-105"
              >
                <Users className="w-3.5 h-3.5" />
                <span>Volunteer Sign In</span>
              </button>
            )}
          </div>

        </div>
      </header>

      {/* ============================================================ */}
      {/* 3. HERO SECTION (Spacious, Minimal & Authoritative)          */}
      {/* ============================================================ */}
      <section className="pt-16 sm:pt-24 pb-14 px-4 sm:px-6 max-w-4xl mx-auto text-center">
        
        {/* Subtle Pill Tag */}
        <div className="inline-flex items-center gap-2 bg-[#F4EFE6] border border-[#DCD1C2] px-3.5 py-1.5 rounded-full text-xs text-[#524B43] mb-6 shadow-xs">
          <Sparkles className="w-3.5 h-3.5 text-[#C49F5A]" />
          <span>Multilingual Career & Scholarship Guidance for Rural Youth</span>
        </div>

        {/* Poetic & Authoritative Main Headline */}
        <h1 className="font-serif-zen font-medium text-4xl sm:text-5xl lg:text-6xl text-[#1F1F1F] leading-[1.15] tracking-tight mb-5">
          Catch every dream.<br />
          <span className="italic text-[#584F44]">Guide every village student.</span>
        </h1>

        {/* Concise Description */}
        <p className="font-serif-zen italic text-base sm:text-lg text-[#61574C] max-w-2xl mx-auto leading-relaxed mb-8">
          Empowering field teachers, volunteers, and officers to connect secondary students to verified ITI, Polytechnic, and government DBT scholarships in their mother tongue.
        </p>

        {/* Clean Action Buttons */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-3 mb-12">
          <button
            onClick={onEnterAuth}
            className="w-full sm:w-auto px-7 py-3 text-sm font-medium bg-[#222222] hover:bg-[#111111] text-white rounded-full transition-all shadow-sm flex items-center justify-center gap-2 cursor-pointer hover:scale-105"
          >
            <Users className="w-4 h-4" />
            <span>Launch Field Portal</span>
            <ArrowRight className="w-4 h-4" />
          </button>

          <a
            href="#counselor-demo"
            className="w-full sm:w-auto px-6 py-3 text-sm font-medium bg-[#F4EFE6] hover:bg-white text-[#222222] border border-[#DDD3C5] rounded-full transition-all shadow-xs flex items-center justify-center gap-2 cursor-pointer hover:scale-105"
          >
            <Play className="w-4 h-4 fill-current text-[#7A6F62]" />
            <span>Try AI Guidance Demo</span>
          </a>
        </div>

        {/* 4 Minimal Official Metrics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-left">
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-4 rounded-xl shadow-xs">
            <span className="text-[10px] text-[#7A6F62] uppercase tracking-wider font-semibold block mb-1">
              Students Guided
            </span>
            <span className="font-serif-zen text-2xl font-bold text-[#1F1F1F]">45,000+</span>
          </div>
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-4 rounded-xl shadow-xs">
            <span className="text-[10px] text-[#7A6F62] uppercase tracking-wider font-semibold block mb-1">
              Rural Guidance Camps
            </span>
            <span className="font-serif-zen text-2xl font-bold text-[#1F1F1F]">3,400+</span>
          </div>
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-4 rounded-xl shadow-xs">
            <span className="text-[10px] text-[#7A6F62] uppercase tracking-wider font-semibold block mb-1">
              Public Service
            </span>
            <span className="font-serif-zen text-2xl font-bold text-[#1F1F1F]">100% Free</span>
          </div>
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-4 rounded-xl shadow-xs">
            <span className="text-[10px] text-[#7A6F62] uppercase tracking-wider font-semibold block mb-1">
              Offline Readiness
            </span>
            <span className="font-serif-zen text-2xl font-bold text-[#1F1F1F]">Zero Network</span>
          </div>
        </div>

      </section>

      {/* ============================================================ */}
      {/* 4. THREE CORE PILLARS (Clean, Spacious & Minimal)            */}
      {/* ============================================================ */}
      <section className="py-14 px-4 sm:px-6 max-w-5xl mx-auto border-t border-[#E5DED4]">
        
        <div className="text-center mb-10">
          <h2 className="font-serif-zen text-2xl sm:text-3xl text-[#1F1F1F] font-medium tracking-tight mb-2">
            Designed for Bharat's Last Mile
          </h2>
          <p className="font-serif-zen italic text-sm text-[#6B6256]">
            Three essential pillars delivering dignity and opportunity to rural students.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          
          {/* Pillar 1 */}
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-6 rounded-2xl shadow-xs flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-[#F4EFE6] text-[#332C24] flex items-center justify-center font-bold mb-4 border border-[#DDD3C5]">
                <Globe className="w-5 h-5 text-[#332C24]" />
              </div>
              <h3 className="font-serif-zen text-lg font-semibold text-[#1F1F1F] mb-2">
                Vernacular AI Counseling
              </h3>
              <p className="text-xs sm:text-sm text-[#61574C] leading-relaxed">
                Counseling delivered in Marathi, Hindi, Gujarati, and English. Uses voice and clear regional phrasing so low-literacy students understand every opportunity.
              </p>
            </div>
            <div className="pt-4 mt-4 border-t border-[#EAE2D5] text-[11px] text-[#7A6F62]">
              ✓ Voice hints & simple language
            </div>
          </div>

          {/* Pillar 2 */}
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-6 rounded-2xl shadow-xs flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-[#F4EFE6] text-[#332C24] flex items-center justify-center font-bold mb-4 border border-[#DDD3C5]">
                <Award className="w-5 h-5 text-[#332C24]" />
              </div>
              <h3 className="font-serif-zen text-lg font-semibold text-[#1F1F1F] mb-2">
                Instant Scholarship Matching
              </h3>
              <p className="text-xs sm:text-sm text-[#61574C] leading-relaxed">
                Automatically maps student caste, family income, and marks against active state and central welfare DBT schemes (MahaDBT, MYSY, NSP, Post-Matric).
              </p>
            </div>
            <div className="pt-4 mt-4 border-t border-[#EAE2D5] text-[11px] text-[#7A6F62]">
              ✓ Verified Govt scheme database
            </div>
          </div>

          {/* Pillar 3 */}
          <div className="bg-[#FCFAF7] border border-[#E5DED4] p-6 rounded-2xl shadow-xs flex flex-col justify-between">
            <div>
              <div className="w-10 h-10 rounded-xl bg-[#F4EFE6] text-[#332C24] flex items-center justify-center font-bold mb-4 border border-[#DDD3C5]">
                <ShieldCheck className="w-5 h-5 text-[#332C24]" />
              </div>
              <h3 className="font-serif-zen text-lg font-semibold text-[#1F1F1F] mb-2">
                100% Offline-Ready
              </h3>
              <p className="text-xs sm:text-sm text-[#61574C] leading-relaxed">
                Operates seamlessly without active cellular coverage in deep rural talukas. Student intakes store locally and sync automatically when internet is detected.
              </p>
            </div>
            <div className="pt-4 mt-4 border-t border-[#EAE2D5] text-[11px] text-[#7A6F62]">
              ✓ Offline SQLite storage & encryption
            </div>
          </div>

        </div>

      </section>

      {/* ============================================================ */}
      {/* 5. LIVE AI COUNSELOR SIMULATOR (Minimal, Clean & Focused)    */}
      {/* ============================================================ */}
      <section id="counselor-demo" className="py-14 px-4 sm:px-6 max-w-4xl mx-auto border-t border-[#E5DED4]">
        
        <div className="text-center mb-8">
          <span className="text-xs bg-[#EAE2D5] text-[#585149] px-3 py-1 rounded-full font-serif-zen font-medium border border-[#D5CCBD]">
            Interactive Demonstration
          </span>
          <h2 className="font-serif-zen text-2xl sm:text-3xl text-[#1F1F1F] font-medium tracking-tight mt-3 mb-2">
            Try the Multilingual AI Counselor
          </h2>
          <p className="font-serif-zen italic text-xs sm:text-sm text-[#6B6256]">
            Select a rural student persona to see how DreamCatcher delivers instant, actionable guidance.
          </p>
        </div>

        {/* Persona Selectors */}
        <div className="flex flex-wrap items-center justify-center gap-2.5 mb-6">
          {samplePersonas.map((p) => {
            const isSelected = selectedPersona.id === p.id;
            return (
              <button
                key={p.id}
                onClick={() => handleSelectPersona(p)}
                className={`px-4 py-2 rounded-full text-xs font-medium transition-all cursor-pointer ${
                  isSelected
                    ? 'bg-[#222222] text-white shadow-xs'
                    : 'bg-[#FCFAF7] border border-[#DDD3C5] text-[#585149] hover:text-[#1F1F1F] hover:bg-white'
                }`}
              >
                <span className="font-semibold">{p.name}</span>
                <span className="opacity-70 ml-1.5">({p.location} • {p.category})</span>
              </button>
            );
          })}
        </div>

        {/* Minimal Query Box */}
        <div className="bg-[#FCFAF7] border border-[#DDD3C5] rounded-2xl p-5 shadow-xs mb-6">
          <div className="flex items-center gap-2 text-xs text-[#7A6F62] mb-2 font-medium">
            <span>Student Career Question:</span>
          </div>
          <div className="flex flex-col sm:flex-row gap-2.5">
            <input
              type="text"
              value={queryInput}
              onChange={(e) => setQueryInput(e.target.value)}
              className="flex-1 px-4 py-2.5 bg-white border border-[#D5CCBD] rounded-xl text-sm text-[#1F1F1F] focus:outline-none focus:border-[#222222]"
            />
            <button
              onClick={handleRunGuidance}
              disabled={isLoading}
              className="px-6 py-2.5 bg-[#222222] hover:bg-[#111111] text-white text-xs font-medium rounded-xl transition-all shadow-xs flex items-center justify-center gap-1.5 cursor-pointer shrink-0 disabled:opacity-50"
            >
              <Send className="w-3.5 h-3.5" />
              <span>{isLoading ? 'Generating...' : 'Run Guidance'}</span>
            </button>
          </div>
        </div>

        {/* AI Result Card */}
        {aiResponse && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-[#FAF7F2] border border-[#DCD1C2] rounded-2xl p-6 shadow-sm space-y-4"
          >
            <div className="flex items-center justify-between border-b border-[#EAE2D5] pb-3">
              <div className="flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-[#C49F5A]" />
                <span className="font-serif-zen font-semibold text-sm text-[#1F1F1F]">
                  Counselor Recommendation for {selectedPersona.name}
                </span>
              </div>
              <span className="text-[10px] bg-[#E8EFE9] text-[#2C4A33] px-2 py-0.5 rounded font-medium">
                Verified Match
              </span>
            </div>

            <p className="text-sm text-[#38332C] leading-relaxed">
              {aiResponse.summary || aiResponse.response_text}
            </p>

            {aiResponse.pathways && aiResponse.pathways.length > 0 && (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
                {aiResponse.pathways.slice(0, 2).map((path, idx) => (
                  <div key={idx} className="bg-white border border-[#DDD3C5] p-3 rounded-xl text-xs">
                    <span className="font-semibold text-[#1F1F1F] block mb-1">
                      {path.title || path.trade_name}
                    </span>
                    <span className="text-[#6B6256] block">{path.description}</span>
                  </div>
                ))}
              </div>
            )}
          </motion.div>
        )}

      </section>

      {/* ============================================================ */}
      {/* 6. CLEAN, TRUSTED GOVERNMENT-STANDARD FOOTER                  */}
      {/* ============================================================ */}
      <footer className="w-full bg-[#ECE5D8] border-t border-[#DCD1C2] py-8 px-4 text-xs text-[#6B6256]">
        <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="space-y-1 text-center sm:text-left">
            <div className="font-serif-zen font-semibold text-sm text-[#1F1F1F]">
              DreamCatcher — Multilingual Public AI Career Guidance Platform
            </div>
            <p className="text-[11px] text-[#7A6F62]">
              Aligned with National Education Policy (NEP 2020) • Data encrypted at rest • UX4G Standard
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={onEnterAuth}
              className="px-4 py-1.5 bg-[#222222] text-white rounded-full text-xs font-medium hover:bg-[#111111] transition-all cursor-pointer"
            >
              Field Counselor Login
            </button>
          </div>
        </div>
      </footer>

    </div>
  );
}
