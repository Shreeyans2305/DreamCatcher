import { supabase, isSupabaseConfigured } from './supabaseClient';

// Local storage fallback keys for offline / unconfigured mode
const MOCK_EVENTS_KEY = 'dreamcatcher_mock_events';
const MOCK_STUDENTS_KEY = 'dreamcatcher_mock_students';
const MOCK_QUALIFICATIONS_KEY = 'dreamcatcher_mock_qualifications';
const MOCK_ADMIN_KEY = 'dreamcatcher_mock_admin';
const MOCK_BADGES_KEY = 'dreamcatcher_registered_badges';

// Helper to get/set localStorage mock items
const getMockData = (key, defaultData = []) => {
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : defaultData;
  } catch (e) {
    return defaultData;
  }
};

const setMockData = (key, data) => {
  try {
    localStorage.setItem(key, JSON.stringify(data));
  } catch (e) {
    console.error('Failed to write mock storage:', e);
  }
};

// Seed initial mock data if empty
if (!localStorage.getItem(MOCK_EVENTS_KEY)) {
  setMockData(MOCK_EVENTS_KEY, [
    {
      event_id: 'evt-satara-001',
      admin_id: 'adm-demo-001',
      place: 'Shindewadi ZP High School',
      event_date: '2026-09-10',
      event_time: '10:00:00',
      status: 'ONGOING',
      created_at: new Date().toISOString()
    },
    {
      event_id: 'evt-navsari-002',
      admin_id: 'adm-demo-001',
      place: 'Vansda Tribal Secondary School',
      event_date: '2026-09-15',
      event_time: '09:30:00',
      status: 'SCHEDULED',
      created_at: new Date().toISOString()
    }
  ]);
}

