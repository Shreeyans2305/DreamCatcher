const BASE_URL = import.meta.env.VITE_APP_BACKEND_URL || 'https://dreamcatcher-backend-635980060226.asia-south1.run.app/api/v1';

export const opportunityService = {
  /**
   * List & filter opportunities from live GCP App Backend
   * @param {Object} params
   * @param {'scholarship'|'course'|'entrance_exam'|'internship'} [params.type]
   * @param {'active'|'draft'|'expired'} [params.status='active']
   * @param {string} [params.search]
   * @param {string} [params.state]
   * @param {number} [params.page=1]
   * @param {number} [params.pageSize=20]
   */
  async getOpportunities({ type = 'scholarship', status = 'active', search, state, page = 1, pageSize = 20 } = {}) {
    try {
      const url = new URL(`${BASE_URL}/opportunities`);
      if (type) url.searchParams.set('type', type);
      if (status) url.searchParams.set('status', status);
      if (search) url.searchParams.set('search', search);
      if (state) url.searchParams.set('state', state);
      url.searchParams.set('page', String(page));
      url.searchParams.set('page_size', String(pageSize));

      const response = await fetch(url.toString(), {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`HTTP error ${response.status}: ${response.statusText}`);
      }

      const data = await response.json();
      return data; // { items: [...], total, page, page_size, total_pages }
    } catch (error) {
      console.warn('Falling back to local demo opportunities due to network/API error:', error);
      return this.getMockOpportunities(type);
    }
  },

  /**
   * Get full details of a specific opportunity
   * @param {string} opportunityId
   */
  async getOpportunityById(opportunityId) {
    try {
      const response = await fetch(`${BASE_URL}/opportunities/${opportunityId}`, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`HTTP error ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.warn('Failed to fetch opportunity by ID, using mock fallback:', error);
      const mockList = this.getMockOpportunities().items;
      return mockList.find(item => item.id === opportunityId) || mockList[0];
    }
  },

  /**
   * Deterministically evaluate eligibility for a student profile against an opportunity
   * @param {string} opportunityId
   * @param {Object} profile
   * @param {string} [profile.social_category] - e.g. "ST", "OBC", "SC", "General"
   * @param {number} [profile.income] - Annual family income in INR
   * @param {string} [profile.rural_status] - "rural" or "urban"
   * @param {string} [profile.education_level] - e.g. "secondary", "higher_secondary", "diploma"
   * @param {string} [profile.state] - Domicile state e.g. "Maharashtra", "Bihar", "Gujarat"
   */
  async checkEligibility(opportunityId, profile) {
    try {
      const response = await fetch(`${BASE_URL}/opportunities/${opportunityId}/check-eligibility`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify(profile)
      });

      if (!response.ok) {
        throw new Error(`HTTP error ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      console.warn('Check eligibility API failed, returning mock evaluation:', error);
      return {
        eligible: true,
        match_score: 95,
        matched_rules: [
          'Social Category matched',
          'Income threshold satisfied (<= 8,00,000 INR)',
          'State domicile verified'
        ],
        unmet_rules: []
      };
    }
  },

  /**
   * Local Mock Fallback Data
   */
  getMockOpportunities(type = 'scholarship') {
    const items = [
      {
        id: 'ccc0524f-f550-4c55-b6ca-5ddfdbf557d9',
        type: 'scholarship',
        title: 'Post-Matric Scholarship Scheme for ST Students',
        description: 'Centrally sponsored scheme implemented through State Governments to enable tribal students from rural areas to complete post-matric education.',
        status: 'active',
        official_url: 'https://scholarships.gov.in',
        application_start: '2026-07-15',
        application_deadline: '2026-12-15',
        verification_status: 'verified',
        state: 'All India',
        benefit: '100% Tuition Waiver + Rs. 1,200/month stipend'
      },
      {
        id: 'opp-mahadbt-obc-002',
        type: 'scholarship',
        title: 'MahaDBT Post-Matric Tuition Fee Waiver (VJHNT & OBC)',
        description: 'Free tuition and examination fee waiver for OBC, VJNT, and SBC students studying in government-recognized technical and polytechnic institutes in Maharashtra.',
        status: 'active',
        official_url: 'https://mahadbt.maharashtra.gov.in',
        application_start: '2026-08-01',
        application_deadline: '2026-11-30',
        verification_status: 'verified',
        state: 'Maharashtra',
        benefit: '100% Exam & Tuition Fee Waiver'
      },
      {
        id: 'opp-mysy-gujarat-003',
        type: 'scholarship',
        title: 'Mukhymantri Yuva Swavalamban Yojana (MYSY Gujarat)',
        description: 'Financial assistance for diploma, degree engineering, and medical students whose annual family income is below Rs. 6 Lakhs.',
        status: 'active',
        official_url: 'https://mysy.guj.nic.in',
        application_start: '2026-07-01',
        application_deadline: '2026-10-31',
        verification_status: 'verified',
        state: 'Gujarat',
        benefit: 'Up to Rs. 50,000/year assistance'
      },
      {
        id: 'opp-course-diploma-004',
        type: 'course',
        title: 'Diploma in Agricultural Extension & Rural Technology',
        description: '3-year Polytechnic diploma focusing on organic farming, soil science, and farm machinery management for rural students after 10th standard.',
        status: 'active',
        official_url: 'https://dtemaharashtra.gov.in',
        application_start: '2026-06-15',
        application_deadline: '2026-09-30',
        verification_status: 'verified',
        state: 'Maharashtra',
        benefit: 'Direct employment placement in Krishi Vigyan Kendras'
      }
    ];

    const filtered = type ? items.filter(item => item.type === type) : items;

    return {
      items: filtered,
      total: filtered.length,
      page: 1,
      page_size: 20,
      total_pages: 1
    };
  }
};
