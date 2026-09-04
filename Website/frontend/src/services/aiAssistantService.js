/**
 * DreamCatcher AI Career Assistant Service
 * Connects to the FastAPI backend (/api/v1/assistant/chat) with an intelligent,
 * profile-grounded local counselor engine for offline and low-latency field guidance.
 */

// Curated government schemes and opportunities mapped to common student aspirations
const ASPIRATION_KNOWLEDGE_BASE = {
  police_defense: {
    title: 'Police & Defense Services',
    keywords: ['police', 'defense', 'army', 'navy', 'air force', 'constable', 'soldier', 'crpf', 'bsf', 'militry'],
    pathway: {
      en: 'Complete 10th/12th Board Exams → Clear Physical Endurance Test (PET) → State Police Bharti / Agnipath Recruitment.',
      mr: '१० वी/१२ वी परीक्षा पूर्ण करा → शारीरिक चाचणी (PET) उत्तीर्ण व्हा → महाराष्ट्र पोलीस भरती / अग्निवीर सैन्य भरती.',
      hi: '10वीं/12वीं बोर्ड पास करें → शारीरिक दक्षता परीक्षा (PET) पास करें → राज्य पुलिस भर्ती / अग्निवीर सेना भर्ती.',
      gu: '૧૦મી/૧૨મી બોર્ડ પાસ કરો → શારીરિક કસોટી (PET) પાસ કરો → પોલીસ ભરતી / અગ્નિવીર સેના ભરતી.'
    },
    criteria: {
      mr: 'किमान वय १८ वर्षे पूर्ण, १० वी/१२ वी उत्तीर्ण आणि शारीरिक क्षमता चाचणी (धावणे व उंची निकष) अनिवार्य आहेत.',
      hi: 'न्यूनतम आयु 18 वर्ष, 10वीं/12वीं बोर्ड उत्तीर्ण और शारीरिक दक्षता परीक्षा (दौड़ एवं शारीरिक माप) अनिवार्य है।',
      gu: 'ન્યૂનતમ ઉંમર ૧૮ વર્ષ, ૧૦મી/૧૨મી પાસ અને શારીરિક કસોટી (દોડ અને ઊંચાઈ) ફરજિયાત છે.',
      en: 'Minimum age 18 years, 10th/12th Board completion, and meeting Physical Endurance Test (PET) criteria.'
    },
    opportunities: [
      {
        id: 'opp-police-01',
        title: 'Maharashtra Police Constable Recruitment (महाराष्ट्र पोलीस शिपाई भरती)',
        type: 'Government Recruitment',
        official_url: 'https://mahapolice.gov.in',
        deadline: 'Upcoming Annual Cycle (Oct - Dec 2026)',
        match_reason: 'Requires Class 10th or 12th pass with minimum height (165 cm for males, 155 cm for females).'
      },
      {
        id: 'opp-agnipath-02',
        title: 'Agniveer Army General Duty (GD) Recruitment',
        type: 'Defense Scheme',
        official_url: 'https://joinindianarmy.nic.in',
        deadline: 'Batch Rallies Ongoing',
        match_reason: 'Requires Class 10th pass with 45% aggregate and fitness endurance.'
      },
      {
        id: 'opp-mahadbt-03',
        title: 'MahaDBT Post-Matric Scholarship for Backward Classes (OBC/SC/ST)',
        type: 'Tuition & Living Grant',
        official_url: 'https://mahadbt.maharashtra.gov.in',
        deadline: '31 January 2027',
        match_reason: '100% exam and tuition fee waiver for eligible students pursuing higher secondary and coaching.'
      }
    ],
    chips: {
      en: ['What are the physical fitness tests?', 'What is the salary of a Police Constable?', 'Are there free coaching centers?', 'How to prepare for written exam?'],
      mr: ['शारीरिक चाचणीचे निकष काय आहेत?', 'पोलीस शिपायाचे वेतन किती असते?', 'मोफत पोलीस भरती अकॅडमी आहे का?', 'लेखी परीक्षेची तयारी कशी करावी?'],
      hi: ['शारीरिक परीक्षा के नियम क्या हैं?', 'पुलिस कांस्टेबल का वेतन कितना है?', 'क्या कोई मुफ्त कोचिंग योजना है?', 'लिखित परीक्षा की तैयारी कैसे करें?'],
      gu: ['શારીરિક કસોટીના નિયમો શું છે?', 'પોલીસ કોન્સ્ટેબલનો પગાર કેટલો છે?', 'મફત કોચિંગ યોજના છે?', 'લેખિત પરીક્ષાની તૈયારી કેવી રીતે કરવી?']
    }
  },
  vocational_iti: {
    title: 'Vocational & ITI Trades',
    keywords: ['iti', 'electrician', 'mechanic', 'fitter', 'welder', 'wireman', 'solar', 'automobile'],
    pathway: {
      en: 'Class 10th Pass → 1 or 2 Year ITI Trade Certificate → NCVT National Apprenticeship (Stipend ₹8,000-₹12,000/mo).',
      mr: '१० वी उत्तीर्ण → १ किंवा २ वर्ष आयटीआय ट्रेड प्रमाणपत्र → अप्रेंटिसशिप (दरमहा मानधन ₹८,०००-₹१२,०००).',
      hi: '10वीं पास → 1 या 2 साल का ITI ट्रेड कोर्स → राष्ट्रीय शिक्षुता (अप्रेंटिसशिप ₹8,000-₹12,000/माह).',
      gu: '૧૦મું પાસ → ૧ અથવા ૨ વર્ષનો ITI કોર્સ → રાષ્ટ્રીય એપ્રેન્ટિસશીપ (સ્ટાઇપેન્ડ ₹૮,૦૦૦-₹૧૨,૦૦૦).'
    },
    criteria: {
      mr: '१० वी उत्तीर्ण गुणपत्रिका, आधार कार्ड आणि रहिवासी दाखला केंद्रीभूत प्रवेशासाठी (CAP) आवश्यक आहेत.',
      hi: '10वीं बोर्ड पास अंकपत्र, आधार कार्ड और निवास प्रमाण पत्र आवश्यक हैं।',
      gu: '૧૦મું પાસ માર્કશીટ, આધાર કાર્ડ અને રહેઠાણ પ્રમાણપત્ર જરૂરી છે.',
      en: 'Class 10th pass marksheet, Aadhaar, and domicile certificate required for DVET admission.'
    },
    opportunities: [
      {
        id: 'opp-iti-01',
        title: 'Government ITI Centralized Admission Process (DVET Maharashtra)',
        type: 'Vocational Course',
        official_url: 'https://admission.dvet.gov.in',
        deadline: 'August Annual Intake',
        match_reason: 'Subsidized technical trade training with direct campus placement in manufacturing hubs.'
      },
      {
        id: 'opp-pmkvy-02',
        title: 'Pradhan Mantri Kaushal Vikas Yojana (PMKVY 4.0)',
        type: 'Free Skill Training',
        official_url: 'https://www.pmkvyofficial.org',
        deadline: 'Rolling Admissions',
        match_reason: 'Govt-funded short-term technical certificates with NSQF job placement.'
      }
    ],
    chips: {
      en: ['Which ITI trade has highest demand?', 'What is ITI apprentice stipend?', 'Can I do diploma after ITI?'],
      mr: ['कोणत्या आयटीआय ट्रेडला जास्त मागणी आहे?', 'अप्रेंटिसशिप मानधन किती मिळते?', 'आयटीआयनंतर डिप्लोमा करता येतो का?'],
      hi: ['किस ITI ट्रेड में सबसे ज्यादा जॉब्स हैं?', 'अप्रेंटिस का स्टाइपेंड कितना है?', 'क्या ITI के बाद डिप्लोमा कर सकते हैं?'],
      gu: ['કયા ITI ટ્રેડની સૌથી વધુ માંગ છે?', 'સ્ટાઇપેન્ડ કેટલું મળે છે?', 'ડિપ્લોમા કરી શકાય?']
    }
  },
  nursing_paramedical: {
    title: 'Healthcare & Nursing',
    keywords: ['nurse', 'nursing', 'doctor', 'hospital', 'paramedical', 'lab', 'anm', 'gnm'],
    pathway: {
      en: '12th Science (PCB) or 10th ANM Foundation → GNM Diploma or B.Sc. Nursing → Government PHC / Private Hospital Staff.',
      mr: '१२ वी विज्ञान किंवा १० वी नंतर एएनएम → जीएनएम डिप्लोमा / बी.एस्सी. नर्सिंग → प्राथमिक आरोग्य केंद्र / रुग्णालय.',
      hi: '12वीं साइंस या 10वीं के बाद ANM → GNM डिप्लोमा या B.Sc नर्सिंग → सरकारी अस्पताल या स्वास्थ्य केंद्र में नियुक्ति.',
      gu: '૧૨મું સાયન્સ અથવા ANM → GNM ડિપ્લોમા / નર્સિંગ → સરકારી દવાખાનું અથવા હોસ્પિટલ.'
    },
    criteria: {
      mr: 'एएनएमसाठी १० वी पास, जीएनएम/बी.एस्सी. नर्सिंगसाठी १२ वी विज्ञान (भौतिकशास्त्र, रसायनशास्त्र, जीवशास्त्र) किमान ४०-४५% गुणांसह आवश्यक.',
      hi: 'ANM के लिए 10वीं पास, GNM/B.Sc नर्सिंग के लिए 12वीं साइंस (PCB) न्यूनतम 40-45% अंकों के साथ आवश्यक है।',
      gu: 'ANM માટે ૧૦મું પાસ, GNM માટે ૧૨મું સાયન્સ (PCB) ૪૦-૪૫% ગુણ સાથે જરૂરી છે.',
      en: '10th pass for ANM foundation, or 12th Science (PCB) with 40-45% aggregate for GNM / B.Sc. Nursing.'
    },
    opportunities: [
      {
        id: 'opp-nurse-01',
        title: 'General Nursing & Midwifery (GNM) Government Quota',
        type: 'Paramedical Diploma',
        official_url: 'https://medical.maharashtra.gov.in',
        deadline: 'July - August Annual',
        match_reason: 'Subsidized nursing training with guaranteed clinical internship stipend.'
      }
    ],
    chips: {
      en: ['Difference between ANM and GNM?', 'Is NEET required for nursing?', 'Government jobs in hospital?'],
      mr: ['ANM आणि GNM मध्ये काय फरक आहे?', 'नर्सिंगसाठी NEET परीक्षा आवश्यक आहे का?', 'सरकारी रुग्णालयात नोकरी कशी मिळवायची?'],
      hi: ['ANM और GNM में क्या अंतर है?', 'क्या नर्सिंग के लिए NEET जरूरी है?', 'सरकारी अस्पताल में जॉब कैसे मिलती है?'],
      gu: ['ANM અને GNM વચ્ચે શું તફાવત છે?', 'NEET જરૂરી છે?', 'સરકારી નોકરી કેવી રીતે મળે?']
    }
  },
  agriculture_dairy: {
    title: 'Agriculture & Dairy Farming',
    keywords: ['agriculture', 'dairy', 'farm', 'krishi', 'farming', 'livestock', 'crop', 'soil', 'kisan', 'animal'],
    pathway: {
      en: 'Class 10th Pass → Diploma in Agriculture / Animal Husbandry → Modern Dairy Farm Management & NABARD / PM Kisan Subsidized Agro-Ventures.',
      mr: '१० वी उत्तीर्ण → कृषी / पशुसंवर्धन पदविका (Agri Diploma) → आधुनिक दुग्ध व्यवसाय व्यवस्थापन व नाबार्ड / पोकरा (PoCRA) कृषी अनुदान योजना.',
      hi: '10वीं पास → कृषि/पशुपालन डिप्लोमा → आधुनिक डेयरी फार्मिंग प्रबंधन एवं नाबार्ड / पीएम किसान अनुदान योजनाएं.',
      gu: '૧૦મું પાસ → કૃષિ / પશુપાલન ડિપ્લોમા → ડેરી ફાર્મિંગ વ્યવસ્થાપન અને નાબાર્ડ સરકારી યોજનાઓ.'
    },
    criteria: {
      mr: '१० वी उत्तीर्ण गुणपत्रिका, ७/१२ उतारा किंवा ग्रामीण रहिवासी दाखला कृषी व दुग्ध व्यवसाय अनुदान योजनांसाठी आवश्यक.',
      hi: '10वीं पास अंकपत्र, खतौनी/जमीन दस्तावेज या ग्रामीण निवास प्रमाण पत्र सरकारी अनुदान के लिए आवश्यक है।',
      gu: '૧૦મું પાસ માર્કશીટ, ૭/૧૨ નો ઉતારો અથવા ગ્રામીણ રહેઠાણ પ્રમાણપત્ર જરૂરી છે.',
      en: 'Class 10th pass, basic land records (7/12 extract) or rural residency certificate for state agriculture subsidies.'
    },
    opportunities: [
      {
        id: 'opp-agri-01',
        title: 'Maharashtra Krishi Vidyapeeth Agriculture Diploma Admissions',
        type: 'Agri Polytechnic',
        official_url: 'https://mcaer.org',
        deadline: 'August Annual Cycle',
        match_reason: 'Practical hands-on training in dairy cattle breeding, organic cultivation, and farm automation.'
      },
      {
        id: 'opp-dairy-02',
        title: 'NABARD Dairy Entrepreneurship Development Scheme (DEDS)',
        type: 'Government Subsidy',
        official_url: 'https://nabard.org',
        deadline: 'Ongoing FY 2026-27',
        match_reason: 'Up to 33% capital subsidy for rural youth establishing modern dairy and cattle units.'
      },
      {
        id: 'opp-pmkisan-03',
        title: 'PM Kisan Samman Nidhi & Farmer Credit Card (KCC)',
        type: 'Credit & Grant',
        official_url: 'https://pmkisan.gov.in',
        deadline: 'Open Registration',
        match_reason: 'Direct financial assistance and low-interest credit for farm equipment and livestock feed.'
      }
    ],
    chips: {
      en: ['How to apply for Dairy Farm subsidy?', 'Government Agriculture Colleges after 10th?', 'What is the fee for Agri Diploma?', 'Organic farming training centers?'],
      mr: ['दुग्ध व्यवसायासाठी सरकारी अनुदान कसे मिळवायचे?', '१०वीनंतर कृषी पदविका (Agri Diploma) महाविद्यालये कोणती?', 'कृषी पदविकेची फी किती असते?', 'सेंद्रिय शेती प्रशिक्षण केंद्र कोठे आहे?'],
      hi: ['डेयरी फार्मिंग के लिए सरकारी सब्सिडी कैसे लें?', '10वीं के बाद कृषि कॉलेज कौन से हैं?', 'कृषि डिप्लोमा की फीस कितनी है?', 'जैविक खेती का प्रशिक्षण कहां मिलता है?'],
      gu: ['ડેરી ફાર્મ માટે સરકારી સબસિડી કેવી રીતે મેળવવી?', '૧૦મા પછી એગ્રીકલ્ચર કોર્સ?', 'ડિપ્લોમાની ફી કેટલી છે?']
    }
  }
};

