// Multilingual AI Career & Scholarship Guidance Engine for DreamCatcher

export const dummyAiEngine = {
  // Suggest contextual inquiry chips based on student grade & language
  getSuggestedChips(student) {
    const lang = student?.preferred_language || 'mr';
    const grade = student?.education_level || 'grade_10';

    const chipsByLang = {
      mr: {
        grade_10: [
          '१० वी नंतर लगेच नोकरीसाठी आयटीआय चे कोणते ट्रेड्स बेस्ट आहेत?',
          'पॉलिटेक्निक डिप्लोमा कॉम्प्युटर/मेकॅनिकल प्रवेश प्रक्रिया कशी असते?',
          '१० वी नंतर ओबीसी/एससी साठी महाडीबीटी शिष्यवृत्ती किती मिळते?',
          'पोलीस भरती किंवा सैन्य भरतीसाठी १० वी नंतर काय करावे?'
        ],
        grade_11_12_sci: [
          '१२ वी सायन्स नंतर कृषी (B.Sc Agri) किंवा डेअरी टेक्नॉलॉजी कशी करावी?',
          'सरकारी नर्सिंग (GNM/B.Sc Nursing) मोफत प्रवेश व विद्यावेतन',
          'एमएचटी-सीईटी (MHT-CET) शिवाय इंजिनिअरिंग किंवा फार्मसी करता येते का?'
        ],
        grade_iti: [
          'इलेक्ट्रिशियन किंवा वायरमन ट्रेड नंतर महावितरण मध्ये अप्रेंटिस कशी मिळते?',
          'सोलर टेक्निशियन (सूर्यामित्र) कोर्स कसा करावा व सरकारी अनुदान काय आहे?',
          'आयटीआय नंतर थेट पॉलिटेक्निकच्या दुसऱ्या वर्षात प्रवेश मिळतो का?'
        ],
        default: [
          'ग्रामीण भागातील विद्यार्थ्यांसाठी सरकारी कौशल्य विकास योजना कोणत्या आहेत?',
          'कमवा आणि शिका योजना व शासकीय वसतिगृह सुविधा कशी मिळवावी?',
          'कास्ट व्हॅलिडिटी आणि उत्पन्नाचा दाखला कुठून काढावा?'
        ]
      },
      hi: {
        grade_10: [
          '१०वीं के बाद सरकारी नौकरी और आईटीआई के सबसे अच्छे ट्रेड्स कौन से हैं?',
          'पॉलिटेक्निक डिप्लोमा में सीधे प्रवेश और फीस में छूट कैसे मिलती है?',
          '१०वीं पास छात्रवृत्ति योजनाएं (NSP और पोस्ट-मैट्रिक) के लिए क्या दस्तावेज चाहिए?',
          'कम खर्च में नर्सिंग (ANM/GNM) या पैरामेडिकल कोर्स कैसे करें?'
        ],
        grade_11_12_sci: [
          '१२वीं विज्ञान के बाद बीएससी कृषि या वेटनरी में सरकारी कॉलेज कैसे मिलेगा?',
          'सरकारी नर्सिंग कॉलेज में फ्री ट्रेनिंग और हॉस्टल सुविधा कैसे पाएं?',
          '१२वीं के बाद रेलवे या एसएससी (SSC CHSL) सरकारी परीक्षा की तैयारी कैसे करें?'
        ],
        grade_iti: [
          'आईटीआई इलेक्ट्रीशियन के बाद रेलवे अप्रेंटिसशिप कैसे मिलती है?',
          'प्रधानमंत्री कौशल विकास योजना (PMKVY) के फ्री सर्टिफिकेशन कोर्स',
          'आईटीआई के बाद खुद की दुकान/वर्कशॉप खोलने के लिए मुद्रा लोन कैसे लें?'
        ],
        default: [
          'ग्रामीण छात्रों के लिए फ्री स्किल ट्रेनिंग और सरकारी हॉस्टल योजनाएं',
          'जाति प्रमाण पत्र और आय प्रमाण पत्र बनवाने की सही प्रक्रिया क्या है?'
        ]
      },
      gu: {
        grade_10: [
          '૧૦મા પછી આઈટીઆઈ (ITI) ના કયા ટ્રેડમાં સૌથી ઝડપી નોકરી મળે?',
          'ડિપ્લોમા એન્જિનિયરિંગમાં એડમિશન અને MYSY સ્કોલરશીપ કેવી રીતે મળે?',
          '૧૦મા પછી સરકારી નોકરી અને પોલીસ ભરતી માટે કઈ તૈયારી કરવી?',
          'ઓછા ખર્ચે નર્સિંગ અથવા પેરામેડિકલ કોર્સ કેવી રીતે કરવા?'
        ],
        grade_11_12_sci: [
          '૧૨ સાયન્સ પછી B.Sc એગ્રીકલ્ચરમાં સરકારી કોલેજ કેવી રીતે મળે?',
          'સરકારી નર્સિંગ કોલેજમાં મફત ટ્રેનિંગ અને સ્ટાઈપેન્ડની માહિતી',
          '૧૨મા પછી સરકારી સ્પર્ધાત્મક પરીક્ષાઓની તૈયારી કેવી રીતે કરવી?'
        ],
        default: [
          'મુખ્યમંત્રી યુવા સ્વાવલંબન યોજના (MYSY) અને ડિજિટલ ગુજરાત સ્કોલરશીપ',
          'ગ્રામીણ વિદ્યાર્થીઓ માટે સરકારી હોસ્ટેલ અને શિષ્યવૃત્તિ સહાય'
        ]
      },
      en: {
        grade_10: [
          'Which ITI trades offer immediate employment after Class 10th?',
          'How does Govt Polytechnic Diploma admission work?',
          'What Post-Matric scholarships are available for my caste category?',
          'Direct career pathways in Healthcare / Paramedical after 10th'
        ],
        grade_11_12_sci: [
          'B.Sc Agriculture & Allied Fisheries admission criteria in Govt colleges',
          'Govt GNM / B.Sc Nursing admission with hostel & stipend support',
          'Alternative vocational degrees without expensive coaching'
        ],
        default: [
          'Central and State welfare scholarships & document requirements',
          'PMKVY skill development programs with placement assistance'
        ]
      }
    };

    const langSet = chipsByLang[lang] || chipsByLang.en;
    return langSet[grade] || langSet.default;
  },

  // Generate intelligent initial welcome message in student's native tongue
  generateInitialGreeting(student) {
    const name = student?.full_name || 'विद्यार्थी मित्र';
    const lang = student?.preferred_language || 'mr';
    const edu = student?.education_level_label || '१० वी';
    const aspiration = student?.aspirations || 'करिअर मार्गदर्शन';

    const greetings = {
      mr: `नमस्ते ${name}! मी ड्रीमकेचर एआय करिअर समुपदेशक आहे. तुमची सध्याची शिक्षण पातळी (${edu}) आणि तुमची आवड (${aspiration}) लक्षात घेऊन मी तुम्हाला योग्य करिअर मार्ग, सरकारी डिप्लोमा/आयटीआय कोर्सेस आणि शिष्यवृत्तीबद्दल मार्गदर्शन करेन. तुम्ही खालीलपैकी कोणताही प्रश्न विचारू शकता किंवा तुमचा स्वतःचा प्रश्न टाईप करू शकता.`,
      hi: `नमस्ते ${name}! मैं ड्रीमकैचर एआई करियर काउंसलर हूँ। आपकी वर्तमान कक्षा (${edu}) और आपकी रुचि (${aspiration}) को ध्यान में रखते हुए, मैं आपको उपयुक्त करियर विकल्प, सरकारी आईटीआई/डिप्लोमा कोर्स और छात्रवृत्ति योजनाओं की सटीक जानकारी दूंगा। आप नीचे दिए गए सुझावों में से प्रश्न चुन सकते हैं या अपना प्रश्न पूछ सकते हैं।`,
      gu: `નમસ્તે ${name}! હું ડ્રીમકેચર એઆઈ કારકિર્દી કાઉન્સેલર છું. તમારું હાલનું શિક્ષણ (${edu}) અને તમારી રુચિ (${aspiration}) ધ્યાનમાં રાખીને હું તમને યોગ્ય કોર્સ, આઈટીઆઈ/ડિપ્લોમા અને સરકારી સ્કોલરશીપ વિશે સચોટ માહિતી આપીશ. તમે નીચે આપેલા પ્રશ્નોમાંથી પસંદ કરી શકો છો અથવા તમારો પ્રશ્ન પૂછી શકો છો.`,
      en: `Hello ${name}! I am your DreamCatcher AI Career Counselor. Based on your current education level (${edu}) and your aspirations in (${aspiration}), I will guide you through high-opportunity vocational pathways, government diplomas, and targeted welfare scholarship schemes. How can I help you today?`
    };

    return greetings[lang] || greetings.en;
  },

  // Respond to user query with structured advice, schemes, and actionable next steps
  async generateGuidanceResponse(userMessage, student, history = []) {
    // Simulate brief network reasoning time (300-600ms)
    await new Promise(resolve => setTimeout(resolve, 450));

    const lang = student?.preferred_language || 'mr';
    const cat = student?.category || 'cat_obc';
    const grade = student?.education_level || 'grade_10';
    const lowerMsg = userMessage.toLowerCase();

    // Contextual rule matcher
    if (lowerMsg.includes('iti') || lowerMsg.includes('आयटीआय') || lowerMsg.includes('आईटीआई') || lowerMsg.includes('આઈટીઆઈ')) {
      return this.buildItiResponse(student, lang, cat);
    } else if (lowerMsg.includes('polytechnic') || lowerMsg.includes('diploma') || lowerMsg.includes('पॉलिटेक्निक') || lowerMsg.includes('डिप्लोमा')) {
      return this.buildPolytechnicResponse(student, lang, cat);
    } else if (lowerMsg.includes('scholarship') || lowerMsg.includes('शिष्यवृत्ती') || lowerMsg.includes('छात्रवृत्ति') || lowerMsg.includes('સ્કોલરશીપ') || lowerMsg.includes('mahadbt')) {
      return this.buildScholarshipResponse(student, lang, cat);
    } else if (lowerMsg.includes('nursing') || lowerMsg.includes('नर्सिंग') || lowerMsg.includes('hospital') || lowerMsg.includes('डॉक्टर')) {
      return this.buildNursingResponse(student, lang);
    } else {
      return this.buildGeneralPathwaysResponse(student, lang, userMessage);
    }
  },

  buildItiResponse(student, lang, cat) {
    const responses = {
      mr: {
        text: `**१० वी नंतर शासकीय आयटीआय (Govt ITI) चे सर्वोत्तम ट्रेड्स:**\n\n1. **इलेक्ट्रिशियन (Electrician - २ वर्षे):** महावितरण, रेल्वे आणि खासगी फॅक्टरींमध्ये प्रचंड मागणी. स्वतःचे वायरिंग/रिपेअरिंग दुकान सुरू करता येते.\n2. **फिटर / वेल्डर (Fitter / Welder - १ ते २ वर्षे):** औद्योगिक कंपन्या (MIDC) मध्ये तत्काळ नोकरी आणि परदेशातही संधी.\n3. **सोलर टेक्निशियन (Solar Technician):** शासनाच्या 'सूर्यामित्र' योजनेअंतर्गत मोफत प्रशिक्षण व हमखास रोजगार.\n4. **सीओपीए (COPA - संगणक ऑपरेटर - १ वर्ष):** सरकारी कार्यालये आणि बँकांमध्ये डाटा एंट्री व कॉम्प्युटर ऑपरेटर काम.`,
        pathway: 'शासकीय ITI शिल्प कारागीर प्रशिक्षण (CTS)',
        schemes: [
          cat === 'cat_sc' || cat === 'cat_st' ? 'समाजकल्याण विभाग १००% फी माफी + मासिक विद्यावेतन' : 'महाडीबीटी ओबीसी/ईडब्ल्यूएस ५०% शैक्षणिक शुल्क प्रतिपूर्ती',
          'कौशल्य विकास रोजगार मेळावा थेट नियुक्ती'
        ],
        nextStep: 'iti.maharashtra.gov.in या पोर्टलवर केंद्रीय प्रवेश प्रक्रियेसाठी (CAP) नावनोंदणी करा.'
      },
      hi: {
        text: `**१०वीं के बाद सरकारी आईटीआई (Govt ITI) के शीर्ष ट्रेड्स:**\n\n1. **इलेक्ट्रीशियन (Electrician - 2 वर्ष):** रेलवे, बिजली बोर्ड (DISCOM) और प्राइवेट कंपनियों में सबसे ज्यादा नौकरी के अवसर।\n2. **फिटर / वेल्डर (Fitter / Welder):** मैन्युफैक्चरिंग प्लांट में अप्रेंटिसशिप और तुरंत रोजगार।\n3. **ड्राफ्ट्समैन / सर्वेयर:** निर्माण और सिविल इंफ्रास्ट्रक्चर प्रोजेक्ट्स में मांग।\n4. **COPA (कंप्यूटर ऑपरेटर - 1 वर्ष):** ऑफिस वर्क, डाटा एंट्री और सीएससी सेंटर संचालन हेतु।`,
        pathway: 'सरकारी ITI वोकेशनल क्राफ्ट्समैन कोर्स',
        schemes: [
          cat === 'cat_sc' || cat === 'cat_st' ? 'SC/ST फ्री ट्रेनिंग + हॉस्टल व टूलकिट सहायता' : 'राष्ट्रीय शिक्षुता प्रोत्साहन योजना (NAPS) अप्रेंटिस स्टाइपेंड',
          'प्रधानमंत्री कौशल विकास योजना (PMKVY 4.0)'
        ],
        nextStep: 'राज्य आईटीआई एडमिशन पोर्टल पर ऑनलाइन फॉर्म भरें और 10वीं की मार्कशीट तैयार रखें।'
      },
      gu: {
        text: `**૧૦મા પછી સરકારી આઈટીઆઈ (Govt ITI) ના મુખ્ય ટ્રેડ્સ:**\n\n1. **ઇલેક્ટ્રિશિયન (૨ વર્ષ):** જીઈબી (GEB/UGVCL/DGVCL) અને ઔદ્યોગિક એકમોમાં તાત્કાલિક નોકરીની તકો.\n2. **ફિટર / ટર્નર / વેલ્ડર:** GIDC વિસ્તારમાં મોટી કંપનીઓમાં એપ્રેન્ટિસશીપ.\n3. **વાયરમેન / સોલાર ટેકનિશિયન:** સરકારી સબસિડી અને સોલાર રૂફટોપ ઇન્સ્ટોલેશનમાં સ્વરોજગાર.\n4. **કોપા (COPA):** કમ્પ્યુટર ઓપરેટર અને ઓફિસ આસિસ્ટન્ટ તરીકે કામ.`,
        pathway: 'સરકારી ITI વ્યાવસાયિક તાલીમ',
        schemes: [
          'ડિજિટલ ગુજરાત પોસ્ટ-મેટ્રિક શિષ્યવૃત્તિ સહાય',
          'મુખ્યમંત્રી એપ્રેન્ટિસશીપ યોજના હેઠળ માસિક સ્ટાઈપેન્ડ'
        ],
        nextStep: 'itiadmission.gujarat.gov.in પોર્ટલ પર રજીસ્ટ્રેશન કરાવો.'
      },
      en: {
        text: `**Top High-Placement Govt ITI Trades after Class 10th:**\n\n1. **Electrician (2 Years):** High demand in State Electricity Boards (DISCOMs), Railways, and manufacturing plants.\n2. **Fitter / Machinist (2 Years):** Direct placement pipeline in industrial corridors and auto manufacturing.\n3. **Solar PV Technician (PMKVY Scheme):** Fast-growing renewable energy sector with green job certifications.\n4. **COPA (Computer Operator - 1 Year):** Data entry and digital services operator in govt/private sectors.`,
        pathway: 'Govt ITI Craftsmen Training Scheme (CTS)',
        schemes: [
          cat === 'cat_sc' || cat === 'cat_st' ? 'Social Welfare 100% Fee Exemption + Tool Kit Grant' : 'National Apprenticeship Promotion Scheme (NAPS) Stipend',
          'Skill India Certified Trade Recognition'
        ],
        nextStep: 'Register on the State ITI Admissions portal with Class 10th mark sheet and Caste Certificate.'
      }
    };

    return responses[lang] || responses.en;
  },

  buildPolytechnicResponse(student, lang, cat) {
    const responses = {
      mr: {
        text: `**शासकीय तंत्रनिकेतन (Govt Polytechnic) ३-वर्षीय पदविका:**\n\n- **प्रवेश पात्रता:** १० वी उत्तीर्ण (किमान ३५% गुण).\n- **लोकप्रिय शाखा:** संगणक अभियांत्रिकी (Computer), यांत्रिकी (Mechanical), स्थापत्य (Civil), विद्युत (Electrical).\n- **फायदा:** ३ वर्षांचा डिप्लोमा पूर्ण केल्यानंतर थेट इंजिनिअरिंगच्या दुसऱ्या वर्षात (Direct Second Year B.Tech) प्रवेश मिळतो किंवा कनिष्ठ अभियंता (Junior Engineer) म्हणून नोकरी मिळते.`,
        pathway: '३-वर्षीय शासकीय तंत्रनिकेतन अभियांत्रिकी पदविका (DTE Diploma)',
        schemes: [
          'राजर्षी छत्रपती शाहू महाराज शिक्षण शुल्क शिष्यवृत्ती (EBC - ५०% फी सवलत)',
          cat === 'cat_sc' || cat === 'cat_st' ? 'महाडीबीटी समाजकल्याण १००% शिक्षण व परीक्षा शुल्क प्रतिपूर्ती' : 'अल्पसंख्याक / ओबीसी शिष्यवृत्ती योजना'
        ],
        nextStep: 'DTE महाराष्ट्र (poly26.dtemaharashtra.gov.in) वर कॅप (CAP) राउंडसाठी अर्ज भरा.'
      },
      hi: {
        text: `**सरकारी पॉलिटेक्निक 3-वर्षीय इंजीनियरिंग डिप्लोमा:**\n\n- **योग्यता:** 10वीं पास (गणित और विज्ञान विषयों के साथ).\n- **टॉप ब्रांचेस:** कंप्यूटर साइंस, सिविल, मैकेनिकल, इलेक्ट्रिकल.\n- **लाभ:** 3 साल का डिप्लोमा करने के बाद जूनियर इंजीनियर (JE) भर्ती के पात्र बनते हैं, या सीधे B.Tech के दूसरे वर्ष (लेटरल एंट्री) में प्रवेश ले सकते हैं.`,
        pathway: '3-वर्षीय सरकारी इंजीनियरिंग डिप्लोमा',
        schemes: [
          'पोस्ट-मैट्रिक छात्रवृत्ति योजना (ट्यूशन फीस व हॉस्टल सहायता)',
          'AICTE प्रगति स्कॉलरशिप (छात्राओं के लिए ₹50,000 प्रति वर्ष)'
        ],
        nextStep: 'राज्य पॉलिटेक्निक प्रवेश परीक्षा या मेरिट काउंसलिंग फॉर्म भरें।'
      },
      gu: {
        text: `**સરકારી પોલિટેકનિક ૩-વર્ષીય ડિપ્લોમા એન્જિનિયરિંગ:**\n\n- **લાયકાત:** ૧૦મું પાસ (ગણિત અને વિજ્ઞાન સાથે).\n- **મુખ્ય શાખાઓ:** કમ્પ્યુટર, સિવિલ, મિકેનિકલ, ઇલેક્ટ્રિકલ.\n- **ફાયદો:** ડિપ્લોમા પછી સીધા ડિગ્રી એન્જિનિયરિંગના બીજા વર્ષમાં (D2D) પ્રવેશ અથવા સરકારી જુનિયર એન્જિનિયર તરીકે તક.`,
        pathway: '૩-વર્ષીય સરકારી ડિપ્લોમા એન્જિનિયરિંગ',
        schemes: [
          'મુખ્યમંત્રી યુવા સ્વાવલંબન યોજના (MYSY - ટ્યુશન ફીમાં ૫૦% સહાય)',
          'ડિજિટલ ગુજરાત પોસ્ટ-મેટ્રિક સ્કોલરશીપ'
        ],
        nextStep: 'ACPC પોર્ટલ પર ડિપ્લોમા એડમિશન રજીસ્ટ્રેશન કરાવો.'
      },
      en: {
        text: `**Govt Polytechnic 3-Year Engineering Diploma:**\n\n- **Eligibility:** Class 10th Pass (Mathematics & Science preferred).\n- **Top Streams:** Computer Engineering, Mechanical, Civil, Electrical.\n- **Major Advantage:** Direct Lateral Entry into 2nd Year B.Tech/B.E. (Degree) or Junior Engineer eligibility in PWD, Railways, and Irrigation Depts.`,
        pathway: '3-Year State Polytechnic Diploma (Technical Board)',
        schemes: [
          'National Scholarship Portal (NSP) Post-Matric Scheme',
          'AICTE Pragati Scholarship for Girls (₹50,000/year allowance)'
        ],
        nextStep: 'Submit application in Directorate of Technical Education (DTE) Centralized Admission Process.'
      }
    };

    return responses[lang] || responses.en;
  },

  buildScholarshipResponse(student, lang, cat) {
    const responses = {
      mr: {
        text: `**तुमच्यासाठी पात्र प्रमुख शासकीय शिष्यवृत्ती योजना:**\n\n1. **महाडीबीटी पोस्ट-मॅट्रिक शिष्यवृत्ती (MahaDBT):** १० वी नंतरच्या सर्व अधिकृत अभ्यासक्रमांसाठी १००% किंवा ५०% फी प्रतिपूर्ती.\n2. **सावित्रीबाई फुले कन्या शिक्षण प्रोत्साहन योजना:** ग्रामीण भागातील विद्यार्थिनींसाठी विशेष आर्थिक अनुदान.\n3. **डॉ. पंजाबराव देशमुख वसतिगृह निर्वाह भत्ता:** ज्या विद्यार्थ्यांना शासकीय वसतिगृहात प्रवेश मिळत नाही त्यांना प्रतिमहिना भत्ता.\n4. **बार्टी / सारथी / महाज्योती फेलोशिप:** स्पर्धा परीक्षा व उच्च शिक्षणासाठी विशेष आर्थिक पाठबळ.`,
        pathway: 'महाराष्ट्र शासन MahaDBT शिष्यवृत्ती पोर्टल नोंदणी',
        schemes: [
          'उत्पन्न दाखला (वार्षिक उत्पन्न रु. ८ लाखाच्या आत आवश्यक)',
          'जातीचे प्रमाणपत्र व जात वैधता प्रमाणपत्र (Caste & Validity Certificate)'
        ],
        nextStep: 'mahadbt.maharashtra.gov.in वर आधार ओटीपी द्वारे प्रोफाइल तयार करा.'
      },
      hi: {
        text: `**आपके वर्ग व शिक्षा हेतु मुख्य सरकारी छात्रवृत्तियां:**\n\n1. **राष्ट्रीय छात्रवृत्ति पोर्टल (NSP):** केंद्र सरकार की प्री-मैट्रिक और पोस्ट-मैट्रिक छात्रवृत्तियां।\n2. **राज्य समाज कल्याण विभाग स्कॉलरशिप:** ट्यूशन फीस और परीक्षा शुल्क की शत-प्रतिशत प्रतिपूर्ति।\n3. **प्रधानमंत्री उच्चतर शिक्षा प्रोत्साहन योजना (PM-USP):** कॉलेज व डिप्लोमा स्तर पर वित्तीय सहायता।\n4. **सरकारी निःशुल्क छात्रावास योजना:** दूर-दराज के छात्रों के लिए निःशुल्क भोजन और आवास।`,
        pathway: 'नेशनल स्कॉलरशिप पोर्टल (NSP) एवं राज्य छात्रवृत्ति',
        schemes: [
          'आय प्रमाण पत्र (सक्षम अधिकारी द्वारा निर्गत)',
          'आधार कार्ड से लिंक बैंक खाता (DBT इनेबल्ड)'
        ],
        nextStep: 'scholarships.gov.in पर पंजीकरण करें और संस्थान सत्यापन सुनिश्चित कराएं।'
      },
      gu: {
        text: `**તમારા માટે યોગ્ય સરકારી સ્કોલરશીપ યોજનાઓ:**\n\n1. **મુખ્યમંત્રી યુવા સ્વાવલંબન યોજના (MYSY):** ડિપ્લોમા અને ડિગ્રી કોર્સ માટે ટ્યુશન ફી અને હોસ્ટેલ સહાય.\n2. **ડિજિટલ ગુજરાત પોસ્ટ-મેટ્રિક શિષ્યવૃત્તિ:** SC/ST/OBC/SEBC વિદ્યાર્થીઓ માટે ફી માફી.\n3. **ડો. બાબાસાહેબ આંબેડકર સ્કોલરશીપ:** ઉચ્ચ અભ્યાસ માટે ખાસ નાણાકીય અનુદાન.`,
        pathway: 'ડિજિટલ ગુજરાત અને MYSY સ્કોલરશીપ પોર્ટલ',
        schemes: [
          'આવકનો દાખલો (રૂ. ૨.૫ થી ૬ લાખ મર્યાદા)',
          'જાતિનું પ્રમાણપત્ર અને બેંક આધાર લિંકિંગ'
        ],
        nextStep: 'digitalgujarat.gov.in પર ઓનલાઇન અરજી કરો.'
      },
      en: {
        text: `**Verified Government Scholarship Schemes Matched to Your Profile:**\n\n1. **National Scholarship Portal (NSP Post-Matric):** Complete tuition and examination fee waiver for recognized vocational and technical diplomas.\n2. **State Social Welfare / Backward Class Welfare Schemes:** Monthly maintenance allowance plus direct fee transfer.\n3. **Dr. Ambedkar / Maulana Azad National Fellowship & Grants:** Targeted support for minority and affirmative action beneficiaries.`,
        pathway: 'National Scholarship Portal (NSP) & State Direct Benefit Transfer (DBT)',
        schemes: [
          'Tahsildar Income Certificate (< ₹8.00 Lakhs/annum)',
          'Aadhaar-seeded Active Bank Account (NPCI Mapped)'
        ],
        nextStep: 'Create an account on scholarships.gov.in using Aadhaar authentication.'
      }
    };

    return responses[lang] || responses.en;
  },

  buildNursingResponse(student, lang) {
    const responses = {
      mr: {
        text: `**आरोग्य व नर्सिंग क्षेत्रातील सरकारी अभ्यासक्रम:**\n\n1. **एएनएम (ANM - २ वर्षे):** १० वी / १२ वी नंतर ग्रामीण आरोग्य केंद्रात (PHC) थेट आशा / आरोग्यसेविका नियुक्ती.\n2. **जीएनएम (GNM - ३ वर्षे):** जिल्हा सरकारी रुग्णालयातील नर्सिंग स्कूलमध्ये नाममात्र फी व विद्यावेतनासह प्रशिक्षण.\n3. **लॅब टेक्निशियन (DMLT) / एक्स-रे टेक्निशियन:** २-वर्षीय पॅरामेडिकल डिप्लोमा - सर्व सरकारी व खासगी लॅबमध्ये भरपूर नोकऱ्या.`,
        pathway: 'शासकीय रुग्णालय पॅरामेडिकल व नर्सिंग प्रशिक्षण',
        schemes: [
          'शासकीय नर्सिंग स्कूल मोफत वसतिगृह व मासिक स्टायपेंड',
          'आरोग्य विभाग जिल्हा परिषद भरती प्राधान्य'
        ],
        nextStep: 'जिल्हा शल्यचिकित्सक (Civil Surgeon) कार्यालयात नर्सिंग प्रवेश फॉर्म तपासा.'
      },
      hi: {
        text: `**स्वास्थ्य व नर्सिंग क्षेत्र के सरकारी कोर्सेस:**\n\n1. **ANM (सहायक नर्स - 2 वर्ष):** प्राथमिक स्वास्थ्य केंद्र (PHC) में स्वास्थ्य कार्यकर्ता बनने का अवसर।\n2. **GNM (जनरल नर्सिंग - 3 वर्ष):** जिला अस्पताल नर्सिंग कॉलेज में प्रशिक्षण एवं सरकारी स्टाइपेंड।\n3. **DMLT (मेडिकल लैब टेक्नोलॉजी):** सरकारी और प्राइवेट पैथोलॉजी लैब में सुरक्षित करियर।`,
        pathway: 'सरकारी जिला अस्पताल नर्सिंग व पैरामेडिकल ट्रेनिंग',
        schemes: [
          'राष्ट्रीय स्वास्थ्य मिशन (NHM) के तहत सीधी भर्ती अवसर',
          'सरकारी नर्सिंग छात्रावास निःशुल्क सुविधा'
        ],
        nextStep: 'राज्य स्वास्थ्य विभाग के नर्सिंग एडमिशन पोर्टल पर आवेदन करें।'
      },
      gu: {
        text: `**નર્સિંગ અને આરોગ્ય ક્ષેત્રમાં સરકારી કોર્સ:**\n\n1. **ANM (૨ વર્ષ) / GNM (૩ વર્ષ):** સરકારી હોસ્પિટલ નર્સિંગ સ્કૂલમાં મફત તાલીમ અને માસિક સ્ટાઈપેન્ડ.\n2. **DMLT (લેબ ટેકનિશિયન):** સરકારી પીએચસી/સીએચસી અને ખાનગી લેબમાં ઉત્તમ નોકરીની તકો.`,
        pathway: 'સરકારી હોસ્પિટલ નર્સિંગ તાલીમ',
        schemes: ['આરોગ્ય અને પરિવાર કલ્યાણ વિભાગ શિષ્યવૃત્તિ સહાય'],
        nextStep: 'ગુજરાત નર્સિંગ કાઉન્સિલના પોર્ટલ પર ફોર્મ ભરો.'
      },
      en: {
        text: `**Healthcare, Paramedical & Nursing Opportunities:**\n\n1. **ANM (Auxiliary Nurse Midwife - 2 Yrs):** Direct placement in Primary Health Centers (PHCs) and Sub-Centers.\n2. **GNM (General Nursing & Midwifery - 3 Yrs):** Training in Govt District Hospitals with subsidized lodging & monthly stipends.\n3. **DMLT (Diploma in Medical Lab Tech):** High demand in diagnostics, pathology laboratories, and blood banks.`,
        pathway: 'Govt District Hospital Paramedical & Nursing Diploma',
        schemes: [
          'National Health Mission (NHM) Grassroots Recruitment Quota',
          'Free Govt Nursing Hostel & Food Allowance'
        ],
        nextStep: 'Check admission notifications released by the State Directorate of Medical Education & Research.'
      }
    };

    return responses[lang] || responses.en;
  },

  buildGeneralPathwaysResponse(student, lang, query) {
    const name = student?.full_name || 'विद्यार्थी';
    const responses = {
      mr: {
        text: `तुमचा प्रश्न: "${query}"\n\n${name} यांच्यासाठी ग्रामीण स्तरावर उपलब्ध मुख्य शासकीय व तांत्रिक संधींची रूपरेषा:\n\n1. **शॉर्ट-टर्म स्किल कोर्सेस (PMKVY):** मोफत ३ ते ६ महिन्यांचे प्रमाणपत्र (उदा. मोबाईल रिपेअरिंग, सोलर इन्स्टॉलेशन, आधुनिक कृषी तंत्रज्ञान).\n2. **शासकीय तंत्रनिकेतन / आयटीआय:** थेट रोजगाराभिमुख तांत्रिक शिक्षण.\n3. **स्पर्धा परीक्षा व पोलीस भरती:** १० वी व १२ वी नंतर राज्य राखीव पोलीस (SRPF), वनरक्षक आणि जिल्हा परिषद भरती.\n\nतुम्हाला यापैकी कोणत्या पर्यायाबद्दल अधिक सविस्तर जाणून घ्यायचे आहे?`,
        pathway: 'ग्रामीण कौशल्य व रोजगार मार्गदर्शन कार्यक्रम',
        schemes: ['महाराष्ट्र राज्य कौशल्य विकास मिशन (MSSDS)', 'महाडीबीटी शुल्क प्रतिपूर्ती'],
        nextStep: 'आवश्यक कागदपत्रे (तहसीलदार उत्पन्न दाखला व जातीचा दाखला) तयार ठेवा.'
      },
      hi: {
        text: `आपके प्रश्न "${query}" के आधार पर ${name} के लिए मुख्य मार्गदर्शन:\n\n1. **प्रधानमंत्री कौशल विकास योजना (PMKVY):** 3 से 6 महीने का फ्री स्किल कोर्स और सरकारी सर्टिफिकेट।\n2. **सरकारी आईटीआई एवं पॉलिटेक्निक:** कम खर्च में मजबूत तकनीकी डिग्री और उद्योग में अप्रेंटिसशिप।\n3. **10वीं/12वीं स्तर की प्रतियोगी परीक्षाएं:** रेलवे ग्रुप डी, एसएससी जीडी (SSC GD), वनरक्षक और राज्य पुलिस।\n\nआप इनमें से किस विकल्प की प्रवेश प्रक्रिया या छात्रवृत्ति के बारे में विस्तार से जानना चाहते हैं?`,
        pathway: 'स्किल इंडिया एवं वोकेशनल करियर पाथवे',
        schemes: ['राष्ट्रीय कौशल विकास निगम (NSDC) प्रमाणित कोर्स', 'पोस्ट-मैट्रिक स्कॉलरशिप योजना'],
        nextStep: 'तहसील से आय और निवास प्रमाण पत्र बनवाकर तैयार रखें।'
      },
      gu: {
        text: `તમારા પ્રશ્ન "${query}" મુજબ ${name} માટે મુખ્ય કારકિર્દી વિકલ્પો:\n\n1. **સરકારી આઈટીઆઈ અને ડિપ્લોમા:** ઓછા ખર્ચે ટેકનિકલ તાલીમ અને નોકરીની તકો.\n2. **પ્રધાનમંત્રી કૌશલ વિકાસ યોજના (PMKVY):** નિઃશુલ્ક ટૂંકા ગાળાના કૌશલ્ય વર્ગો.\n3. **૧૦મા/૧૨મા પછી સ્પર્ધાત્મક પરીક્ષાઓ:** પોલીસ કોન્સ્ટેબલ, વનરક્ષક અને પંચાયત તલાટી ભરતી.`,
        pathway: 'ગુજરાત સ્કીલ ડેવલપમેન્ટ મિશન',
        schemes: ['MYSY સહાય યોજના', 'ડિજિટલ ગુજરાત સ્કોલરશીપ'],
        nextStep: 'જરૂરી સરકારી દાખલાઓ તૈયાર રાખો.'
      },
      en: {
        text: `Regarding "${query}", here is targeted career guidance for ${name}:\n\n1. **Short-Term High-Placement Skill Courses (PMKVY 4.0):** Free government-certified courses in Electronics, Solar Tech, and Data Operations.\n2. **Technical Diplomas & ITI:** Cost-effective hands-on vocational training with assured industry apprenticeship.\n3. **Grassroots Public Sector Recruitments:** Forest Guard, State Police, Railway Assistant Loco Pilot & Technician cadres after 10th/ITI.\n\nWhich specific route would you like to explore further?`,
        pathway: 'Skill India & Technical Career Pathway',
        schemes: ['National Apprenticeship Scheme', 'Post-Matric Central Welfare Scholarships'],
        nextStep: 'Ensure family Income Certificate and Caste Certificate are up to date at the Block office.'
      }
    };

    return responses[lang] || responses.en;
  },

  // Synthesize CommCare-style Case Note at the end of a counseling session
  synthesizeCaseNote(student, conversationHistory = []) {
    const lang = student?.preferred_language || 'mr';
    const name = student?.full_name || 'Student';
    const grade = student?.education_level_label || 'Class 10th';
    const cat = student?.category_label || 'OBC';
    const village = student?.village_location || 'Camp Village';

    const caseNote = {
      case_note_id: `case-${Date.now()}`,
      student_record_id: student?.student_record_id,
      session_date: new Date().toISOString(),
      summary: `${name} (${grade}, ${cat}) from ${village} completed an in-depth AI guidance session. Focused on high-placement technical diplomas and government scholarship eligibility.`,
      recommended_pathways: [
        'Govt ITI Craftsmen Training Scheme (Electrician / Wireman / COPA Trade)',
        '3-Year Polytechnic Engineering Diploma (Lateral Entry / Junior Engineer route)',
        'Paramedical & Healthcare Technician Certification (District Civil Hospital)'
      ],
      eligible_schemes: [
        'Post-Matric Scholarship Scheme (Tuition & Exam Fees waiver)',
        'Government Free Residential Hostel & Lodging Scheme',
        'State Skill Development Apprenticeship Stipend'
      ],
      action_items: [
        'Obtain Tahsildar Income Certificate (< Rs. 8 Lakhs/year) from nearest Setu / CSC Center.',
        'Link Aadhaar with Bank Account for direct benefit transfer (DBT).',
        'Complete online registration on State Centralized Admission Portal.'
      ]
    };

    return caseNote;
  }
};
