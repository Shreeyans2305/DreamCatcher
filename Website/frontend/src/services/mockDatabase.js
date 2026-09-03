// Mock Database with authentic Indian rural data for DreamCatcher

export const initialVolunteers = [
  {
    volunteer_id: 'DC-VOL-2026-00042',
    full_name: 'Anand Kulkarni',
    role_type: 'teacher',
    role_label: 'Government High School Teacher',
    organization_name: 'Zilla Parishad High School, Shindewadi',
    phone_number: '9822014589',
    email: 'anand.kulkarni@zpmaharashtra.gov.in',
    preferred_ui_language: 'mr',
    district: 'Satara',
    state: 'Maharashtra',
    is_active: false, // Default to not authenticated so user lands on full-screen login page
    created_at: '2026-08-15T09:00:00Z'
  }
];

export const initialCamps = [
  {
    camp_id: 'camp-001',
    volunteer_id: 'DC-VOL-2026-00042',
    camp_name: 'Shindewadi ZP School Career & Scholarship Camp',
    village_town: 'Shindewadi',
    district: 'Satara',
    state: 'Maharashtra',
    scheduled_date: '2026-09-03',
    start_time: '09:30',
    end_time: '16:30',
    status: 'ongoing',
    students_enrolled: 8,
    created_at: '2026-08-28T10:00:00Z'
  },
  {
    camp_id: 'camp-002',
    volunteer_id: 'DC-VOL-2026-00042',
    camp_name: 'Patan Block Tribal Youth Guidance Drive',
    village_town: 'Patan',
    district: 'Satara',
    state: 'Maharashtra',
    scheduled_date: '2026-08-25',
    start_time: '10:00',
    end_time: '17:00',
    status: 'completed',
    students_enrolled: 19,
    created_at: '2026-08-18T11:00:00Z'
  },
  {
    camp_id: 'camp-003',
    volunteer_id: 'DC-VOL-2026-00042',
    camp_name: 'Dahiwadi Secondary School Camp',
    village_town: 'Dahiwadi',
    district: 'Satara',
    state: 'Maharashtra',
    scheduled_date: '2026-09-12',
    start_time: '10:00',
    end_time: '15:00',
    status: 'upcoming',
    students_enrolled: 0,
    created_at: '2026-09-01T08:30:00Z'
  }
];