function detectCategory(text, student) {
  const combined = `${text} ${student?.aspirations || ''}`.toLowerCase();
  for (const [key, value] of Object.entries(ASPIRATION_KNOWLEDGE_BASE)) {
    if (value.keywords.some(kw => combined.includes(kw))) {
      return key;
    }
  }
  return 'police_defense'; // default rich benchmark
}

export const aiAssistantService = {
  /**
   * Main conversational guidance query.
   * Attempts live backend POST /api/v1/assistant/chat first, falls back gracefully to
   * profile-grounded local counselor engine.
   */
  async sendMessage({ student, message, language = 'en', sessionId = null }) {
    // 1. Try FastAPI Backend
    try {
      const studentId = student?.student_record_id?.length === 36 ? student.student_record_id : '00000000-0000-0000-0000-000000000000';
      const res = await fetch('/api/v1/assistant/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          student_id: studentId,
          message: message,
          language: language,
          session_id: sessionId
        }),
        signal: AbortSignal.timeout(4000)
      });

      if (res.ok) {
        const data = await res.json();
        if (data && data.reply && !data.reply.includes("couldn't locate your profile")) {
          return {
            reply: data.reply,
            suggested_actions: data.suggested_actions || [],
            referenced_opportunities: data.referenced_opportunities || [],
            session_id: data.session_id || sessionId,
            is_fallback: false
          };
        }
      }
    } catch (err) {
      // Backend not running on this port, proceed to intelligent grounded local engine
    }

    // 2. Intelligent Grounded Counselor Fallback Engine
    await new Promise(r => setTimeout(r, 600)); // natural conversational breathing delay

    const studentName = student?.full_name || 'Student';
    const lang = language || student?.preferred_language || 'en';
    const categoryKey = detectCategory(message, student);
    const knowledge = ASPIRATION_KNOWLEDGE_BASE[categoryKey];

    let reply = '';
    const opportunities = knowledge.opportunities;
    const chips = knowledge.chips[lang] || knowledge.chips.en;
    const pathwayText = knowledge.pathway[lang] || knowledge.pathway.en;
    const criteriaText = (knowledge.criteria && (knowledge.criteria[lang] || knowledge.criteria.en)) || '';

    if (lang === 'mr') {
      reply = `नमस्ते ${studentName}! तुमच्या शैक्षणिक पार्श्वभूमी आणि ${knowledge.title} मधील महत्त्वाकांक्षेनुसार, तुमच्यासाठी करिअर मार्गदर्शन खालीलप्रमाणे आहे:\n\n` +
        `🎯 **शिफारस केलेला मार्ग:**\n${pathwayText}\n\n` +
        (criteriaText ? `⚠️ **महत्त्वाचे निकष व पात्रता:**\n${criteriaText}\n\n` : '') +
        `💡 **सल्ला व मार्गदर्शन:**\nवय, शारीरिक निकष आणि मोफत प्रशिक्षणासाठी खालील शासकीय संधी नक्की तपासा. तुम्हाला आणखी कशाबद्दल माहिती हवी आहे?`;
    } else if (lang === 'hi') {
      reply = `नमस्ते ${studentName}! आपके शैक्षणिक विवरण और ${knowledge.title} में रुचि के अनुसार, आपके लिए उपयुक्त करियर मार्गदर्शन यहाँ प्रस्तुत है:\n\n` +
        `🎯 **अनुशंसित करियर मार्ग:**\n${pathwayText}\n\n` +
        (criteriaText ? `⚠️ **महत्वपूर्ण पात्रता एवं शर्तें:**\n${criteriaText}\n\n` : '') +
        `💡 **परामर्श एवं मार्गदर्शन:**\nसरकारी भर्ती और स्कॉलरशिप योजनाओं के विवरण नीचे दिए गए हैं। किसी भी प्रश्न के लिए नीचे दिए गए सुझावों पर टैप करें।`;
    } else if (lang === 'gu') {
      reply = `નમસ્તે ${studentName}! તમારા ${knowledge.title} ના રસ અનુસાર, આ વિગતવાર માર્ગદર્શિકા તૈયાર કરવામાં આવી છે:\n\n` +
        `🎯 **ભલામણ કરેલ પાથવે:**\n${pathwayText}\n\n` +
        (criteriaText ? `⚠️ **મહત્વપૂર્ણ નિયમો:**\n${criteriaText}\n\n` : '') +
        `💡 **માર્ગદર્શન:**\nસરકારી યોજનાઓ અને સ્કોલરશીપ માટે નીચે જુઓ.`;
    } else {
      reply = `Hello ${studentName}! Based on your profile and ambition in **${knowledge.title}**, here is your structured guidance plan:\n\n` +
        `🎯 **Recommended Career Pathway:**\n${pathwayText}\n\n` +
        (criteriaText ? `⚠️ **Important Criteria & Eligibility:**\n${criteriaText}\n\n` : '') +
        `💡 **Counselor Guidance:**\nReview the verified government opportunities and scholarship grants below. Tap any quick suggestion to explore further.`;
    }

    return {
      reply,
      suggested_actions: chips,
      referenced_opportunities: opportunities,
      session_id: sessionId || `local-session-${Date.now()}`,
      is_fallback: true
    };
  },

  /**
   * Generates initial personalized greeting for a student session.
   */
  getInitialGreeting(student, language = 'en') {
    const studentName = student?.full_name || 'Student';
    const aspirations = student?.aspirations || 'Career Opportunities';
    const lang = language || student?.preferred_language || 'en';
    const categoryKey = detectCategory(aspirations, student);
    const knowledge = ASPIRATION_KNOWLEDGE_BASE[categoryKey];

    const chips = knowledge.chips[lang] || knowledge.chips.en;
    const opportunities = knowledge.opportunities;

    let greeting = '';
    if (lang === 'mr') {
      greeting = `जय हिंद ${studentName}! मी तुमचा DreamCatcher AI करिअर मार्गदर्शक आहे. तुमच्या **${aspirations}** ध्येयानुसार, मी तुम्हाला योग्य शिक्षण, सरकारी पोलीस/सैन्य भरती आणि शिष्यवृत्तीबद्दल मार्गदर्शन करेन. तुम्ही काय जाणून घेऊ इच्छिता?`;
    } else if (lang === 'hi') {
      greeting = `जय हिंद ${studentName}! मैं आपका DreamCatcher AI करियर काउंसलर हूँ। आपके **${aspirations}** के लक्ष्य के अनुसार, मैं आपको सही सरकारी भर्ती, प्रशिक्षण और स्कॉलरशिप की जानकारी दूँगा। आप क्या पूछना चाहते हैं?`;
    } else {
      greeting = `Welcome ${studentName}! I am your DreamCatcher AI Career Counselor. Based on your aspiration in **${aspirations}**, I am ready to guide you through official government training, recruitment criteria, and scholarship grants. How can I help you today?`;
    }

    return {
      reply: greeting,
      suggested_actions: chips,
      referenced_opportunities: opportunities
    };
  }
};