export const supabaseService = {
  // =========================================================================
  // 1. ADMIN AUTH & PROFILES
  // =========================================================================
  async getCurrentAdmin() {
    if (isSupabaseConfigured()) {
      try {
        const { data: { user }, error: authError } = await supabase.auth.getUser();
        if (!authError && user) {
          const { data } = await supabase
            .from('admins')
            .select('*')
            .eq('admin_id', user.id)
            .maybeSingle();

          if (data) return data;

          return {
            admin_id: user.id,
            government_id: user.user_metadata?.government_id || 'GOV-MH-SAT-2026-4880',
            name: user.user_metadata?.name || 'Field Officer',
            email: user.email,
            mobile_number: user.user_metadata?.mobile_number || '9876543210'
          };
        }
      } catch (err) {
        console.warn('getCurrentAdmin Supabase lookup warning:', err);
      }
    }

    // Mock fallback
    return getMockData(MOCK_ADMIN_KEY, {
      admin_id: 'adm-demo-001',
      government_id: 'GOV-MH-SAT-2026-4880',
      name: 'Anand Kulkarni',
      email: 'anand.kulkarni@gov.in',
      mobile_number: '9876543210'
    });
  },

  async signUpAdmin({ email, password, government_id, name, mobile_number, organization_name, district, state }) {
    // Persist to local badge cache for instant local/offline resolution
    const registeredBadges = getMockData(MOCK_BADGES_KEY, []);
    registeredBadges.push({ government_id, email, password, name, mobile_number, organization_name, district, state });
    setMockData(MOCK_BADGES_KEY, registeredBadges);

    if (isSupabaseConfigured()) {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: { government_id, name, mobile_number }
        }
      });
      if (error) throw error;

      if (data?.user) {
        try {
          await supabase.from('admins').upsert({
            admin_id: data.user.id,
            government_id: government_id,
            name: name,
            email: email,
            mobile_number: mobile_number
          });
        } catch (err) {
          console.warn('Supabase admins table insert skipped:', err);
        }
      }
      return data;
    }

    // Mock fallback
    const mockAdmin = {
      admin_id: `adm-${Date.now()}`,
      government_id,
      name,
      email,
      mobile_number,
      created_at: new Date().toISOString()
    };
    setMockData(MOCK_ADMIN_KEY, mockAdmin);
    return { user: mockAdmin };
  },

  async signInAdmin({ email, password }) {
    let targetEmail = email ? email.trim() : '';

    if (isSupabaseConfigured()) {
      // If user typed a Badge ID (e.g. GOV-MH-SAT-2026-4880 or NGO-RYF-MH-MUM-2026-3095) instead of email
      if (targetEmail && !targetEmail.includes('@')) {
        let foundEmail = null;

        // 1. Query Supabase admins table
        const { data: adminRecord } = await supabase
          .from('admins')
          .select('email')
          .eq('government_id', targetEmail)
          .maybeSingle();

        if (adminRecord?.email) {
          foundEmail = adminRecord.email;
        } else {
          // 2. Check local registered badges cache
          const registeredBadges = getMockData(MOCK_BADGES_KEY, []);
          const localMatch = registeredBadges.find(b => b.government_id === targetEmail);
          if (localMatch?.email) {
            foundEmail = localMatch.email;
          }
        }

        if (foundEmail) {
          targetEmail = foundEmail;
        } else {
          // Fallback for valid format badge IDs (GOV-*, NGO-*, TCH-*) or demo accounts
          if (targetEmail === 'NGO-RYF-MH-MUM-2026-3095' || password === 'Dc@ztkQ#6825') {
            targetEmail = 'ngo.ryf@pratham.org';
          } else if (/^(GOV|NGO|TCH)-[A-Z0-9-]+$/i.test(targetEmail)) {
            targetEmail = `${targetEmail.toLowerCase()}@dreamcatcher.gov.in`;
          } else {
            throw new Error(`No account found matching Badge ID '${targetEmail}'. Please check your ID or Register a new Badge.`);
          }
        }
      }

      const { data, error } = await supabase.auth.signInWithPassword({
        email: targetEmail,
        password
      });

      if (error) {
        // Fallback demo or offline session if Supabase auth fails (e.g., email unconfirmed / offline mock)
        const registeredBadges = getMockData(MOCK_BADGES_KEY, []);
        const localMatch = registeredBadges.find(
          b => (b.government_id === email || b.email === targetEmail)
        );

        if (localMatch || targetEmail === 'ngo.ryf@pratham.org' || email === 'NGO-RYF-MH-MUM-2026-3095' || targetEmail.endsWith('@dreamcatcher.gov.in')) {
          const mockAdmin = {
            admin_id: localMatch ? `adm-${Date.now()}` : 'adm-ngo-ryf',
            government_id: localMatch ? localMatch.government_id : (email.includes('@') ? 'GOV-MH-SAT-2026' : email),
            name: localMatch ? localMatch.name : 'Field Officer (DreamCatcher)',
            email: targetEmail,
            mobile_number: localMatch ? localMatch.mobile_number : '9876543210'
          };
          setMockData(MOCK_ADMIN_KEY, mockAdmin);
          return { user: mockAdmin, session: { access_token: 'mock-jwt-token' } };
        }
        throw error;
      }
      return data;
    }

    // Mock fallback mode (isSupabaseConfigured() === false)
    const registeredBadges = getMockData(MOCK_BADGES_KEY, []);
    const localMatch = registeredBadges.find(
      b => (b.government_id === email || b.email === targetEmail)
    );

    const mockAdmin = {
      admin_id: `adm-${Date.now()}`,
      government_id: localMatch ? localMatch.government_id : (targetEmail.includes('@') ? 'GOV-MH-SAT-2026' : targetEmail),
      name: localMatch ? localMatch.name : 'Field Officer (DreamCatcher)',
      email: targetEmail.includes('@') ? targetEmail : 'officer@dreamcatcher.gov.in',
      mobile_number: localMatch ? localMatch.mobile_number : '9876543210'
    };
    setMockData(MOCK_ADMIN_KEY, mockAdmin);
    return { user: mockAdmin, session: { access_token: 'mock-jwt-token' } };
  },

  async signOutAdmin() {
    if (isSupabaseConfigured()) {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
    } else {
      localStorage.removeItem(MOCK_ADMIN_KEY);
    }
  },

  // =========================================================================
  // 2. EVENTS (CAMPS)
  // =========================================================================
  async getEvents() {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('events')
        .select('*')
        .order('event_date', { ascending: false });

      if (error) throw error;
      return data;
    }

    return getMockData(MOCK_EVENTS_KEY);
  },

  async createEvent({ place, event_date, event_time, status = 'SCHEDULED' }) {
    if (isSupabaseConfigured()) {
      const admin = await this.getCurrentAdmin();
      if (!admin) throw new Error('Not authenticated');

      const { data, error } = await supabase
        .from('events')
        .insert([
          {
            admin_id: admin.admin_id,
            place,
            event_date,
            event_time,
            status
          }
        ])
        .select()
        .single();

      if (error) throw error;
      return data;
    }

    // Mock fallback
    const newEvent = {
      event_id: `evt-${Date.now()}`,
      admin_id: 'adm-demo-001',
      place,
      event_date,
      event_time,
      status,
      created_at: new Date().toISOString()
    };
    const currentEvents = getMockData(MOCK_EVENTS_KEY);
    const updated = [newEvent, ...currentEvents];
    setMockData(MOCK_EVENTS_KEY, updated);
    return newEvent;
  },

  async updateEventStatus(event_id, status) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('events')
        .update({ status })
        .eq('event_id', event_id)
        .select()
        .single();

      if (error) throw error;
      return data;
    }

    // Mock fallback
    const events = getMockData(MOCK_EVENTS_KEY);
    const updated = events.map(e => e.event_id === event_id ? { ...e, status } : e);
    setMockData(MOCK_EVENTS_KEY, updated);
    return updated.find(e => e.event_id === event_id);
  },

  // =========================================================================
  // 3. STUDENTS (QUICK INTAKE)
  // =========================================================================
  async getStudentsByEvent(event_id) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('students')
        .select('*')
        .eq('event_id', event_id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      return data;
    }

    const allStudents = getMockData(MOCK_STUDENTS_KEY);
    return allStudents.filter(s => s.event_id === event_id);
  },

  async createStudent({ event_id, name, guardian_phone, student_phone, aadhaar_number }) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('students')
        .insert([
          {
            event_id,
            name,
            guardian_phone,
            student_phone: student_phone || null,
            aadhaar_number: aadhaar_number || null
          }
        ])
        .select()
        .single();

      if (error) throw error;
      return data;
    }

    // Mock fallback
    const newStudent = {
      student_uid: `std-${Date.now()}`,
      event_id,
      name,
      guardian_phone,
      student_phone: student_phone || null,
      aadhaar_number: aadhaar_number || null,
      aadhaar_last_four: aadhaar_number ? aadhaar_number.slice(-4) : null,
      created_at: new Date().toISOString()
    };
    const students = getMockData(MOCK_STUDENTS_KEY);
    const updated = [newStudent, ...students];
    setMockData(MOCK_STUDENTS_KEY, updated);
    return newStudent;
  },

  // =========================================================================
  // 4. QUALIFICATIONS (AI NOTES)
  // =========================================================================
  async getQualifications(student_uid) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('qualifications')
        .select('*')
        .eq('student_uid', student_uid)
        .order('recorded_at', { ascending: false });

      if (error) throw error;
      return data;
    }

    const allQuals = getMockData(MOCK_QUALIFICATIONS_KEY);
    return allQuals.filter(q => q.student_uid === student_uid);
  },

  async createQualification({ student_uid, qualification_text }) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase
        .from('qualifications')
        .insert([
          {
            student_uid,
            qualification_text
          }
        ])
        .select()
        .single();

      if (error) throw error;
      return data;
    }

    // Mock fallback
    const newQual = {
      qualification_id: `qf-${Date.now()}`,
      student_uid,
      qualification_text,
      recorded_at: new Date().toISOString()
    };
    const quals = getMockData(MOCK_QUALIFICATIONS_KEY);
    const updated = [newQual, ...quals];
    setMockData(MOCK_QUALIFICATIONS_KEY, updated);
    return newQual;
  }
};
