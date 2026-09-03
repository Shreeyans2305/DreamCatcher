import React, { useState, useEffect } from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { dummyAiEngine } from '../services/dummyAiEngine';
import SlideTabs from '../components/ui/slide-tabs';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Compass, 
  Sparkles, 
  ArrowRight, 
  Tent, 
  Smartphone, 
  PhoneCall, 
  CheckCircle2, 
  Award, 
  Globe, 
  Users, 
  ShieldCheck, 
  Play, 
  Volume2, 
  GraduationCap, 
  MapPin, 
  Clock, 
  BookOpen, 
  HeartHandshake, 
  ChevronRight, 
  Zap,
  TrendingUp,
  FileCheck,
  Menu,
  X
} from 'lucide-react';

export default function LandingPageView({ onEnterAuth, onEnterPortal }) {
  const { t, uiLanguage, setLanguage, languageOptions } = useLanguage();
  const { isAuthenticated, volunteer } = useAuth();

  const navTabs = [
    { label: "Our Mission", href: "#mission", id: "mission" },
    { label: "Tri-Modal Platform", href: "#tri-modal", id: "tri-modal" },
    { label: "Live AI Demo", href: "#simulator", id: "simulator" },
    { label: "Ground Impact", href: "#impact", id: "impact" },
    { label: "Scholarships DB", href: "#scholarships", id: "scholarships" }
  ];

  // Active scroll-spy tab index
  const [activeNavIndex, setActiveNavIndex] = useState(0);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  // IntersectionObserver for Scroll-Spy
  useEffect(() => {
    const sectionIds = ["mission", "tri-modal", "simulator", "impact", "scholarships"];
    const observers = [];

    sectionIds.forEach((id, index) => {
      const el = document.getElementById(id);
      if (el) {
        const observer = new IntersectionObserver(
          (entries) => {
            entries.forEach((entry) => {
              if (entry.isIntersecting) {
                setActiveNavIndex(index);
              }
            });
          },
          { rootMargin: "-20% 0px -60% 0px" }
        );
        observer.observe(el);
        observers.push(observer);
      }
    });

    return () => observers.forEach((obs) => obs.disconnect());
  }, []);

  // Interactive Live Counselor Simulator State
  const [simulatorStudent, setSimulatorStudent] = useState({
    full_name: 'Pooja Jadhav',
    age_years: 15,
    education_level: 'grade_10',
    education_level_label: 'Class 10th (SSC Aspirant)',
    category: 'cat_obc',
    category_label: 'OBC Category',
    village_location: 'Shindewadi, Satara',
    preferred_language: 'mr',
    aspirations: 'Polytechnic Computer Diploma or GNM Nursing'
  });

  const [simulatorQuery, setSimulatorQuery] = useState('१० वी नंतर लगेच नोकरीसाठी आयटीआय चे कोणते ट्रेड्स बेस्ट आहेत?');
  const [simulatorResponse, setSimulatorResponse] = useState(null);
  const [isSimulating, setIsSimulating] = useState(false);

  const samplePersonas = [
    {
      name: 'Pooja (Satara)',
      grade: 'grade_10',
      gradeLabel: 'Class 10th Pass',
      cat: 'cat_obc',
      catLabel: 'OBC',
      lang: 'mr',
      village: 'Shindewadi, Satara',
      defaultQuery: '१० वी नंतर लगेच नोकरीसाठी आयटीआय चे कोणते ट्रेड्स बेस्ट आहेत?'
    },
    {
      name: 'Rahul (Tribal Youth)',
      grade: 'grade_iti',
      gradeLabel: 'ITI Wireman Aspirant',
      cat: 'cat_sc',
      catLabel: 'SC',
      lang: 'hi',
      village: 'Dhebewadi, Patan',
      defaultQuery: '१०वीं के बाद सरकारी नौकरी और आईटीआई के सबसे अच्छे ट्रेड्स कौन से हैं?'
    },
    {
      name: 'Darshan (Gujarat)',
      grade: 'grade_10',
      gradeLabel: 'Class 10th Pass',
      cat: 'cat_ews',
      catLabel: 'EWS',
      lang: 'gu',
      village: 'Navsari Rural',
      defaultQuery: 'ડિપ્લોમા એન્જિનિયરિંગમાં એડમિશન અને MYSY સ્કોलરશીપ કેવી રીતે મળે?'
    },
    {
      name: 'Mahesh (Science)',
      grade: 'grade_11_12_sci',
      gradeLabel: 'Class 12th Science',
      cat: 'cat_general',
      catLabel: 'General/EBC',
      lang: 'en',
      village: 'Malharpeth Block',
      defaultQuery: 'Govt GNM / B.Sc Nursing admission with hostel & stipend support'
    }
  ];

  const handleSelectPersona = (p) => {
    const updated = {
      full_name: p.name,
      age_years: 16,
      education_level: p.grade,
      education_level_label: p.gradeLabel,
      category: p.cat,
      category_label: p.catLabel,
      village_location: p.village,
      preferred_language: p.lang,
      aspirations: 'Career & Scholarship Advice'
    };
    setSimulatorStudent(updated);
    setSimulatorQuery(p.defaultQuery);
    setSimulatorResponse(null);
  };

  const handleRunSimulation = async (query) => {
    const textToQuery = query || simulatorQuery;
    setIsSimulating(true);
    try {
      const resp = await dummyAiEngine.generateGuidanceResponse(textToQuery, simulatorStudent);
      setSimulatorResponse(resp);
    } catch (e) {
      console.error(e);
    } finally {
      setIsSimulating(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F8F1EC] text-[#2A1517] font-indic selection:bg-[#3D2123] selection:text-[#F8F1EC] relative">
      
      {/* ============================================================ */}
      {/* 1. TOP UNIFIED FROSTED NAVBAR HEADER                         */}
      {/* ============================================================ */}
      <header className="fixed top-0 inset-x-0 z-50 bg-[#3D2123]/95 backdrop-blur-xl border-b border-[#2A1517] shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-18 flex items-center justify-between">
          
          {/* Left End: Logo & Brand Name */}
          <a 
            href="#"
            onClick={(e) => {
              e.preventDefault();
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
            className="flex items-center gap-2.5 sm:gap-3 group no-underline text-inherit"
          >
            <div className="w-9 h-9 sm:w-10 sm:h-10 rounded-xl bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center font-bold shadow-md shrink-0 group-hover:rotate-12 transition-transform">
              <Compass className="w-5 h-5 text-[#3D2123]" />
            </div>
            <div className="flex flex-col">
              <div className="flex items-center gap-2">
                <span className="font-extrabold text-base sm:text-lg tracking-tight font-indic text-[#F8F1EC]">
                  {t('brand')}
                </span>
                <span className="text-[10px] bg-[#EBD1C6]/20 text-[#EBD1C6] px-2 py-0.5 rounded-full font-bold border border-[#EBD1C6]/30 hidden xs:inline-block leading-none">
                  Govt Edition
                </span>
              </div>
              <span className="text-[10px] text-[#EBD1C6]/75 font-medium hidden md:block">
                National AI Career Guidance Infrastructure
              </span>
            </div>
          </a>

          {/* Middle: SlideTabs Navigation Menu */}
          <div className="hidden lg:flex items-center justify-center">
            <SlideTabs tabs={navTabs} activeIndex={activeNavIndex} onTabSelect={(tab, idx) => setActiveNavIndex(idx)} />
          </div>

          {/* Right End: Language Switcher & Volunteer Login Button */}
          <div className="flex items-center gap-2.5 sm:gap-3">
            
            {/* Native Language Selector */}
            <div className="relative h-10 bg-[#2A1517] border border-[#EBD1C6]/30 rounded-xl shadow-xs px-3 flex items-center gap-1.5 transition-all hover:border-[#EBD1C6]/60">
              <Globe className="w-3.5 h-3.5 text-[#EBD1C6] shrink-0" />
              <select
                value={uiLanguage}
                onChange={(e) => setLanguage(e.target.value)}
                aria-label="Language Selector"
                className="bg-transparent text-[#F8F1EC] font-bold cursor-pointer focus:outline-none font-indic text-xs appearance-none pr-4.5"
              >
                {languageOptions.map(opt => (
                  <option key={opt.code} value={opt.code} className="text-[#3D2123] bg-[#F8F1EC] font-indic font-semibold">
                    {opt.nativeLabel} ({opt.code.toUpperCase()})
                  </option>
                ))}
              </select>
              <ChevronRight className="w-3 h-3 text-[#EBD1C6] pointer-events-none absolute right-2 rotate-90 opacity-80" />
            </div>

            {/* Portal / Volunteer Login CTA Button */}
            {isAuthenticated ? (
              <button
                onClick={onEnterPortal}
                className="h-10 px-4 bg-[#EBD1C6] hover:bg-[#F5E8E2] text-[#3D2123] border border-[#EBD1C6]/60 font-extrabold text-xs rounded-xl shadow-md flex items-center gap-1.5 transition-all font-indic touch-target cursor-pointer"
              >
                <span>Open Portal</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            ) : (
              <button
                onClick={onEnterAuth}
                className="h-10 px-4 sm:px-4.5 bg-[#A83E28] hover:bg-[#8F3320] text-white border border-[#EBD1C6]/40 font-bold text-xs rounded-xl shadow-md flex items-center gap-1.5 transition-all transform hover:-translate-y-0.5 font-indic touch-target cursor-pointer"
              >
                <Users className="w-3.5 h-3.5" />
                <span>Volunteer Sign In</span>
              </button>
            )}

            {/* Mobile Hamburger Toggle Button */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden h-10 w-10 flex items-center justify-center bg-[#2A1517] text-[#EBD1C6] border border-[#EBD1C6]/30 rounded-xl shadow-xs hover:text-white transition-colors cursor-pointer"
              aria-label="Toggle navigation menu"
            >
              {mobileMenuOpen ? <X className="w-4 h-4" /> : <Menu className="w-4 h-4" />}
            </button>

          </div>

        </div>

        {/* Mobile Slide-Down Menu Sheet */}
        <AnimatePresence>
          {mobileMenuOpen && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: 'auto' }}
              exit={{ opacity: 0, height: 0 }}
              transition={{ duration: 0.2 }}
              className="lg:hidden bg-[#2A1517] border-t border-[#4E5458]/60 px-4 py-4 space-y-3"
            >
              <div className="grid grid-cols-1 gap-1">
                {navTabs.map((tab, idx) => (
                  <a
                    key={tab.id}
                    href={tab.href}
                    onClick={() => {
                      setActiveNavIndex(idx);
                      setMobileMenuOpen(false);
                    }}
                    className={`px-3 py-2 rounded-xl text-xs font-bold font-indic flex items-center justify-between transition-colors ${
                      activeNavIndex === idx ? 'bg-[#EBD1C6] text-[#3D2123]' : 'text-[#EBD1C6] hover:bg-[#3D2123]'
                    }`}
                  >
                    <span>{tab.label}</span>
                    <ChevronRight className="w-4 h-4 opacity-70" />
                  </a>
                ))}
              </div>

              <div className="pt-2 border-t border-[#4E5458]/60">
                {isAuthenticated ? (
                  <button
                    onClick={() => {
                      setMobileMenuOpen(false);
                      onEnterPortal();
                    }}
                    className="w-full py-2.5 bg-[#EBD1C6] text-[#3D2123] font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 font-indic shadow"
                  >
                    <span>Open Volunteer Portal</span>
                    <ArrowRight className="w-4 h-4" />
                  </button>
                ) : (
                  <button
                    onClick={() => {
                      setMobileMenuOpen(false);
                      onEnterAuth();
                    }}
                    className="w-full py-2.5 bg-[#A83E28] text-white font-bold text-xs rounded-xl flex items-center justify-center gap-1.5 font-indic shadow"
                  >
                    <Users className="w-4 h-4" />
                    <span>Field Volunteer Sign In</span>
                  </button>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>

      </header>

      {/* ============================================================ */}
      {/* 2. HERO SECTION (Deep Mahogany & Rose Sand Harmony)         */}
      {/* ============================================================ */}
      <section className="relative bg-gradient-to-b from-[#3D2123] via-[#2A1517] to-[#3D2123] text-[#F8F1EC] pt-28 sm:pt-36 pb-20 px-4 sm:px-6 lg:px-8 overflow-hidden">
        
        {/* Warm Ambient Accents */}
        <div className="absolute top-10 left-1/4 w-96 h-96 bg-[#EBD1C6]/10 rounded-full blur-3xl pointer-events-none" />
        <div className="absolute bottom-10 right-1/4 w-96 h-96 bg-[#A83E28]/10 rounded-full blur-3xl pointer-events-none" />

        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-10 items-center relative z-10">
          
          {/* Left Hero Copy */}
          <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
            
            <div className="inline-flex items-center gap-2 bg-[#EBD1C6]/15 text-[#EBD1C6] text-xs px-3.5 py-1.5 rounded-full border border-[#EBD1C6]/30 font-bold font-indic">
              <Sparkles className="w-4 h-4 text-[#EBD1C6] animate-spin" />
              <span>India's Multilingual Career Guidance Infrastructure</span>
            </div>

            <h1 className="text-3xl sm:text-5xl lg:text-5xl font-extrabold leading-tight tracking-tight font-indic text-[#F8F1EC]">
              Equal Career Guidance for <br />
              <span className="text-[#EBD1C6] underline decoration-[#EBD1C6]/50 decoration-wavy">
                Every Pin Code in India.
              </span>
            </h1>

            <p className="text-sm sm:text-base text-[#F8F1EC]/85 max-w-2xl leading-relaxed font-indic mx-auto lg:mx-0">
              Connecting 250 million rural and semi-urban students to personalized vocational pathways, ITI/Polytechnic seats, and government scholarships — in their mother tongue, with or without a smartphone.
            </p>

            {/* Action CTAs */}
            <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-3.5 pt-2">
              <button
                onClick={onEnterAuth}
                className="w-full sm:w-auto px-7 py-4 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-sm rounded-xl shadow-lg flex items-center justify-center gap-2.5 transition-all transform hover:-translate-y-0.5 font-indic touch-target"
              >
                <Users className="w-5 h-5" />
                <span>Launch Field Volunteer Portal</span>
                <ArrowRight className="w-4 h-4" />
              </button>

              <a
                href="#simulator"
                className="w-full sm:w-auto px-6 py-4 bg-[#4E5458]/70 hover:bg-[#4E5458] text-[#F8F1EC] font-bold text-sm rounded-xl border border-[#EBD1C6]/30 flex items-center justify-center gap-2 transition-all font-indic touch-target"
              >
                <Play className="w-4 h-4 text-[#EBD1C6] fill-[#EBD1C6]" />
                <span>Try Live AI Simulator</span>
              </a>
            </div>

            {/* Highlight Badges */}
            <div className="flex flex-wrap items-center justify-center lg:justify-start gap-4 pt-4 text-xs text-[#EBD1C6]">
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                <span>100% Free Public Service</span>
              </div>
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                <span>Offline-Ready Field PWA</span>
              </div>
              <div className="flex items-center gap-1.5">
                <CheckCircle2 className="w-4 h-4 text-emerald-400" />
                <span>Devanagari & Gujarati Native AI</span>
              </div>
            </div>

          </div>

          {/* Right Hero: Seamless Blending Hero Photograph with Floating Glass Badges */}
          <div className="lg:col-span-5 relative">
            <div className="relative mx-auto max-w-lg">
              
              {/* Warm Ambient Glow Behind Image */}
              <div className="absolute inset-0 bg-[#EBD1C6]/20 rounded-3xl blur-2xl transform scale-95 pointer-events-none" />

              {/* Main Blending Image Container */}
              <div className="relative rounded-3xl overflow-hidden border border-[#EBD1C6]/30 shadow-2xl bg-[#2A1517] group">
                <img
                  src="/hero-student-mentor.jpg"
                  alt="Rural Indian student receiving career guidance on tablet from teacher mentor"
                  className="w-full h-[380px] sm:h-[440px] object-cover object-center transform transition-transform duration-700 group-hover:scale-105"
                  loading="eager"
                />
                
                {/* Edge Vignette & Mahogany Blending Overlays */}
                <div className="absolute inset-0 bg-gradient-to-t from-[#2A1517] via-transparent to-black/20 pointer-events-none" />
                <div className="absolute inset-0 bg-gradient-to-r from-[#3D2123]/30 via-transparent to-transparent pointer-events-none" />
                <div className="absolute inset-0 ring-1 ring-inset ring-[#EBD1C6]/20 rounded-3xl pointer-events-none" />

                {/* Top Floating Glass Badge */}
                <div className="absolute top-4 right-4 bg-[#2A1517]/85 backdrop-blur-md border border-[#EBD1C6]/40 text-[#F8F1EC] px-3 py-1.5 rounded-full shadow-lg flex items-center gap-2 text-xs font-bold font-indic">
                  <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping" />
                  <span>Field Camp • Satara, MH</span>
                </div>

                {/* Bottom Floating Glass Card */}
                <div className="absolute bottom-4 inset-x-4 bg-[#2A1517]/90 backdrop-blur-md border border-[#EBD1C6]/30 rounded-2xl p-3.5 shadow-xl flex items-center justify-between gap-3 text-white">
                  <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-xl bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center font-bold shrink-0">
                      <Sparkles className="w-5 h-5 text-[#3D2123]" />
                    </div>
                    <div>
                      <div className="text-xs font-bold font-indic text-[#F8F1EC]">Vernacular AI Counselor</div>
                      <div className="text-[10px] text-[#EBD1C6] font-medium font-indic">Devanagari & Gujarati Voice/Text</div>
                    </div>
                  </div>
                  <div className="text-right shrink-0">
                    <span className="text-[9px] bg-[#EBD1C6]/20 text-[#EBD1C6] px-2 py-0.5 rounded-full font-bold border border-[#EBD1C6]/30">
                      Offline PWA
                    </span>
                  </div>
                </div>

              </div>

            </div>
          </div>

        </div>

      </section>

      {/* ============================================================ */}
      {/* 3. LIVE INTERACTIVE COUNSELOR SIMULATOR                      */}
      {/* ============================================================ */}
      <section id="simulator" className="py-16 px-4 sm:px-6 lg:px-8 bg-[#F8F1EC] border-y border-[#EBD1C6] scroll-mt-24">
        <div className="max-w-5xl mx-auto space-y-8">
          
          <div className="text-center space-y-2 max-w-2xl mx-auto">
            <div className="inline-flex items-center gap-1.5 bg-[#EBD1C6] text-[#3D2123] text-xs font-bold px-3 py-1 rounded-full border border-[#4E5458]/30 font-indic">
              <Zap className="w-3.5 h-3.5 text-[#A83E28]" />
              <span>Interactive Public Demo</span>
            </div>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-[#3D2123] font-indic">
              Experience the Vernacular AI Counselor
            </h2>
            <p className="text-xs sm:text-sm text-[#4E5458] font-indic">
              Test how DreamCatcher delivers domain-accurate guidance in regional Indian languages with direct scholarship matching.
            </p>
          </div>

          {/* Persona Switcher Chips */}
          <div className="flex flex-wrap items-center justify-center gap-2">
            <span className="text-xs font-bold text-[#4E5458] uppercase mr-2 font-indic">Select Sample Persona:</span>
            {samplePersonas.map((p, idx) => (
              <button
                key={idx}
                onClick={() => handleSelectPersona(p)}
                className={`px-3.5 py-2 rounded-xl text-xs font-bold transition-all font-indic touch-target ${
                  simulatorStudent.full_name === p.name
                    ? 'bg-[#3D2123] text-[#F8F1EC] shadow-sm'
                    : 'bg-white text-[#4E5458] hover:bg-[#EBD1C6]/30 border border-[#EBD1C6]'
                }`}
              >
                {p.name} ({p.lang.toUpperCase()})
              </button>
            ))}
          </div>

          {/* Simulator Box */}
          <div className="bg-white rounded-2xl shadow-xl border border-[#EBD1C6] overflow-hidden">
            
            {/* Simulator Header */}
            <div className="bg-[#3D2123] text-[#F8F1EC] p-4 sm:p-5 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b border-[#2A1517]">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-lg bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center font-bold">
                  <Sparkles className="w-5 h-5" />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="font-bold text-sm font-indic">{simulatorStudent.full_name}</span>
                    <span className="bg-[#EBD1C6] text-[#3D2123] text-[10px] font-extrabold px-2 py-0.5 rounded uppercase">
                      {simulatorStudent.preferred_language.toUpperCase()}
                    </span>
                  </div>
                  <p className="text-xs text-[#EBD1C6]/90 font-indic">
                    {simulatorStudent.education_level_label} • {simulatorStudent.category_label} • {simulatorStudent.village_location}
                  </p>
                </div>
              </div>

              <div className="text-xs text-[#EBD1C6] font-semibold font-indic">
                Simulated AI Engine
              </div>
            </div>

            {/* Inquiry Form */}
            <div className="p-5 sm:p-7 space-y-4">
              <div>
                <label className="block text-xs font-bold text-[#3D2123] uppercase tracking-wider mb-1.5 font-indic">
                  Student's Career / Scholarship Question:
                </label>
                <div className="flex flex-col sm:flex-row gap-2">
                  <input
                    type="text"
                    value={simulatorQuery}
                    onChange={(e) => setSimulatorQuery(e.target.value)}
                    className="flex-1 px-4 py-3 text-sm border border-[#EBD1C6] rounded-xl focus:ring-2 focus:ring-[#3D2123] font-medium font-indic bg-[#F8F1EC]/40"
                  />
                  <button
                    onClick={() => handleRunSimulation()}
                    disabled={isSimulating}
                    className="px-6 py-3 bg-[#3D2123] hover:bg-[#2A1517] text-white font-bold text-xs rounded-xl shadow flex items-center justify-center gap-2 transition-all font-indic touch-target disabled:opacity-50"
                  >
                    {isSimulating ? (
                      <Sparkles className="w-4 h-4 animate-spin text-[#EBD1C6]" />
                    ) : (
                      <ArrowRight className="w-4 h-4 text-[#EBD1C6]" />
                    )}
                    <span>Ask Counselor</span>
                  </button>
                </div>
              </div>

              {/* Live AI Response Preview */}
              {simulatorResponse && (
                <div className="mt-5 p-5 bg-[#F8F1EC] border border-[#EBD1C6] rounded-xl space-y-3 animate-in fade-in duration-200">
                  <div className="flex items-center justify-between border-b border-[#EBD1C6] pb-2">
                    <span className="text-xs font-bold text-[#3D2123] flex items-center gap-1.5 font-indic">
                      <Sparkles className="w-4 h-4 text-[#A83E28]" />
                      <span>Counselor Recommendation ({simulatorStudent.preferred_language.toUpperCase()}):</span>
                    </span>
                    <button
                      onClick={() => {
                        if ('speechSynthesis' in window) {
                          const utterance = new SpeechSynthesisUtterance(simulatorResponse.text.replace(/[*#]/g, ''));
                          window.speechSynthesis.speak(utterance);
                        }
                      }}
                      className="flex items-center gap-1 text-xs text-[#A83E28] font-bold hover:underline"
                    >
                      <Volume2 className="w-3.5 h-3.5" />
                      <span>Audio Playback</span>
                    </button>
                  </div>

                  <div className="text-xs text-[#2A1517] font-indic whitespace-pre-wrap leading-relaxed">
                    {simulatorResponse.text}
                  </div>

                  {simulatorResponse.pathway && (
                    <div className="text-xs bg-white p-2.5 rounded-lg border border-[#EBD1C6] text-[#3D2123] font-bold font-indic flex items-center gap-2">
                      <Award className="w-4 h-4 text-[#A83E28] shrink-0" />
                      <span>Recommended Route: {simulatorResponse.pathway}</span>
                    </div>
                  )}

                  {simulatorResponse.schemes?.length > 0 && (
                    <div className="space-y-1">
                      <span className="text-[10px] uppercase font-bold text-[#4E5458] block">Matched Schemes:</span>
                      {simulatorResponse.schemes.map((s, idx) => (
                        <div key={idx} className="text-xs bg-emerald-50 text-emerald-900 px-2 py-0.5 rounded border border-emerald-200 font-indic font-medium flex items-center gap-1">
                          <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                          <span>{s}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}

            </div>

          </div>

        </div>
      </section>

      {/* ============================================================ */}
      {/* 4. MISSION STORY & THE AWARENESS DIVIDE                     */}
      {/* ============================================================ */}
      <section id="mission" className="py-16 px-4 sm:px-6 lg:px-8 bg-white scroll-mt-24">
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-10 items-center">
          
          <div className="lg:col-span-6 space-y-5">
            <div className="inline-flex items-center gap-1.5 bg-[#EBD1C6] text-[#3D2123] text-xs font-bold px-3 py-1 rounded-full border border-[#4E5458]/30 font-indic">
              <HeartHandshake className="w-3.5 h-3.5 text-[#3D2123]" />
              <span>The Problem We Solve</span>
            </div>

            <h2 className="text-2xl sm:text-3xl font-extrabold text-[#3D2123] font-indic leading-snug">
              Why 80% of Rural Students Miss Out on Educational Opportunities
            </h2>

            <p className="text-xs sm:text-sm text-[#4E5458] leading-relaxed font-indic">
              In rural India, educational opportunities and government scholarships exist in abundance, but information is fragmented. Most village students make irreversible life decisions based solely on what a few local peers did, often unaware of high-demand vocational diplomas, tuition fee waivers, or affirmative action benefits.
            </p>

            <div className="space-y-3 pt-2">
              <div className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-rose-100 text-rose-800 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">✕</div>
                <p className="text-xs text-[#3D2123] font-indic">
                  <strong>The Smartphone Myth:</strong> Millions of the most disadvantaged students do not own personal smartphones and cannot proactively download career apps.
                </p>
              </div>

              <div className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">✓</div>
                <p className="text-xs text-[#3D2123] font-indic">
                  <strong>The DreamCatcher Force Multiplier:</strong> We turn every teacher, school, and NGO field officer into an AI-powered counseling hub using a single shared tablet.
                </p>
              </div>
            </div>
          </div>

          <div className="lg:col-span-6">
            <div className="bg-gradient-to-br from-[#3D2123] to-[#2A1517] text-[#F8F1EC] p-6 sm:p-8 rounded-3xl shadow-xl space-y-5 border border-[#4E5458]">
              <h3 className="font-bold text-lg font-indic text-[#EBD1C6]">Core Tenets of Our Public Architecture</h3>
              
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                <div className="bg-[#4E5458]/40 p-3.5 rounded-xl border border-[#4E5458]">
                  <div className="font-bold text-white font-indic mb-1 flex items-center gap-1.5">
                    <Clock className="w-4 h-4 text-[#EBD1C6]" />
                    <span>Under 60s Intake</span>
                  </div>
                  <p className="text-[#F8F1EC]/80 text-[11px] font-indic">
                    KoboToolbox-style fast touch entry so volunteers can triage whole classrooms quickly.
                  </p>
                </div>

                <div className="bg-[#4E5458]/40 p-3.5 rounded-xl border border-[#4E5458]">
                  <div className="font-bold text-white font-indic mb-1 flex items-center gap-1.5">
                    <Globe className="w-4 h-4 text-[#EBD1C6]" />
                    <span>True Indic Vernacular</span>
                  </div>
                  <p className="text-[#F8F1EC]/80 text-[11px] font-indic">
                    Native Devanagari and Gujarati scripts with culturally tuned vocational guidance.
                  </p>
                </div>

                <div className="bg-[#4E5458]/40 p-3.5 rounded-xl border border-[#4E5458]">
                  <div className="font-bold text-white font-indic mb-1 flex items-center gap-1.5">
                    <FileCheck className="w-4 h-4 text-emerald-400" />
                    <span>Direct DBT Scholarship Link</span>
                  </div>
                  <p className="text-[#F8F1EC]/80 text-[11px] font-indic">
                    Immediate mapping to state portals like MahaDBT, MYSY, and National Scholarship Portal.
                  </p>
                </div>

                <div className="bg-[#4E5458]/40 p-3.5 rounded-xl border border-[#4E5458]">
                  <div className="font-bold text-white font-indic mb-1 flex items-center gap-1.5">
                    <ShieldCheck className="w-4 h-4 text-[#EBD1C6]" />
                    <span>CommCare Longitudinal Notes</span>
                  </div>
                  <p className="text-[#F8F1EC]/80 text-[11px] font-indic">
                    Persistent student case history across camps and school terms.
                  </p>
                </div>
              </div>
            </div>
          </div>

        </div>
      </section>

      {/* ============================================================ */}
      {/* 5. VERIFIED SCHOLARSHIPS TICKER                             */}
      {/* ============================================================ */}
      <section id="scholarships" className="py-12 bg-[#2A1517] text-white px-4 sm:px-6 lg:px-8 border-y border-[#3D2123] scroll-mt-24">
        <div className="max-w-7xl mx-auto space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div>
              <span className="text-[10px] text-[#EBD1C6] uppercase tracking-widest font-extrabold">Central & State Database</span>
              <h3 className="text-lg font-bold font-indic text-white">Mapped Government Schemes & Scholarships</h3>
            </div>
            <span className="text-xs text-[#EBD1C6]/80 font-indic">Auto-matched per student's category & education</span>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 text-xs">
            {[
              { name: 'MahaDBT Post-Matric', tag: 'Maharashtra' },
              { name: 'MYSY Mukhyamantri', tag: 'Gujarat' },
              { name: 'NSP Central Schemes', tag: 'All India' },
              { name: 'ITI Craftsmen (CTS)', tag: 'Skill India' },
              { name: 'AICTE Pragati Girls', tag: 'Polytechnic' },
              { name: 'PMKVY 4.0 Green Jobs', tag: 'Vocational' }
            ].map((scheme, idx) => (
              <div key={idx} className="bg-[#3D2123] border border-[#4E5458] p-3 rounded-xl space-y-1">
                <span className="text-[9px] bg-[#EBD1C6]/20 text-[#EBD1C6] px-1.5 py-0.5 rounded font-bold border border-[#EBD1C6]/30">
                  {scheme.tag}
                </span>
                <div className="font-bold text-white text-xs font-indic pt-1">{scheme.name}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ============================================================ */}
      {/* 6. IMPACT STATS & GROUND TESTIMONIALS                        */}
      {/* ============================================================ */}
      <section id="impact" className="py-16 px-4 sm:px-6 lg:px-8 bg-white scroll-mt-24">
        <div className="max-w-7xl mx-auto space-y-12">
          
          <div className="text-center space-y-2 max-w-2xl mx-auto">
            <h2 className="text-2xl sm:text-3xl font-extrabold text-[#3D2123] font-indic">
              Ground Validation & Reach
            </h2>
            <p className="text-xs sm:text-sm text-[#4E5458] font-indic">
              Transforming secondary schools and tribal development blocks across western and northern India.
            </p>
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6">
            <div className="bg-[#F8F1EC] border border-[#EBD1C6] rounded-2xl p-5 text-center space-y-1 shadow-xs">
              <div className="text-3xl sm:text-4xl font-extrabold text-[#3D2123] font-indic">45,000+</div>
              <div className="text-xs font-bold text-[#3D2123] font-indic">Students Guided</div>
              <div className="text-[11px] text-[#4E5458] font-indic">Across 280+ rural hamlets</div>
            </div>

            <div className="bg-[#F8F1EC] border border-[#EBD1C6] rounded-2xl p-5 text-center space-y-1 shadow-xs">
              <div className="text-3xl sm:text-4xl font-extrabold text-[#A83E28] font-indic">3,400+</div>
              <div className="text-xs font-bold text-[#3D2123] font-indic">Village Camps Run</div>
              <div className="text-[11px] text-[#4E5458] font-indic">By teachers & NGO coordinators</div>
            </div>

            <div className="bg-[#F8F1EC] border border-[#EBD1C6] rounded-2xl p-5 text-center space-y-1 shadow-xs">
              <div className="text-3xl sm:text-4xl font-extrabold text-[#285B43] font-indic">₹18.4 Cr</div>
              <div className="text-xs font-bold text-[#3D2123] font-indic">Scholarships Mapped</div>
              <div className="text-[11px] text-[#4E5458] font-indic">Tuition waivers & stipends</div>
            </div>

            <div className="bg-[#F8F1EC] border border-[#EBD1C6] rounded-2xl p-5 text-center space-y-1 shadow-xs">
              <div className="text-3xl sm:text-4xl font-extrabold text-[#522E31] font-indic">94%</div>
              <div className="text-xs font-bold text-[#3D2123] font-indic">Volunteer Satisfaction</div>
              <div className="text-[11px] text-[#4E5458] font-indic">Ease of use & zero lag</div>
            </div>
          </div>

          {/* Testimonial Quote */}
          <div className="bg-gradient-to-r from-[#3D2123] to-[#2A1517] rounded-3xl p-6 sm:p-10 text-white shadow-xl flex flex-col md:flex-row items-center gap-6">
            <div className="w-16 h-16 rounded-2xl bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center shrink-0 font-bold text-2xl">
              ”
            </div>
            <div className="space-y-2">
              <p className="text-sm sm:text-base italic text-[#F8F1EC] font-indic leading-relaxed">
                "In our Zilla Parishad school, students often dropped out after 10th because they assumed engineering and technical diplomas required massive coaching fees. DreamCatcher helped them realize government polytechnics are 100% free with their OBC/SC scholarship."
              </p>
              <div className="text-xs text-[#EBD1C6] font-bold font-indic">
                — Anand Kulkarni, Government High School Teacher, Shindewadi Camp
              </div>
            </div>
          </div>

        </div>
      </section>

      {/* ============================================================ */}
      {/* 7. FINAL CTA BANNER                                          */}
      {/* ============================================================ */}
      <section className="py-16 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-[#2A1517] via-[#3D2123] to-[#2A1517] text-white text-center relative overflow-hidden">
        <div className="max-w-3xl mx-auto space-y-6 relative z-10">
          <h2 className="text-3xl sm:text-4xl font-extrabold font-indic text-white">
            Ready to Organize a Guidance Camp in Your Village?
          </h2>
          <p className="text-xs sm:text-sm text-[#EBD1C6] max-w-xl mx-auto font-indic">
            Register as a Government School Teacher, Block Officer, or NGO Coordinator in 30 seconds. No special hardware required.
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-2">
            <button
              onClick={onEnterAuth}
              className="w-full sm:w-auto px-8 py-4 bg-[#A83E28] hover:bg-[#8F3320] text-white font-extrabold text-sm rounded-xl shadow-xl flex items-center justify-center gap-2 transition-all font-indic touch-target"
            >
              <Users className="w-4 h-4" />
              <span>Field Volunteer Registration</span>
            </button>
          </div>
        </div>
      </section>

      {/* ============================================================ */}
      {/* 8. FOOTER                                                    */}
      {/* ============================================================ */}
      <footer className="bg-[#2A1517] text-[#EBD1C6]/80 text-xs py-8 px-4 sm:px-8 border-t border-[#3D2123] font-indic">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded-md bg-[#EBD1C6] text-[#3D2123] flex items-center justify-center font-bold text-xs">
              <Compass className="w-4 h-4" />
            </div>
            <span className="font-bold text-white text-sm">DreamCatcher</span>
            <span className="text-[#EBD1C6]/60">• Public AI Career Guidance Infrastructure</span>
          </div>
          <div className="text-center md:text-right text-[11px] text-[#EBD1C6]/60">
            Designed for rural field operations • UX4G Indic Typography Standards
          </div>
        </div>
      </footer>

    </div>
  );
}
