import { supabase, isSupabaseConfigured } from './supabaseClient';

// Local storage fallback keys for offline / unconfigured mode
const MOCK_EVENTS_KEY = 'dreamcatcher_mock_events';
const MOCK_STUDENTS_KEY = 'dreamcatcher_mock_students';
const MOCK_QUALIFICATIONS_KEY = 'dreamcatcher_mock_qualifications';
const MOCK_ADMIN_KEY = 'dreamcatcher_mock_admin';

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
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      if (authError || !user) return null;

      const { data, error } = await supabase
        .from('admins')
        .select('*')
        .eq('admin_id', user.id)
        .single();

      if (error) throw error;
      return data;
    }

    // Mock fallback
    return getMockData(MOCK_ADMIN_KEY, {
      admin_id: 'adm-demo-001',
      government_id: 'GOV-MH-SAT-2026',
      name: 'Anand Kulkarni',
      email: 'anand.kulkarni@gov.in',
      mobile_number: '9876543210'
    });
  },

  async signUpAdmin({ email, password, government_id, name, mobile_number }) {
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            government_id,
            name,
            mobile_number
          }
        }
      });
      if (error) throw error;
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
    if (isSupabaseConfigured()) {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      });
      if (error) throw error;
      return data;
    }

    // Mock fallback
    const mockAdmin = {
      admin_id: 'adm-demo-001',
      government_id: 'GOV-MH-SAT-2026',
      name: 'Anand Kulkarni',
      email,
      mobile_number: '9876543210'
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
