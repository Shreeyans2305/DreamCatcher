// Resilient Local Storage & Sync Queue Engine for DreamCatcher

import { initialVolunteers, initialCamps, initialStudents } from './mockDatabase';

const STORAGE_KEYS = {
  VOLUNTEER: 'dc_volunteer_session',
  CAMPS: 'dc_camps_store',
  STUDENTS: 'dc_students_store',
  ACTIVE_CAMP: 'dc_active_camp_id',
  DRAFT_INTAKE: 'dc_student_intake_draft',
  UI_LANG: 'dc_preferred_ui_lang',
  SYNC_QUEUE: 'dc_pending_sync_queue'
};

export const storageEngine = {
  // Initialize local data stores
  init() {
    if (!localStorage.getItem(STORAGE_KEYS.VOLUNTEER)) {
      localStorage.setItem(STORAGE_KEYS.VOLUNTEER, JSON.stringify(initialVolunteers[0]));
    }
    if (!localStorage.getItem(STORAGE_KEYS.CAMPS)) {
      localStorage.setItem(STORAGE_KEYS.CAMPS, JSON.stringify(initialCamps));
    }
    if (!localStorage.getItem(STORAGE_KEYS.STUDENTS)) {
      localStorage.setItem(STORAGE_KEYS.STUDENTS, JSON.stringify(initialStudents));
    }
    if (!localStorage.getItem(STORAGE_KEYS.ACTIVE_CAMP)) {
      localStorage.setItem(STORAGE_KEYS.ACTIVE_CAMP, 'camp-001');
    }
    if (!localStorage.getItem(STORAGE_KEYS.SYNC_QUEUE)) {
      localStorage.setItem(STORAGE_KEYS.SYNC_QUEUE, JSON.stringify([]));
    }
  },

  // Volunteer Session
  getVolunteer() {
    const raw = localStorage.getItem(STORAGE_KEYS.VOLUNTEER);
    return raw ? JSON.parse(raw) : initialVolunteers[0];
  },

  saveVolunteer(volunteer) {
    localStorage.setItem(STORAGE_KEYS.VOLUNTEER, JSON.stringify(volunteer));
  },

  // Camps
  getCamps() {
    const raw = localStorage.getItem(STORAGE_KEYS.CAMPS);
    return raw ? JSON.parse(raw) : initialCamps;
  },

  addCamp(newCamp) {
    const camps = this.getCamps();
    const updated = [newCamp, ...camps];
    localStorage.setItem(STORAGE_KEYS.CAMPS, JSON.stringify(updated));
    return updated;
  },

  updateCamp(campId, patch) {
    const camps = this.getCamps();
    const updated = camps.map(c => c.camp_id === campId ? { ...c, ...patch } : c);
    localStorage.setItem(STORAGE_KEYS.CAMPS, JSON.stringify(updated));
    return updated;
  },

  getActiveCampId() {
    return localStorage.getItem(STORAGE_KEYS.ACTIVE_CAMP) || 'camp-001';
  },

  setActiveCampId(campId) {
    localStorage.setItem(STORAGE_KEYS.ACTIVE_CAMP, campId);
  },

  // Students & Case Notes
  getStudents() {
    const raw = localStorage.getItem(STORAGE_KEYS.STUDENTS);
    return raw ? JSON.parse(raw) : initialStudents;
  },

  addStudent(student, isOnline = true) {
    const students = this.getStudents();
    const syncStatus = isOnline ? 'synced' : 'pending_sync';
    const record = { ...student, sync_status: syncStatus };
    const updated = [record, ...students];
    localStorage.setItem(STORAGE_KEYS.STUDENTS, JSON.stringify(updated));

    // Update active camp count
    const camps = this.getCamps();
    const campToUpdate = camps.find(c => c.camp_id === student.camp_id);
    if (campToUpdate) {
      this.updateCamp(student.camp_id, {
        students_enrolled: (campToUpdate.students_enrolled || 0) + 1
      });
    }

    if (!isOnline) {
      this.addToSyncQueue(record);
    }

    // Clear saved draft once committed
    this.clearIntakeDraft();
    return record;
  },

  updateStudentCaseNotes(studentId, caseNote) {
    const students = this.getStudents();
    const updated = students.map(s => {
      if (s.student_record_id === studentId) {
        const notes = s.case_notes || [];
        return {
          ...s,
          case_notes: [caseNote, ...notes]
        };
      }
      return s;
    });
    localStorage.setItem(STORAGE_KEYS.STUDENTS, JSON.stringify(updated));
    return updated;
  },

  // KoboToolbox-style draft auto-save
  saveIntakeDraft(draftData) {
    localStorage.setItem(STORAGE_KEYS.DRAFT_INTAKE, JSON.stringify({
      data: draftData,
      timestamp: new Date().toISOString()
    }));
  },

  getIntakeDraft() {
    const raw = localStorage.getItem(STORAGE_KEYS.DRAFT_INTAKE);
    return raw ? JSON.parse(raw) : null;
  },

  clearIntakeDraft() {
    localStorage.removeItem(STORAGE_KEYS.DRAFT_INTAKE);
  },

  // Offline Sync Queue Management
  getSyncQueue() {
    const raw = localStorage.getItem(STORAGE_KEYS.SYNC_QUEUE);
    return raw ? JSON.parse(raw) : [];
  },

  addToSyncQueue(record) {
    const queue = this.getSyncQueue();
    const updated = [...queue, record];
    localStorage.setItem(STORAGE_KEYS.SYNC_QUEUE, JSON.stringify(updated));
  },

  flushSyncQueue() {
    const queue = this.getSyncQueue();
    const students = this.getStudents();

    // Mark all queued records as synced
    const syncedStudents = students.map(s => ({
      ...s,
      sync_status: 'synced'
    }));

    localStorage.setItem(STORAGE_KEYS.STUDENTS, JSON.stringify(syncedStudents));
    localStorage.setItem(STORAGE_KEYS.SYNC_QUEUE, JSON.stringify([]));

    return {
      syncedCount: queue.length,
      timestamp: new Date().toISOString()
    };
  },

  // UI Language
  getUiLanguage() {
    return localStorage.getItem(STORAGE_KEYS.UI_LANG) || 'mr';
  },

  setUiLanguage(langCode) {
    localStorage.setItem(STORAGE_KEYS.UI_LANG, langCode);
  }
};
