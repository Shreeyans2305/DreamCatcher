import React, { useState } from 'react';
import { useLanguage } from '../context/LanguageContext';
import { useAuth } from '../context/AuthContext';
import { dummyAiEngine } from '../services/dummyAiEngine';
import DreamCatcherWind from '../components/ui/DreamCatcherWind';
import DreamCatcherIcon from '../components/ui/DreamCatcherIcon';
import GlassLanguageDropdown from '../components/ui/GlassLanguageDropdown';
import { motion, AnimatePresence, useReducedMotion } from 'framer-motion';
import { 
  ArrowRight, 
  Users, 
  Play, 
  Send,
  Sparkles
} from 'lucide-react';

export default function LandingPageView({ onEnterAuth, onEnterPortal }) {
  const { t, uiLanguage } = useLanguage();
  const { isAuthenticated } = useAuth();
  const shouldReduceMotion = useReducedMotion();

  // Authentic Student Personas with multilingual queries
  const samplePersonas = [
    {
      id: 'pooja',
      name: uiLanguage === 'mr' ? 'पूजा जाधव' : uiLanguage === 'hi' ? 'पूजा जाधव' : uiLanguage === 'gu' ? 'પૂજા જાધવ' : 'Pooja Jadhav',
      place: uiLanguage === 'mr' ? 'सातारा' : uiLanguage === 'hi' ? 'सतारा' : uiLanguage === 'gu' ? 'સાતારા' : 'Satara',
      classInfo: uiLanguage === 'mr' ? '१० वी उत्तीर्ण' : uiLanguage === 'hi' ? '१०वीं पास' : uiLanguage === 'gu' ? '૧૦મું પાસ' : '10th Pass',
      lang: 'mr',
      queries: {
        en: 'What are the best ITI or polytechnic diploma trades for getting a job immediately after Class 10th?',
        mr: '१० वी नंतर लगेच नोकरीसाठी आयटीआय किंवा पॉलिटेक्निक चे कोणते ट्रेड्स बेस्ट आहेत?',
        hi: '१०वीं के बाद तुरंत नौकरी पाने के लिए आईटीआई या पॉलिटेक्निक के कौन से ट्रेड सबसे अच्छे हैं?',
        gu: '૧૦મા પછી તરત જ નોકરી મેળવવા માટે આઈટીઆઈ કે પોલિટેકનિકના કયા ટ્રેડ સૌથી સારા છે?'
      }
    },
    {
      id: 'rahul',
      name: uiLanguage === 'mr' ? 'राहुल मोरे' : uiLanguage === 'hi' ? 'राहुल मोरे' : uiLanguage === 'gu' ? 'રાહુલ મોરે' : 'Rahul More',
      place: uiLanguage === 'mr' ? 'पाटण आदिवासी भाग' : uiLanguage === 'hi' ? 'पाटन आदिवासी क्षेत्र' : uiLanguage === 'gu' ? 'પાટણ આદિવાસી વિસ્તાર' : 'Patan Tribal Belt',
      classInfo: uiLanguage === 'mr' ? '१० वी • वीज तंत्रज्ञान आवड' : uiLanguage === 'hi' ? '१०वीं • इलेक्ट्रीशियन रुचि' : uiLanguage === 'gu' ? '૧૦મું • ઈલેક્ટ્રિકલ રસ' : '10th Pass • Electrical',
      lang: 'hi',
      queries: {
        en: 'How to get a government job in railways or electricity board after wireman trade, and which scholarship is available?',
        mr: 'वायरमन किंवा इलेक्ट्रीशियन ट्रेडनंतर रेल्वे किंवा वीज मंडळात सरकारी नोकरी कशी मिळते, आणि कोणती शिष्यवृत्ती मिळेल?',
        hi: 'वायरमैन या इलेक्ट्रीशियन ट्रेड के बाद रेलवे या बिजली बोर्ड में नौकरी कैसे मिलती है, और कौन सी छात्रवृत्ति मिलेगी?',
        gu: 'વાયરમેન કે ઇલેક્ટ્રિશિયન ટ્રેડ પછી રેલવે કે વીજળી બોર્ડમાં સરકારી નોકરી કેવી રીતે મળે?'
      }
    },
    {
      id: 'darshan',
      name: uiLanguage === 'mr' ? 'दर्शन पटेल' : uiLanguage === 'hi' ? 'दर्शन पटेल' : uiLanguage === 'gu' ? 'દર્શન પટેલ' : 'Darshan Patel',
      place: uiLanguage === 'mr' ? 'नवसारी' : uiLanguage === 'hi' ? 'नवसारी' : uiLanguage === 'gu' ? 'નવસારી' : 'Navsari',
      classInfo: uiLanguage === 'mr' ? '१० वी • डिप्लोमा इंजिनिअरिंग' : uiLanguage === 'hi' ? '१०वीं • डिप्लोमा इंजीनियरिंग' : uiLanguage === 'gu' ? '૧૦મું • ડિપ્લોમા એન્જિનિયરિંગ' : '10th Pass • Diploma Eng.',
      lang: 'gu',
      queries: {
        en: 'How to apply for diploma engineering admission and MYSY scholarship?',
        mr: 'डिप्लोमा इंजिनिअरिंग प्रवेश आणि शिष्यवृत्तीसाठी अर्ज कसा करावा?',
        hi: 'डिप्लोमा इंजीनियरिंग में प्रवेश और छात्रवृत्ति के लिए आवेदन कैसे करें?',
        gu: 'ડિપ્લોમા એન્જિનિયરિંગમાં એડમિશન અને MYSY સ્કોલરશીપ માટે કેવી રીતે અરજી કરવી?'
      }
    }
  ];

  const [selectedPersonaId, setSelectedPersonaId] = useState(samplePersonas[0].id);
  const selectedPersona = samplePersonas.find(p => p.id === selectedPersonaId) || samplePersonas[0];
  const [queryInput, setQueryInput] = useState(selectedPersona.queries[uiLanguage] || selectedPersona.queries.en);
  const [aiResponse, setAiResponse] = useState(null);
  const [aiError, setAiError] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  // Sync queryInput when language or persona switches
  React.useEffect(() => {
    setQueryInput(selectedPersona.queries[uiLanguage] || selectedPersona.queries.en);
    setAiResponse(null);
    setAiError(null);
  }, [uiLanguage, selectedPersonaId]);

  const handleSelectPersona = (p) => {
    setSelectedPersonaId(p.id);
    setQueryInput(p.queries[uiLanguage] || p.queries.en);
    setAiResponse(null);
    setAiError(null);
  };

  const handleRunGuidance = async () => {
    const question = queryInput.trim();
    if (!question) {
      setAiError(t('landing.demo_empty_question', 'Enter a question to get guidance.'));
      return;
    }

    setIsLoading(true);
    setAiResponse(null);
    setAiError(null);
    try {
      const studentMock = {
        full_name: selectedPersona.name,
        age_years: 16,
        education_level: 'grade_10',
        education_level_label: selectedPersona.classInfo,
        category: 'cat_obc',
        category_label: 'OBC',
        village_location: selectedPersona.place,
        preferred_language: uiLanguage
      };
      const res = await dummyAiEngine.generateGuidanceResponse(question, studentMock);
      setAiResponse(res);
    } catch (error) {
      console.error('Homepage AI demo failed:', error);
      setAiError(t('landing.demo_error', 'We could not generate guidance. Please try again.'));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F7F4EE] text-[#141414] selection:bg-[#161616] selection:text-[#FAF7F2] relative font-sans overflow-x-hidden">
      
      {/* Floating feather wind ambience */}
      <DreamCatcherWind showDreamcatchers={false} featherCount={16} windSpeed={0.85} opacity={0.5} />

      {/* ============================================================ */}
      {/* 1. COMPACT FLOATING iOS GLASSMORPHISM NAVBAR                 */}
      {/* ============================================================ */}
      <header className="fixed top-3 sm:top-4 inset-x-0 mx-auto max-w-4xl z-50 px-4 pointer-events-none">
        <div className="glass-nav rounded-full px-3.5 sm:px-5 py-1.5 flex items-center justify-between pointer-events-auto transition-all duration-300">
          
          {/* Brand Logo & Name */}
          <a
            href="#"
            onClick={(e) => {
              e.preventDefault();
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }}
            className="flex items-center gap-2 group no-underline text-inherit cursor-pointer"
          >
            <div className="w-7 h-7 rounded-full bg-[#161616] text-[#FAF7F2] flex items-center justify-center p-1 shadow-sm group-hover:scale-105 group-hover:bg-[#000000] transition-all">
              <DreamCatcherIcon className="w-4 h-4 text-[#FAF7F2]" />
            </div>
            <span className="font-display font-extrabold text-base tracking-tight text-[#141414]">
              {t('brand', 'DreamCatcher')}
            </span>
          </a>

          {/* Clean, Simple Anchor Links */}
          <nav className="hidden sm:flex items-center gap-1 text-xs font-bold text-[#555048]">
            <a href="#why-it-matters" className="px-3 py-1 rounded-full hover:text-black hover:bg-white/80 transition-all">
              {t('landing.nav_why', 'Why We Built This')}
            </a>
            <a href="#try-it" className="px-3 py-1 rounded-full hover:text-black hover:bg-white/80 transition-all">
              {t('landing.nav_demo', 'Live Demo')}
            </a>
          </nav>

          {/* Right Controls: Integrated Glass Language Dropdown + Action Button */}
          <div className="flex items-center gap-2">
            <GlassLanguageDropdown />

            {isAuthenticated ? (
              <button
                onClick={onEnterPortal}
                className="px-3.5 py-1 text-xs font-bold bg-[#141414] hover:bg-[#000000] text-white rounded-full transition-all shadow-sm flex items-center gap-1 cursor-pointer hover:scale-105"
              >
                <span>{t('landing.portal_btn', 'Portal')}</span>
                <ArrowRight className="w-3 h-3" />
              </button>
            ) : (
              <button
                onClick={onEnterAuth}
                className="px-3.5 py-1 text-xs font-bold bg-[#141414] hover:bg-[#000000] text-white rounded-full transition-all shadow-sm flex items-center gap-1 cursor-pointer hover:scale-105"
              >
                <Users className="w-3 h-3" />
                <span>{t('landing.login_btn', 'Volunteer Login')}</span>
              </button>
            )}
          </div>

        </div>
      </header>

      {/* ============================================================ */}
      {/* 2. HERO SECTION: BIG, BOLD, THICK & HUMAN                     */}
      {/* ============================================================ */}
      <section className="hero-section pt-28 sm:pt-36 pb-16 sm:pb-20 px-4 sm:px-6 text-center max-w-6xl mx-auto">

        {/* Hero Billboard Card with Background Image & Centered Big Title */}
        <motion.div
          initial={{ opacity: 0, scale: 0.98, y: 20 }}
          animate={{ opacity: 1, scale: 1, y: 0 }}
          transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="relative w-full rounded-3xl sm:rounded-[36px] overflow-hidden shadow-2xl border border-black/10 bg-[#141414] min-h-[380px] sm:min-h-[480px] flex items-center justify-center px-6 py-16 sm:py-24 mb-10 group"
        >
          {/* Background Image */}
          <img
            src="/catcherimage2.png"
            alt="DreamCatcher community learning"
            className="absolute inset-0 w-full h-full object-cover object-center"
          />





          {/* Text Centered in the Middle */}
          <div className="relative z-10 max-w-4xl mx-auto text-center px-4">
            <motion.h1
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.15 }}
              className="font-display font-black text-5xl sm:text-7xl lg:text-8xl text-[#F5F0E8] tracking-tight leading-[0.98]"
            >
              {t('landing.hero_title_1', 'BIG DREAMS.')}<br />
              <span className="inline-block bg-black/70 px-5 py-2 sm:px-7 sm:py-3 text-[#D94F2B] italic font-serif-zen font-normal">
                {t('landing.hero_title_2', 'CATCH THEM HERE.')}
              </span>
            </motion.h1>
          </div>
        </motion.div>

        {/* Real, human, grounded subtext */}
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.25 }}
          className="text-base sm:text-xl text-[#524B41] max-w-2xl mx-auto font-medium leading-relaxed mb-10"
        >
          {t('landing.hero_subtitle')}
        </motion.p>

        {/* Bold Action Buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.35 }}
          className="flex flex-col sm:flex-row items-center justify-center gap-3.5 mb-14"
        >
          <button
            onClick={onEnterAuth}
            className="w-full sm:w-auto px-8 py-4 text-base font-bold bg-[#141414] hover:bg-[#000000] text-white rounded-full transition-all shadow-md flex items-center justify-center gap-2.5 cursor-pointer hover:scale-105 active:scale-95"
          >
            <Users className="w-5 h-5" />
            <span>{t('landing.cta_launch', 'Launch Field Counselor Portal')}</span>
            <ArrowRight className="w-5 h-5" />
          </button>

          <a
            href="#try-it"
            className="w-full sm:w-auto px-7 py-4 text-base font-bold bg-white/80 hover:bg-white text-[#141414] border border-[#D5CCBD] rounded-full transition-all shadow-xs flex items-center justify-center gap-2 cursor-pointer hover:scale-105 active:scale-95"
          >
            <Play className="w-4 h-4 fill-current text-[#7A6F62]" />
            <span>{t('landing.cta_test', 'Test the AI Counselor')}</span>
          </a>
        </motion.div>

        {/* Big Bold Human Numbers */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5, delay: 0.45 }}
          className="grid grid-cols-2 max-w-lg mx-auto gap-4 text-left"
        >
          <div className="glass-card p-5 rounded-2xl">
            <span className="font-display font-black text-2xl sm:text-3xl lg:text-4xl text-[#141414] block mb-1">
              {t('landing.stat_langs', 'Multilingual')}
            </span>
            <span className="text-xs sm:text-sm font-bold text-[#61574C]">
              {t('landing.stat_langs_label', 'Marathi • Hindi • Gujarati • EN')}
            </span>
          </div>

          <div className="glass-card p-5 rounded-2xl">
            <span className="font-display font-black text-2xl sm:text-3xl lg:text-4xl text-[#DE482B] block mb-1">
              {t('landing.stat_free', '100% Free')}
            </span>
            <span className="text-xs sm:text-sm font-bold text-[#61574C]">
              {t('landing.stat_free_label', 'Public Service Forever')}
            </span>
          </div>
        </motion.div>

      </section>

      {/* ============================================================ */}
      {/* 3. SECTION: WHY IT MATTERS (Human, Genuine & Authentic)       */}
      {/* ============================================================ */}
      <section id="why-it-matters" className="py-20 px-4 sm:px-6 max-w-5xl mx-auto border-t border-[#E5DED4]">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="grid grid-cols-1 lg:grid-cols-12 gap-10 items-center"
        >
          <div className="lg:col-span-5 space-y-4 text-left">
            <span className="text-xs font-extrabold uppercase tracking-wider text-[#DE482B]">
              {t('landing.why_tag', 'The Reality On The Ground')}
            </span>
            <h2 className="font-display font-black text-3xl sm:text-4xl text-[#141414] leading-tight">
              {t('landing.why_heading', "Most students don't lack ambition. They lack information.")}
            </h2>
            <p className="text-sm sm:text-base text-[#524B41] font-medium leading-relaxed">
              {t('landing.why_p1')}
            </p>
            <p className="text-sm sm:text-base text-[#524B41] font-medium leading-relaxed">
              {t('landing.why_p2')}
            </p>
          </div>

          <div className="lg:col-span-7 space-y-3.5">
            <div className="glass-card p-5 rounded-2xl flex items-start gap-4">
              <div className="w-9 h-9 rounded-full bg-[#161616] text-white flex items-center justify-center font-black text-sm shrink-0 mt-0.5">
                01
              </div>
              <div>
                <h3 className="font-display font-bold text-base text-[#141414] mb-1">
                  {t('landing.pillar_1_title')}
                </h3>
                <p className="text-xs sm:text-sm text-[#5C554B] font-medium leading-relaxed">
                  {t('landing.pillar_1_desc')}
                </p>
              </div>
            </div>

            <div className="glass-card p-5 rounded-2xl flex items-start gap-4">
              <div className="w-9 h-9 rounded-full bg-[#DE482B] text-white flex items-center justify-center font-black text-sm shrink-0 mt-0.5">
                02
              </div>
              <div>
                <h3 className="font-display font-bold text-base text-[#141414] mb-1">
                  {t('landing.pillar_2_title')}
                </h3>
                <p className="text-xs sm:text-sm text-[#5C554B] font-medium leading-relaxed">
                  {t('landing.pillar_2_desc')}
                </p>
              </div>
            </div>

            <div className="glass-card p-5 rounded-2xl flex items-start gap-4">
              <div className="w-9 h-9 rounded-full bg-[#161616] text-white flex items-center justify-center font-black text-sm shrink-0 mt-0.5">
                03
              </div>
              <div>
                <h3 className="font-display font-bold text-base text-[#141414] mb-1">
                  {t('landing.pillar_3_title')}
                </h3>
                <p className="text-xs sm:text-sm text-[#5C554B] font-medium leading-relaxed">
                  {t('landing.pillar_3_desc')}
                </p>
              </div>
            </div>
          </div>
        </motion.div>
      </section>

      {/* ============================================================ */}
      {/* 4. SECTION: LIVE DREAM MATCHER (Interactive & Punchy)        */}
      {/* ============================================================ */}
      <section id="try-it" className="py-20 px-4 sm:px-6 max-w-4xl mx-auto border-t border-[#E5DED4]">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.5 }}
          className="text-center mb-8"
        >
          <span className="text-xs font-extrabold uppercase tracking-wider text-[#DE482B] block mb-2">
            {t('landing.demo_tag', 'Try It Yourself')}
          </span>
          <h2 className="font-display font-black text-3xl sm:text-5xl text-[#141414] tracking-tight mb-3">
            {t('landing.demo_heading', 'See how the guidance works.')}
          </h2>
          <p className="text-sm sm:text-base text-[#524B41] font-medium max-w-lg mx-auto">
            {t('landing.demo_subtitle', 'Choose a real student case below to see how DreamCatcher gives immediate, realistic advice.')}
          </p>
        </motion.div>

        {/* Persona Selectors */}
        <div className="flex flex-wrap items-center justify-center gap-2.5 mb-6">
          {samplePersonas.map((p) => {
            const isSelected = selectedPersona.id === p.id;
            return (
              <button
                key={p.id}
                onClick={() => handleSelectPersona(p)}
                className={`px-5 py-2.5 rounded-full text-xs sm:text-sm font-bold transition-all cursor-pointer ${
                  isSelected
                    ? 'bg-[#141414] text-white shadow-sm scale-105'
                    : 'bg-white/70 border border-[#D5CCBD] text-[#555048] hover:text-black hover:bg-white'
                }`}
              >
                <span>{p.name}</span>
                <span className="opacity-60 ml-1.5 font-normal">({p.place} • {p.classInfo})</span>
              </button>
            );
          })}
        </div>

        {/* Interactive Query Box */}
        <div className="glass-card rounded-2xl p-5 sm:p-6 shadow-sm mb-6 text-left">
          <label className="block text-xs font-extrabold uppercase text-[#7A746C] tracking-wider mb-2">
            {t('landing.demo_q_label', 'Question Asked by Student:')}
          </label>
          <div className="flex flex-col sm:flex-row gap-3">
            <input
              type="text"
              value={queryInput}
              onChange={(e) => setQueryInput(e.target.value)}
              className="flex-1 px-4 py-3 bg-white/90 border border-[#D5CCBD] rounded-xl text-sm font-semibold text-[#141414] focus:outline-none focus:border-[#141414]"
            />
            <button
              onClick={handleRunGuidance}
              disabled={isLoading}
              className="px-7 py-3 bg-[#141414] hover:bg-[#000000] text-white text-sm font-bold rounded-xl transition-all shadow-sm flex items-center justify-center gap-2 cursor-pointer shrink-0 disabled:opacity-50 hover:scale-105 active:scale-95"
            >
              <Send className="w-4 h-4" />
              <span>{isLoading ? t('landing.demo_btn_thinking', 'Thinking...') : t('landing.demo_btn_ask', 'Get Answer')}</span>
            </button>
          </div>
        </div>

        {aiError && (
          <div role="alert" className="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-medium text-red-800">
            {aiError}
          </div>
        )}
        {/* Answer Result Card */}
        {aiResponse && (
          <motion.div
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            className="glass-card rounded-2xl p-6 sm:p-8 shadow-sm space-y-4 text-left border-l-4 border-l-[#DE482B]"
          >
            <div className="flex items-center justify-between pb-3 border-b border-[#EAE2D5]">
              <div className="flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-[#DE482B]" />
                <span className="font-display font-bold text-base text-[#141414]">
                  {t('landing.demo_rec_title', 'Recommendation for')} {selectedPersona.name}
                </span>
              </div>
              <span className="text-xs bg-[#E8EFE9] text-[#2C4A33] px-2.5 py-0.5 rounded-full font-bold">
                {t('landing.demo_matched_badge', 'Actionable Match')}
              </span>
            </div>

            <p className="text-sm sm:text-base text-[#38332C] font-medium leading-relaxed">
              {aiResponse.text || aiResponse.summary || aiResponse.response_text}
            </p>

            {aiResponse.pathway && (
              <div className="rounded-xl bg-[#FFF7F4] border border-[#F1D4CC] p-4">
                <span className="text-[10px] font-extrabold uppercase tracking-wider text-[#A63722] block mb-1">
                  {t('landing.demo_pathway', 'Recommended pathway')}
                </span>
                <p className="text-sm font-bold text-[#302B25] leading-relaxed">{aiResponse.pathway}</p>
              </div>
            )}

            {aiResponse.schemes?.length > 0 && (
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                {aiResponse.schemes.slice(0, 2).map((scheme, idx) => (
                  <div key={idx} className="bg-white/90 border border-[#D5CCBD] p-4 rounded-xl">
                    <span className="text-[10px] font-extrabold uppercase tracking-wider text-[#7A746C] block mb-1">
                      {t('landing.demo_scheme', 'Support option')} {idx + 1}
                    </span>
                    <span className="text-xs text-[#585149] font-medium block leading-normal">{scheme}</span>
                  </div>
                ))}
              </div>
            )}

            {aiResponse.nextStep && (
              <div className="text-sm text-[#38332C] font-medium leading-relaxed">
                <span className="font-bold">{t('landing.demo_next_step', 'Next step:')} </span>
                {aiResponse.nextStep}
              </div>
            )}
          </motion.div>
        )}

      </section>

      {/* ============================================================ */}
      {/* 5. BIG BOLD CALL TO ACTION: VOLUNTEER CIRCLE                 */}
      {/* ============================================================ */}
      <section className="py-20 px-4 sm:px-6 max-w-4xl mx-auto text-center">
        <div className="glass-dark text-white rounded-3xl p-8 sm:p-14 shadow-2xl relative overflow-hidden">
          <div className="relative z-10 space-y-5">
            <span className="text-xs font-black uppercase tracking-widest text-[#E5978B] block">
              {t('landing.cta_box_tag', 'For Teachers & Youth Volunteers')}
            </span>
            <h2 className="font-display font-black text-3xl sm:text-5xl lg:text-6xl text-white tracking-tight leading-tight">
              {t('landing.cta_box_title', 'Ready to guide students in your village?')}
            </h2>
            <p className="text-sm sm:text-base text-white/80 max-w-xl mx-auto font-medium leading-relaxed">
              {t('landing.cta_box_desc', 'No technical expertise needed. Sign in with your Volunteer ID, register students in seconds, and start counseling.')}
            </p>
            <div className="pt-4">
              <button
                onClick={onEnterAuth}
                className="px-8 py-4 bg-[#FFFFFF] hover:bg-[#F2EBE4] text-[#121212] font-display font-black text-sm sm:text-base rounded-full shadow-lg transition-all hover:scale-105 active:scale-95 cursor-pointer"
              >
                {t('landing.cta_box_btn', 'Sign In to Volunteer Portal →')}
              </button>
            </div>
          </div>
        </div>
      </section>

    </div>
  );
}