export const initialStudents = [
  {
    student_record_id: 'stu-001',
    camp_id: 'camp-001',
    camp_name: 'Shindewadi ZP School Career & Scholarship Camp',
    volunteer_id: 'DC-VOL-2026-00042',
    full_name: 'Pooja Vitthal Jadhav',
    age_years: 15,
    date_of_birth: '2011-04-12',
    student_contact_number: '',
    guardian_contact_number: '9764023190',
    village_location: 'Shindewadi',
    education_level: 'grade_10',
    education_level_label: 'Class 10th (SSC Aspirant)',
    category: 'cat_obc',
    category_label: 'OBC (Other Backward Classes)',
    preferred_language: 'mr',
    aspirations: 'Government Polytechnic Diploma in Computer Engineering or GNM Nursing',
    sync_status: 'synced',
    created_at: '2026-09-03T10:15:00Z',
    case_notes: [
      {
        case_note_id: 'case-001',
        session_date: '2026-09-03T10:30:00Z',
        summary: 'Pooja is keen on short-cycle technical diplomas after 10th to support family income early. She scored 78% in prelims.',
        recommended_pathways: [
          '3-Year Govt Polytechnic Diploma in Computer/IT (Direct admission based on 10th marks)',
          'ANM / GNM Nursing courses at District General Hospital Nursing School',
          'ITI COPA (Computer Operator and Programming Assistant) 1-year trade'
        ],
        eligible_schemes: [
          'MahaDBT Post-Matric OBC Scholarship (Tuition fee waiver up to 50%)',
          'Savitribai Phule Special Incentive for Girls Education'
        ],
        action_items: [
          'Apply for Non-Creamy Layer (NCL) certificate at Taluka Tahsildar office before DTE CAP round.',
          'Register for MahaDBT profile using Aadhaar OTP.'
        ]
      }
    ]
  },
  {
    student_record_id: 'stu-002',
    camp_id: 'camp-001',
    camp_name: 'Shindewadi ZP School Career & Scholarship Camp',
    volunteer_id: 'DC-VOL-2026-00042',
    full_name: 'Rahul Sanjay Kamble',
    age_years: 17,
    date_of_birth: '2009-08-20',
    student_contact_number: '9890123456',
    guardian_contact_number: '9890123456',
    village_location: 'Vele Hamlet',
    education_level: 'grade_iti',
    education_level_label: 'ITI / Vocational Diploma Aspirant',
    category: 'cat_sc',
    category_label: 'SC (Scheduled Caste)',
    preferred_language: 'mr',
    aspirations: 'Electrician trade, Solar technician or MSEDCL Apprentice',
    sync_status: 'synced',
    created_at: '2026-09-03T11:00:00Z',
    case_notes: [
      {
        case_note_id: 'case-002',
        session_date: '2026-09-03T11:20:00Z',
        summary: 'Rahul wants immediate hands-on technical skills with high regional placement demand.',
        recommended_pathways: [
          'Govt ITI Satara - 2-Year Electrician / Wireman Craftsmen Training Scheme (CTS)',
          'Suryamitra Solar Technician Skill Program (Skill India / PMKVY 4.0)',
          'Apprenticeship at MSEDCL (Maharashtra State Electricity Distribution)'
        ],
        eligible_schemes: [
          'Social Welfare Dept SC Freeship Scheme (100% tuition + exam fees waiver + monthly stipend)',
          'BARTI Pune Free ITI Tool Kit Grant'
        ],
        action_items: [
          'Submit ITI Maharashtra admission portal form before round deadline.',
          'Link bank account with Aadhaar for direct benefit transfer (DBT).'
        ]
      }
    ]
  },
  {
    student_record_id: 'stu-003',
    camp_id: 'camp-002',
    camp_name: 'Patan Block Tribal Youth Guidance Drive',
    volunteer_id: 'DC-VOL-2026-00042',
    full_name: 'Sunita Devidas Kokani',
    age_years: 16,
    date_of_birth: '2010-01-14',
    student_contact_number: '',
    guardian_contact_number: '9421098765',
    village_location: 'Dhebewadi',
    education_level: 'grade_10',
    education_level_label: 'Class 10th (SSC Aspirant)',
    category: 'cat_st',
    category_label: 'ST (Scheduled Tribe)',
    preferred_language: 'hi',
    aspirations: 'Teacher / B.Ed or Vanrakshak (Forest Department)',
    sync_status: 'synced',
    created_at: '2026-08-25T11:30:00Z',
    case_notes: [
      {
        case_note_id: 'case-003',
        session_date: '2026-08-25T12:00:00Z',
        summary: 'Sunita excels in biology and geography. Explored 11th-12th Arts/Science stream with Tribal Welfare residential hostel support.',
        recommended_pathways: [
          '11th-12th Arts/Science in Eklavya Model Residential School (EMRS)',
          'D.El.Ed / B.El.Ed for Primary School Teacher Pathway',
          'Forest Guard / Vanrakshak competitive recruitment examination'
        ],
        eligible_schemes: [
          'National Fellowship & Post-Matric Scholarship for ST Students (Ministry of Tribal Affairs)',
          'Tribal Development Dept Govt Hostel Accommodation with free lodging & boarding'
        ],
        action_items: [
          'Collect Tribe Validity Certificate documentation.',
          'Register on Tribal Development Department portal.'
        ]
      }
    ]
  },
  {
    student_record_id: 'stu-004',
    camp_id: 'camp-002',
    camp_name: 'Patan Block Tribal Youth Guidance Drive',
    volunteer_id: 'DC-VOL-2026-00042',
    full_name: 'Mahesh Suresh Rathod',
    age_years: 18,
    date_of_birth: '2008-05-19',
    student_contact_number: '9158765432',
    guardian_contact_number: '9158765432',
    village_location: 'Malharpeth',
    education_level: 'grade_11_12_sci',
    education_level_label: 'Class 11th/12th (Science)',
    category: 'cat_ews',
    category_label: 'EWS (Economically Weaker Section)',
    preferred_language: 'en',
    aspirations: 'B.Sc Agriculture / Agri-business / Dairy Technology',
    sync_status: 'synced',
    created_at: '2026-08-25T14:00:00Z',
    case_notes: [
      {
        case_note_id: 'case-004',
        session_date: '2026-08-25T14:30:00Z',
        summary: 'Family owns 2 acres of land; wants modern agricultural technology degree to boost organic yields and dairy farming.',
        recommended_pathways: [
          '4-Year B.Sc (Hons) Agriculture via MCAER CET examination',
          'B.Tech Dairy Technology / Agricultural Engineering',
          'Krishi Vigyan Kendra (KVK) Agri-entrepreneurship incubation certificate'
        ],
        eligible_schemes: [
          'Rajarshi Chhatrapati Shahu Maharaj Shikshan Shulkh Shishyavrutti (EBC / EWS 50% fee concession)',
          'ICAR National Talent Scholarship (NTS)'
        ],
        action_items: [
          'Obtain Tahsildar Income Certificate (< Rs. 8 Lakhs/year) for EWS eligibility.',
          'Prepare for MHT-CET (PCB group) for agriculture admissions.'
        ]
      }
    ]
  }
];
